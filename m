From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] ip_queue and bridge-nf
Date: Thu, 17 Jul 2003 17:51:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307171751.12670.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wXsF/OjA0ViNUeL"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_wXsF/OjA0ViNUeL
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Harald,

The attached patch solves the bridge-nf problem discussed in another mail on 
this list. Please send it to Dave at your convenience, it's vs 2.6.0-test1.

Here's the problem summary:
When copying skbuffs, iptables targets don't care about the Data Link header, 
since they assume that will be filled in later. When the packet is being 
bridged, however, the MAC header needs to be copied since it won't and can't 
be filled in later.
There are probably other iptables modules that will need a similar patch.

cheers,
Bart

--Boundary-00=_wXsF/OjA0ViNUeL
Content-Type: text/x-diff;
  charset="us-ascii";
  name="ip_queue.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ip_queue.diff"

--- linux-2.6.0-test1/net/ipv4/netfilter/ip_queue.c.old	2003-07-16 19:35:07.000000000 +0200
+++ linux-2.6.0-test1/net/ipv4/netfilter/ip_queue.c	2003-07-16 19:39:05.000000000 +0200
@@ -353,6 +353,11 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
 			}
 			if (e->skb->sk)
 				skb_set_owner_w(newskb, e->skb->sk);
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+			/* bridged packets already have their Ethernet header */
+			if (e->skb->nf_bridge)
+				memcpy(newskb->data - 16, e->skb->data - 16, 16);
+#endif
 			kfree_skb(e->skb);
 			e->skb = newskb;
 		}

--Boundary-00=_wXsF/OjA0ViNUeL--
