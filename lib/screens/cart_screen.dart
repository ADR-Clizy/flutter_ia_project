import 'package:app_projet/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projet/models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    double total = cart.activities.fold(0, (sum, item) => sum + item.price);
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Mon Panier - $total €'),
          backgroundColor: Colors.purple,
        ),
        body: cart.activities.isEmpty
            ? const Center(child: Text('Votre panier est vide.'))
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Divider(
                        color: Colors.black,
                      )),
                  itemCount: cart.activities.length,
                  itemBuilder: (context, index) {
                    Activity activity = cart.activities[index];
                    return Row(children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Hero(
                        tag: 'activityImage${activity.title}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            activity.preview,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                activity.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 17,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    activity.place,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.euro_rounded,
                                  size: 17,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    activity.price.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          cart.remove(activity);
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ]);
                  },
                )));
  }
}
