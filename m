From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: nf_conntrack: don't track locally generated
 special ICMP error
Date: Tue, 17 Jul 2007 17:25:10 +0200
Message-ID: <469CDF56.80600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020501030301010607030801"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Adrian Bunk <bunk@stusta.de>
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020501030301010607030801
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Attached are two patches (stable.diff, applies to stable-2.6.21 and
stable-2.6.22 and 2.6.16.diff for stable-2.6.16) fixing incorrect
conntrack association of ICMP errors generated in response to INVALID
packets, causing incorrect address translation in combination with NAT.

Please apply, thanks.

--------------020501030301010607030801
Content-Type: text/x-diff;
 name="stable.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="stable.diff"

[NETFILTER]: nf_conntrack: don't track locally generated special ICMP error

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

Upstream commit ID: 130e7a83d7ec8c5c673225e0fa8ea37b1ed507a5

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0fea4ce3bbdda1442282bdff5657d0f91294c637
tree 94d6fc8768d4071ad33b46edf9bf8e151cc341e9
parent f44bba1a92e01bbab6ca9817b86ddf9e1744a616
author Patrick McHardy <kaber@trash.net> Tue, 17 Jul 2007 17:18:38 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 17 Jul 2007 17:18:38 +0200

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

--------------020501030301010607030801
Content-Type: text/x-diff;
 name="2.6.16.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.16.diff"

[NETFILTER]: nf_conntrack: don't track locally generated special ICMP error

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

Upstream commit ID: 130e7a83d7ec8c5c673225e0fa8ea37b1ed507a5

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 935cfadcd1b69e828ecad5794319dd418a004793
tree 22962f7a436a7d2cf0934f78b178a9389fd70b6d
parent 6b99a1744ab187073bca84a9fd3ccbf091865ca6
author Patrick McHardy <kaber@trash.net> Tue, 17 Jul 2007 17:21:23 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 17 Jul 2007 17:21:23 +0200

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index db9e7c4..8ef5c33 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -193,25 +193,13 @@ icmp_error_message(struct sk_buff *skb,
 
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

--------------020501030301010607030801--
