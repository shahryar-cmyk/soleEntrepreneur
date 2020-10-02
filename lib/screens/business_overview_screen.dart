import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class BusinessOverViewScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: CircleAvatar(
            backgroundImage:
                NetworkImage(Provider.of<Auth>(context).userAvatar),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
                child: Column(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Text(
                          'Featured Posts',
                          style: Theme.of(context).textTheme.headline6,
                        )),
                    Flexible(
                      flex: 2,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                ),
                                Container(
                                  width: 60,
                                  child: Text(
                                    'Thiis fjsl sfjsl',
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    Flexible(
                        flex: 1,
                        child: Text(
                          'Trending Posts',
                          style: Theme.of(context).textTheme.headline6,
                        )),
                    Flexible(
                      flex: 2,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                ),
                                Container(
                                  width: 60,
                                  child: Text(
                                    'Thiis fjsl sfjsl',
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Picks for you',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  // scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                      ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                        ),
                        Container(
                          width: 60,
                          child: Text(
                            'Thiis fjsl sfjsl',
                            maxLines: 2,
                          ),
                        )
                      ],
                    );
                  }),
            ),

            // ListView.separated(
            //     itemBuilder: (context, index) {
            //       return Container(
            //         color: Colors.red,
            //       );
            //     },
            //     separatorBuilder: (context, index) => Divider(),
            //     itemCount: 20),
            // Text(
            //   'Featured Posts',
            //   style: Theme.of(context).textTheme.headline6,
            // ),
            // Flexible(
            //   flex: 1,
            //   child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 10,
            //       itemBuilder: (context, index) {
            //         return CircleAvatar();
            //       }),
            // )
          ],
        ));
  }
}
