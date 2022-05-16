Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AB2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 08:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiEPI56 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 04:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242475AbiEPI5N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 04:57:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDD2A63C9
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 01:55:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: [PATCH nf] netfilter: nft_numgen: disable preempt to access per-cpu data
Date:   Mon, 16 May 2022 10:55:52 +0200
Message-Id: <20220516085552.212616-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[233241.951068] BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
[233241.951220] caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
[233241.951225] CPU: 2 PID: 2725 Comm: nginx Tainted: G           OE 5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
[233241.951227] Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
[233241.951228] Call Trace:
[233241.951231]  <TASK>
[233241.951233]  dump_stack_lvl+0x48/0x5e
[233241.951236]  check_preemption_disabled+0xde/0xe0
[233241.951239]  nft_ng_random_eval+0x24/0x54 [nft_numgen]

Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
See https://bugzilla.netfilter.org/show_bug.cgi?id=1603

 net/netfilter/nft_numgen.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 81b40c663d86..78f860555c76 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -137,10 +137,15 @@ struct nft_ng_random {
 
 static u32 nft_ng_random_gen(struct nft_ng_random *priv)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
+	struct rnd_state *state;
+	u32 ret;
 
-	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
-	       priv->offset;
+	preempt_disable();
+	state = this_cpu_ptr(&nft_numgen_prandom_state);
+	ret = reciprocal_scale(prandom_u32_state(state), priv->modulus) + priv->offset;
+	preempt_enable();
+
+	return ret;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
-- 
2.30.2

