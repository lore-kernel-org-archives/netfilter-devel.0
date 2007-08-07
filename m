From: <gregkh@suse.de>
Subject: patch
	nf_conntrack-don-t-track-locally-generated-special-icmp-error.patch
	queued to -stable tree
Date: Tue, 07 Aug 2007 10:09:15 -0700
Message-ID: <20070807171417.5F62814458DB@imap.suse.de>
References: <469CDF56.80600@trash.net>
Cc: stable-commits@vger.kernel.org
To: yasuyuki.kozakai@toshiba.co.jp, bunk@stusta.de,
	davem@davemloft.net, gregkh@suse.de, kaber@trash.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469CDF56.80600@trash.net>
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


This is a note to let you know that we have just queued up the patch titled

     Subject: nf_conntrack: don't track locally generated special ICMP error

to the 2.6.22-stable tree.  Its filename is

     nf_conntrack-don-t-track-locally-generated-special-icmp-error.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Jul 17 08:25:30 2007
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Tue, 17 Jul 2007 17:25:10 +0200
Subject: nf_conntrack: don't track locally generated special ICMP error
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>, "David S. Miller" <davem@davemloft.net>, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>, Adrian Bunk <bunk@stusta.de>
Message-ID: <469CDF56.80600@trash.net>

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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



Patches currently in stable-queue which might be from yasuyuki.kozakai@toshiba.co.jp are

queue-2.6.22/nf_conntrack-don-t-track-locally-generated-special-icmp-error.patch
