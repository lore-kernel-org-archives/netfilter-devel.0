From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH]: logging of reused expectations
Date: Tue, 10 Dec 2002 12:14:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0212101151140.9625-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@redhat.com>,
	jpiszcz <jpiszcz@lucidpixels.com>, Othmar Pasteka <pasteka@kabsi.at>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

As 2.4.20 came out with newnat included, there were several reports on
excessive logging of reused FTP expectations.

A tcpdump (thanks to jpiszcz) proved that such log entries can easily be
triggered when a client tries to download/list non-existent entries in
active mode and then wants to download other files as well:

- active mode requested by the client	 -> conntrack registers the
					    expected connection
- server acknowledges it
- client sends the filename to download
- server reports the file does not exists
- active mode requested again for another -> reused expectation logged
  data channel
...

The attached patch fixes the problem by separating the two possible cases:
when the conntrack helper is registered with the reuse flag enabled, then
the logging is converted to debugging (not enabled by default), otherwise
the logging is kept to notify the admin on the violation of the
given protocol.

Harald, if you agree with the patch please submit it.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

--- linux-2.4.20-orig/net/ipv4/netfilter/ip_conntrack_core.c	Fri Nov 29 00:53:15 2002
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c	Tue Dec 10 11:35:27 2002
@@ -966,22 +966,27 @@
 		   related_to->expecting >= related_to->helper->max_expected) {
 		struct list_head *cur_item;
 		/* old == NULL */
-	    	if (net_ratelimit())
-		    	printk(KERN_WARNING
-		    	       "ip_conntrack: max number of expected "
-			       "connections %i of %s reached for "
-			       "%u.%u.%u.%u->%u.%u.%u.%u%s\n",
-		    	       related_to->helper->max_expected,
-		    	       related_to->helper->name,
-		    	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
-		    	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip),
-		    	       related_to->helper->flags & IP_CT_HELPER_F_REUSE_EXPECT ?
-		    	       ", reusing" : "");
 		if (!(related_to->helper->flags &
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
 			WRITE_UNLOCK(&ip_conntrack_lock);
+		    	if (net_ratelimit())
+			    	printk(KERN_WARNING
+			    	       "ip_conntrack: max number of expected "
+				       "connections %i of %s reached for "
+			     	  	"%u.%u.%u.%u->%u.%u.%u.%u\n",
+		    	     		related_to->helper->max_expected,
+		    	       		related_to->helper->name,
+		    	       		NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+		    	       		NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
 			return -EPERM;
 		}
+	    	DEBUGP("ip_conntrack: max number of expected "
+			"connections %i of %s reached for "
+			"%u.%u.%u.%u->%u.%u.%u.%u, reusing\n",
+		    	related_to->helper->max_expected,
+		    	related_to->helper->name,
+		    	NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+		    	NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));

 		/* choose the the oldest expectation to evict */
 		list_for_each(cur_item, &related_to->sibling_list) {
