From: Willy TARREAU <willy@w.ods.org>
Subject: [RFC][PATCH-2.4] fix NF_REPEAT (take 2)
Date: Sat, 25 Oct 2003 14:35:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031025123510.GA2717@pcw.home.local>
References: <20031022102556.GA10540@alpha.home.local> <Pine.LNX.4.33.0310232349181.20545-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   marcelo.tosatti@cyclades.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0310232349181.20545-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

here come two patches to fix the NF_REPEAT bug ; the first one based upon
your suggestion (your patch was for 2.6), but against ip_conntrack_core.c
in 2.4, which is the same in standard kernel and tcp_window_tracking, and
the second one is only targetted at a window_tracking enabled kernel.

I have verified that they fix the reported problem. Could you please check
them so that Marcelo can merge it before 2.4.23-final ?

Regards,
Willy

====== first one, for Marcelo

diff -urN linux-2.4.23-pre8/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.23-pre8-nf_repeat/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.23-pre8/net/ipv4/netfilter/ip_conntrack_core.c	Fri Oct 10 08:47:16 2003
+++ linux-2.4.23-pre8-nf_repeat/net/ipv4/netfilter/ip_conntrack_core.c	Fri Oct 24 09:09:22 2003
@@ -859,11 +859,13 @@
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
-	if (ret == -1) {
-		/* Invalid */
+	if (ret < 0) {
+		/* Invalid: inverse of the return code tells
+		 * to netfilter core what to do :
+		 * -1 == -NF_ACCEPT,  -NF_REPEAT, ... */
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		return NF_ACCEPT;
+		return -ret;
 	}
 
 	if (ret != NF_DROP && ct->helper) {



====== second one, for window tracking use only

diff -urN linux-2.4.23-pre8-wintrack-20031023/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.4.23-pre8-wintrack-nf_repeat/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.4.23-pre8-wintrack-20031023/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Fri Oct 24 09:13:33 2003
+++ linux-2.4.23-pre8-wintrack-nf_repeat/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Fri Oct 24 09:15:30 2003
@@ -736,7 +736,7 @@
 	    	WRITE_UNLOCK(&tcp_lock);
 	    	if (del_timer(&conntrack->timeout))
 	    		conntrack->timeout.function((unsigned long)conntrack);
-	    	return NF_REPEAT;
+	    	return -NF_REPEAT;
 	} else if (!(new_state == TCP_CONNTRACK_MAX
 		   || tcp_in_window(&conntrack->proto.tcp,
 		   		    dir, iph, len, tcph)))
