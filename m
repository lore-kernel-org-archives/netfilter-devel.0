From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 2/3] Misc cleanups
Date: Mon, 4 Jun 2007 21:13:00 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706042111410.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
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


Removes inline.

device_cmp: the function's address is taken (call to nf_ct_iterate_cleanup)
alloc_null_binding: referenced externally

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 net/ipv4/netfilter/ipt_MASQUERADE.c |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -109,7 +109,7 @@ masquerade_target(struct sk_buff **pskb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static inline int
+static int
 device_cmp(struct nf_conn *i, void *ifindex)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_nat_rule.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/nf_nat_rule.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_nat_rule.c
@@ -172,7 +172,7 @@ static bool ipt_dnat_checkentry(const ch
 	return true;
 }
 
-inline unsigned int
+unsigned int
 alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 {
 	/* Force range to this IP; let proto decide mapping for
