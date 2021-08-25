cmake_minimum_required(VERSION 2.8.3)
project(situation_awareness_example)

find_package(catkin REQUIRED 
                knowrob)

catkin_package(
  DEPENDS knowrob
)

install(DIRECTORY launch/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/launch)

install(DIRECTORY owl/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/owl)

