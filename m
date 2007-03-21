From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: nat: avoid rerouting packets if only XFRM policy
	key changed
Date: Wed, 21 Mar 2007 06:21:54 +0100 (MET)
Message-ID: <20070321052129.6534.36322.sendpatchset@localhost.localdomain>
References: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nat: avoid rerouting packets if only XFRM policy key changed

Currently NAT not only reroutes packets in the OUTPUT chain when the
routing key changed, but also if only the non-routing part of the
IPsec policy key changed. This breaks ping -I since it doesn't use
SO_BINDTODEVICE but IP_PKTINFO cmsg to specify the output device, and
this information is lost.

Only do full rerouting if the routing key changed, and just do a new
policy lookup with the old route if only the ports changed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3fa9a3e05bdab319a2367d4bdcabbdb1df76d0f5
tree 77a61451c8f61fc790edfb3a20bd67b2fba4aaa0
parent 9b8ea8f4f4091c6e4424b46e8d56bb0366dfd3ee
author Patrick McHardy <kaber@trash.net> Wed, 21 Mar 2007 06:17:00 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 21 Mar 2007 06:17:00 +0100

 net/ipv4/netfilter/ip_nat_standalone.c |   15 +++++++++------
 net/ipv4/netfilter/nf_nat_standalone.c |   14 ++++++++------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index adf25f9..6bcfdf6 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -253,14 +253,17 @@ ip_nat_local_fn(unsigned int hooknum,
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 
 		if (ct->tuplehash[dir].tuple.dst.ip !=
-		    ct->tuplehash[!dir].tuple.src.ip
-#ifdef CONFIG_XFRM
-		    || ct->tuplehash[dir].tuple.dst.u.all !=
-		       ct->tuplehash[!dir].tuple.src.u.all
-#endif
-		    )
+		    ct->tuplehash[!dir].tuple.src.ip) {
 			if (ip_route_me_harder(pskb, RTN_UNSPEC))
 				ret = NF_DROP;
+		}
+#ifdef CONFIG_XFRM
+		else if (ct->tuplehash[dir].tuple.dst.u.all !=
+			 ct->tuplehash[!dir].tuple.src.u.all)
+			if (ip_xfrm_me_harder(pskb))
+				ret = NF_DROP;
+#endif
+
 	}
 	return ret;
 }
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index e4d3ef1..15aa3db 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -245,14 +245,16 @@ nf_nat_local_fn(unsigned int hooknum,
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 
 		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
-		    ct->tuplehash[!dir].tuple.src.u3.ip
-#ifdef CONFIG_XFRM
-		    || ct->tuplehash[dir].tuple.dst.u.all !=
-		       ct->tuplehash[!dir].tuple.src.u.all
-#endif
-		    )
+		    ct->tuplehash[!dir].tuple.src.u3.ip) {
 			if (ip_route_me_harder(pskb, RTN_UNSPEC))
 				ret = NF_DROP;
+		}
+#ifdef CONFIG_XFRM
+		else if (ct->tuplehash[dir].tuple.dst.u.all !=
+			 ct->tuplehash[!dir].tuple.src.u.all)
+			if (ip_xfrm_me_harder(pskb))
+				ret = NF_DROP;
+#endif
 	}
 	return ret;
 }
