import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/providers/providers.dart';

class LocationAddSCreen extends ConsumerStatefulWidget {
  const LocationAddSCreen({super.key});

  @override
  ConsumerState<LocationAddSCreen> createState() => _LocationAddSCreenState();
}

class _LocationAddSCreenState extends ConsumerState<LocationAddSCreen> {
  TextEditingController contact_info = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController ticket_price = TextEditingController();
  TextEditingController working_hours = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                //name
                TextField(
                  controller: name,

                  decoration: InputDecoration(
                    labelText: 'name',
                    prefixIcon: const Icon(Icons.perm_identity_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),

                //description
                TextField(
                  controller: description,
                  decoration: InputDecoration(
                    labelText: 'description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),

                //location
                TextField(
                  controller: location,
                  decoration: InputDecoration(
                    labelText: 'location',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),

                //wortking_hours
                TextField(
                  controller: working_hours,
                  decoration: InputDecoration(
                    labelText: 'working_hours',
                    prefixIcon: const Icon(Icons.lock_clock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),

                //ticket_price
                TextField(
                  controller: ticket_price,
                  decoration: InputDecoration(
                    labelText: 'ticket_price',
                    prefixIcon: const Icon(Icons.price_check),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),
                // contact
                TextField(
                  controller: contact_info,
                  decoration: InputDecoration(
                    labelText: 'contact_phone',
                    prefixIcon: const Icon(Icons.contact_phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200], // Fill color
                  ),
                  style: const TextStyle(color: Colors.black), // Text color
                ),

                const SizedBox(
                  height: 30,
                ),

                Consumer(builder: (context, ref, child) {
                  return IconButton(
                    onPressed: () {
                      ref.read(chatProvider).sendPlaceMessage(
                          name.text.trim(),
                          description.text.trim(),
                          location.text.trim(),
                          working_hours.text.trim(),
                          ticket_price.text.trim(),
                          contact_info.text.trim());

                      name.clear();
                      description.clear();
                      location.clear();
                      working_hours.clear();
                      ticket_price.clear();
                      contact_info.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
