From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: [ANNOUNCE] conntrackd-0.9.2 released
Date: Wed, 17 Jan 2007 16:06:48 +0100
Message-ID: <20070117150648.GC14333@outback.rfc2324.org>
References: <45AD8EA7.6030705@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <45AD8EA7.6030705@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Am Mittwoch, den 17 Januar hub Pablo Neira Ayuso folgendes in die Tasten:

Hi!

> This project is under development, people feeling brave are encouraged
> to test a send nice reports ;)

I noticed two things:

 * conntrackd isn´t release regarding to changelog.
 * see attached two patches which fix the INSTALL file regarding
   the dependency two libnfnetlink and libnetfilter_conntrack and
   additionally remove some whitespaces.
   (Apply the whitespace patch first.)

[...]
> P.S: There is a TODO file inside the tarball that includes some pending
> stuff that needs to be done in case that you are thinking about
> contributing to the project.
 
I´ll give the manpage a shot.

Ciao
Max
-- 
	Follow the white penguin.

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="INSTALL.whitespace.patch"

--- conntrackd-0.9.2/INSTALL	2007-01-17 02:48:29.000000000 +0100
+++ conntrackd-0.9.2-whitespacefix/INSTALL	2007-01-17 15:58:18.000000000 +0100
@@ -27,7 +27,7 @@
      - nfnetlink
      - ctnetlink (ip_conntrack_netlink)
      - connection tracking event notification API
- 
+
  o libnfnetlink: the netfilter netlink library
    use the official release available in netfilter.org
 
@@ -47,9 +47,9 @@
     For node 2: conntrackd-x.x.x/examples/sync/node2/keepalived.conf
 
     These files can be used to set up a simple VRRP cluster composed of
-    two machines that hold the virtual IPs 192.168.0.100 on eth0 and 
-    192.168.1.100 on eth1. 
- 
+    two machines that hold the virtual IPs 192.168.0.100 on eth0 and
+    192.168.1.100 on eth1.
+
     If you are not familiar with keepalived, please read the official
     docs available at http://www.keepalived.org
 
@@ -60,16 +60,16 @@
 
     To setup 'conntrackd' in synchronization mode, you have to put the
     configuration file in the directory /etc/conntrackd.
- 
+
     On node 1:
 	# cp examples/sync/_type_/node1/conntrackd.conf /etc/conntrackd.conf
 
     On node 2:
         # cp examples/sync/_type_/node1/conntrackd.conf /etc/conntrackd.conf
 
-    Where _type_ is the synchronization type selected, currently there are 
-    two: the persistent mode and the NACK mode. The persistent mode consumes 
-    more resources than the NACK mode, however the NACK mode is still 
+    Where _type_ is the synchronization type selected, currently there are
+    two: the persistent mode and the NACK mode. The persistent mode consumes
+    more resources than the NACK mode, however the NACK mode is still
     experimental
 
     Do not forget to edit the files in order to adapt them to the
@@ -89,7 +89,7 @@
 
     - Dump the cache of connections that are currently being processed by
       this node (aka. internal cache):
-      
+
     # conntrackd -i
 
     - Dump the cache of connections that has been transfered from
@@ -104,7 +104,7 @@
  5) Setting up interaction with keepalived
 
     If keepalived detects the failure of the active node, then it designates
-    a candidate node that will replace the failing active. On such event, 
+    a candidate node that will replace the failing active. On such event,
     the external cache, eg. the cache that contains the connections processed
     by other nodes, must be commited. To commit the external cache, just type:
 
@@ -159,7 +159,7 @@
 
 2.2.2. Configuration
 
- Setting up conntrackd in statistics mode is rather easy. Just copy the 
+ Setting up conntrackd in statistics mode is rather easy. Just copy the
  configuration file
 
     # cp examples/stats/conntrackd.conf /etc/conntrackd.conf

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="INSTALL.docupdate.patch"

--- conntrackd-0.9.2/INSTALL	2007-01-17 15:58:18.000000000 +0100
+++ conntrackd-0.9.2-docupdate/INSTALL	2007-01-17 15:54:58.000000000 +0100
@@ -29,13 +29,23 @@
      - connection tracking event notification API
 
  o libnfnetlink: the netfilter netlink library
-   use the official release available in netfilter.org
+
+     Since conntrackd version 0.9.2 you can used the official release availble at
+     http://www.netfilter.org/projects/libnfnetlink/files/
+
+     Up to conntrackd version 0.9.1 use the unofficial release available at the
+     download section
 
  o libnetfilter_conntrack: the netfilter conntrack library
-   use the oficial release available in netfilter.org
+
+     Since  conntrackd version 0.9.2 you can used the official release availble at
+     http://www.netfilter.org/projects/libnetfilter_conntrack/files/
+
+     Up to conntrackd version 0.9.1 use the unnoficial release available at the
+     download section
 
  o Keepalived version 1.x (http://www.keepalived.org)
-   check if your distribution comes with a recent version
+     check if your distribution comes with a recent version
 
 2.1.2. Configuration
 
@@ -152,10 +162,20 @@
       - connection tracking event notification API
 
  o libnfnetlink: the netfilter netlink library
-   use the unofficial release available at the download section
+
+     Since conntrackd version 0.9.2 you can used the official release availble at
+     http://www.netfilter.org/projects/libnfnetlink/files/
+
+     Up to conntrackd version 0.9.1 use the unofficial release available at the
+     download section
 
  o libnetfilter_conntrack: the netfilter conntrack library
-   use the unnoficial release available at the download section
+
+     Since  conntrackd version 0.9.2 you can used the official release availble at
+     http://www.netfilter.org/projects/libnetfilter_conntrack/files/
+
+     Up to conntrackd version 0.9.1 use the unnoficial release available at the
+     download section
 
 2.2.2. Configuration
 

--82I3+IH0IqGh5yIs--
