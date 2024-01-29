import 'package:app_projet/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:app_projet/models/activity.dart';
import 'package:provider/provider.dart';

class ActivityDetails extends StatefulWidget {
  final Activity activity;

  const ActivityDetails({super.key, required this.activity});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  bool isChanging = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    bool isAddedToCart = cart.activities.any((a) =>
        a.title == widget.activity.title &&
        a.place == widget.activity.place &&
        a.price == widget.activity.price &&
        a.category == widget.activity.category &&
        a.minParticipants == widget.activity.minParticipants &&
        a.preview == widget.activity.preview);

    Widget buttonChild = isChanging
        ? Icon(isAddedToCart ? Icons.close : Icons.done, color: Colors.white)
        : Text(isAddedToCart ? 'Retirer du panier' : 'Ajouter au panier');

    Future<void> addToCart() async {
      setState(() => isChanging = true);

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isAddedToCart = true;
        isChanging = false;
      });
    }

    Future<void> removeFromCart() async {
      setState(() => isChanging = true);

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isAddedToCart = false;
        isChanging = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: Text(widget.activity.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'activityImage${widget.activity.title}',
              child: Image.network(widget.activity.preview, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Icon(Icons.category,
                          size: 17, color: Colors.purple),
                      const SizedBox(width: 10),
                      Text(
                        'Catégorie : ${widget.activity.category}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 17, color: Colors.purple),
                      const SizedBox(width: 10),
                      Text(
                        widget.activity.place,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 17, color: Colors.purple),
                      const SizedBox(width: 10),
                      Text(
                        'Participant(s) minimum : ${widget.activity.minParticipants}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.euro_symbol,
                          size: 17, color: Colors.purple),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.activity.price.toStringAsFixed(2)}€',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isAddedToCart) {
                          await removeFromCart();
                          cart.remove(widget.activity);
                        } else {
                          await addToCart();
                          cart.add(widget.activity);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isAddedToCart ? Colors.red : Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: buttonChild,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
