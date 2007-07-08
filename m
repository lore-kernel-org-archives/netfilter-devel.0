From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Sun, 08 Jul 2007 15:31:41 +0900 (JST)
Message-ID: <200707080631.l686VgrU024722@toshiba.co.jp>
References: <Pine.LNX.4.64.0707071727580.1808@x2>
	<200707071728.l67HStWh022546@toshiba.co.jp>
	<200707071748.l67HmfF1026109@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707071748.l67HmfF1026109@toshiba.co.jp>
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


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

> From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
>
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Sat, 7 Jul 2007 17:34:49 +0200 (CEST)
> > > 
> > > The local ICMP tracking is basically useless nowadays since we always
> > > manually attach the conntrack reference from the original packet
> > > (exactly because of the half-done double NAT FIXME quoted above).
> > > But this is an interesting case, the connection tracking code itself
> > > thought the RST was invalid, but ICMP tracking will still associate
> > > the ICMP containing the RST with the original connection. I'm wondering
> > > whether it should really do that. In case it shouldn't, just removing
> > > all locally generated ICMP special-casing should also fix the bug,
> > > right?
> > 
> > At first I thought so. But I didn't come up with any bad situation caused
> > by returning ICMP error to such invalid packets.
> 
> Can kernel correctly return ICMP error without conntrack in this case ?
> If so, I agree. (maybe yes, I'll check it after waking up).

I've tested following patch in some situations. Unless I used state or
conntrack match in OUTPUT (e.g. --state INVALID -j DROP), there is
no change of behavior. But can we accept this change ? ICMP error itself
is not invalid.


[NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error

The conntrack assigned to locally generated ICMP error is usually the one
assigned to the original packet which has caused the error. But if
the original packet is handled as invalid by nf_conntrack, no conntrack
is assigned to the original packet. Then nf_ct_attach() cannot assign
any conntrack to the ICMP error packet. In that case the current
nf_conntrack_icmp assigns appropriate conntrack to it. But the current
code mistakes the direction of the packet. As a result, NAT code mistakes
the address to be mangled.

To fix the bug, this changes nf_conntrack_icmp not to assign conntrack
to such ICMP error. Actually no address is necessary to be mangled
in this case.

Spotted by Jordan Russell.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index f4fc657..474b4ce 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -189,25 +189,13 @@ icmp_error_message(struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(&innertuple, NULL);
 	if (!h) {
-		/* Locally generated ICMPs will match inverted if they
-		   haven't been SNAT'ed yet */
-		/* FIXME: NAT code has to handle half-done double NAT --RR */
-		if (hooknum == NF_IP_LOCAL_OUT)
-			h = nf_conntrack_find_get(&origtuple, NULL);
-
-		if (!h) {
-			DEBUGP("icmp_error_message: no match\n");
-			return -NF_ACCEPT;
-		}
-
-		/* Reverse direction from that found */
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
-	} else {
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
+		DEBUGP("icmp_error_message: no match\n");
+		return -NF_ACCEPT;
 	}
 
+	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+		*ctinfo += IP_CT_IS_REPLY;
+
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
-- 
1.5.2.2
