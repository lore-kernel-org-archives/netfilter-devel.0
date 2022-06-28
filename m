Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE978CCA479
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 16:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiF1Qun (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241113AbiF1QsV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 12:48:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C88E32CDD4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 09:45:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sbrivio@redhat.com
Subject: [PATCH nf] netfilter: nft_set_pipapo: release elements in clone from abort path
Date:   Tue, 28 Jun 2022 18:45:27 +0200
Message-Id: <20220628164527.101413-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

New elements that reside in the clone are not released in case that the
transaction is aborted.

[16302.231754] ------------[ cut here ]------------
[16302.231756] WARNING: CPU: 0 PID: 100509 at net/netfilter/nf_tables_api.c:1864 nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[...]
[16302.231882] CPU: 0 PID: 100509 Comm: nft Tainted: G        W         5.19.0-rc3+ #155
[...]
[16302.231887] RIP: 0010:nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[16302.231899] Code: f3 fe ff ff 41 55 41 54 55 53 48 8b 6f 10 48 89 fb 48 c7 c7 82 96 d9 a0 8b 55 50 48 8b 75 58 e8 de f5 92 e0 83 7d 50 00 74 09 <0f> 0b 5b 5d 41 5c 41 5d c3 4c 8b 65 00 48 8b 7d 08 49 39 fc 74 05
[...]
[16302.231917] Call Trace:
[16302.231919]  <TASK>
[16302.231921]  __nf_tables_abort.cold+0x23/0x28 [nf_tables]
[16302.231934]  nf_tables_abort+0x30/0x50 [nf_tables]
[16302.231946]  nfnetlink_rcv_batch+0x41a/0x840 [nfnetlink]
[16302.231952]  ? __nla_validate_parse+0x48/0x190
[16302.231959]  nfnetlink_rcv+0x110/0x129 [nfnetlink]
[16302.231963]  netlink_unicast+0x211/0x340
[16302.231969]  netlink_sendmsg+0x21e/0x460

Add nft_set_pipapo_match_destroy() helper function to release the
elements in the lookup tables.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Stefano,

I triggered this splat with this test.nft file:

  table inet test {
        chain x {
        }

        chain y {
                udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : goto x }
        }
  }

then, exercise the abort path with -c:

  # nft -c -f test.nft

I don't see the splat anymore here.

This bug uncovered with the -o/--optimize infrastructure, which has a
test similar to the file described above.

priv->dirty seems to be a safe indication that this is in the abort path
when calling .destroy().

 net/netfilter/nft_set_pipapo.c | 43 ++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2c8051d8cca6..02f6cc061a2e 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2124,6 +2124,27 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return err;
 }
 
+static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+					 struct nft_pipapo_match *m)
+{
+	struct nft_pipapo_field *f;
+	int i, r;
+
+	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
+		;
+
+	for (r = 0; r < f->rules; r++) {
+		struct nft_pipapo_elem *e;
+
+		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
+			continue;
+
+		e = f->mt[r].e;
+
+		nft_set_elem_destroy(set, e, true);
+	}
+}
+
 /**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
  * @set:	nftables API set representation
@@ -2132,26 +2153,13 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
-	int i, r, cpu;
+	int cpu;
 
 	m = rcu_dereference_protected(priv->match, true);
 	if (m) {
 		rcu_barrier();
 
-		for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
-			;
-
-		for (r = 0; r < f->rules; r++) {
-			struct nft_pipapo_elem *e;
-
-			if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
-				continue;
-
-			e = f->mt[r].e;
-
-			nft_set_elem_destroy(set, e, true);
-		}
+		nft_set_pipapo_match_destroy(set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2165,6 +2173,11 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 	}
 
 	if (priv->clone) {
+		m = priv->clone;
+
+		if (priv->dirty)
+			nft_set_pipapo_match_destroy(set, m);
+
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
 #endif
-- 
2.30.2

