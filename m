From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Fri, 08 Apr 2005 16:58:45 +0900 (JST)
Message-ID: <200504080758.j387wkif011777@toshiba.co.jp>
References: <423DA194.40100@trash.net>
	<200503300205.j2U25fCc021930@toshiba.co.jp>
	<42503569.5080406@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Apr__8_16:58:45_2005_682)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42503569.5080406@trash.net>
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

----Next_Part(Fri_Apr__8_16:58:45_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Patrick,

Sorry for late replying. I looked other parts.
This patch makes send_reset() look xfrm policy and deletes unnecessary
dst_hold().

	Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 03 Apr 2005 20:26:49 +0200

> Yasuyuki KOZAKAI wrote:
> > I wrote ip6t_REJECT so that the source address of ICMPv6 error was
> > destination address of original packet. Because of this behavior,
> > send_unreach could not use icmpv6_send().
> > But now I have found that the behavior of ipt_REJECT is different.
> > The source address of ICMP error is its node. I think the behavior of them
> > should be same. Moreover, ipt_REJECT has changed to use icmp_send() recently.
> 
> That makes sense. Do you have any other issues with submitting
> this patch?


-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Fri_Apr__8_16:58:45_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="reject.patch"

Index: linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c
===================================================================
--- linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	(revision 3827)
+++ linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	(working copy)
@@ -122,6 +122,11 @@
 		return;
 	}
 
+	if (xfrm_lookup(&dst, &fl, NULL, 0)) {
+		dst_release(dst);
+		return;
+	}
+
 	hh_len = (dst->dev->hard_header_len + 15)&~15;
 	nskb = alloc_skb(hh_len + 15 + dst->header_len + sizeof(struct ipv6hdr)
 			 + sizeof(struct tcphdr) + dst->trailer_len,
@@ -135,7 +140,6 @@
 	}
 
 	nskb->dst = dst;
-	dst_hold(dst);
 
 	skb_reserve(nskb, hh_len + dst->header_len);
 
@@ -182,8 +186,6 @@
 
 	NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		maybe_reroute);
-
-	dst_release(dst);
 }
 
 static inline void

----Next_Part(Fri_Apr__8_16:58:45_2005_682)----
