From: Patrick McHardy <kaber@trash.net>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
	interface?
Date: Fri, 13 Jul 2007 16:50:02 +0200
Message-ID: <4697911A.60909@trash.net>
References: <200707071728.l67HStWh022546@toshiba.co.jp>	<200707071748.l67HmfE2005051@toshiba.co.jp>	<46923976.605@trash.net>
	<200707131425.l6DEPBYv013659@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090006060408020905080203"
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707131425.l6DEPBYv013659@toshiba.co.jp>
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

This is a multi-part message in MIME format.
--------------090006060408020905080203
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Yasuyuki KOZAKAI wrote:
> [NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error


Thanks. I had to manually apply it because it clashed with the
pr_debug changes, please verify that I made no mistake. I'll
also push your original patch to -stable.

--------------090006060408020905080203
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b94585f7a2d237fa09af67063b0dc499e5461da6
tree ff17e171f22901060080b61f0e2383603a0407e9
parent 0c066bfa040c11160cbcfbad27e0a513801f6768
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 13 Jul 2007 16:48:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Jul 2007 16:48:17 +0200

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index b8b7999..f965733 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -165,25 +165,13 @@ icmp_error_message(struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(&innertuple);
 	if (!h) {
-		/* Locally generated ICMPs will match inverted if they
-		   haven't been SNAT'ed yet */
-		/* FIXME: NAT code has to handle half-done double NAT --RR */
-		if (hooknum == NF_IP_LOCAL_OUT)
-			h = nf_conntrack_find_get(&origtuple);
-
-		if (!h) {
-			pr_debug("icmp_error_message: no match\n");
-			return -NF_ACCEPT;
-		}
-
-		/* Reverse direction from that found */
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
-	} else {
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
+		pr_debug("icmp_error_message: no match\n");
+		return -NF_ACCEPT;
 	}
 
+	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+		*ctinfo += IP_CT_IS_REPLY;
+
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;

--------------090006060408020905080203--
