Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88C9C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 16:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbiERQAa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 12:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiERQA1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 12:00:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6385165406
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 09:00:26 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, fasnacht@protonmail.ch
Subject: [PATCH nf,v2] netfilter: nf_tables: disable bh to update per-cpu rnd_state
Date:   Wed, 18 May 2022 18:00:22 +0200
Message-Id: <20220518160022.224294-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

bh might occur while updating per-cpu rnd_state from user context,
ie. local_out path.

[233241.951068] BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
[233241.951220] caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
[233241.951225] CPU: 2 PID: 2725 Comm: nginx Tainted: G           OE 5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
[233241.951227] Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
[233241.951228] Call Trace:
[233241.951231]  <TASK>
[233241.951233]  dump_stack_lvl+0x48/0x5e
[233241.951236]  check_preemption_disabled+0xde/0xe0
[233241.951239]  nft_ng_random_eval+0x24/0x54 [nft_numgen]

Fixes: 6b2faee0ca91 ("netfilter: nft_meta: place prandom handling in a helper")
Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: disable/enable bh
    @Florian: your rand meta support is missing {disable,enable}_local_bh()

 net/netfilter/nft_meta.c   | 10 ++++++++--
 net/netfilter/nft_numgen.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac4859241e17..30aded940f91 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -273,9 +273,15 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 
 static noinline u32 nft_prandom_u32(void)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
+	struct rnd_state *state;
+	u32 ret;
 
-	return prandom_u32_state(state);
+	local_bh_disable();
+	state = this_cpu_ptr(&nft_prandom_state);
+	ret = prandom_u32_state(state);
+	local_bh_enable();
+
+	return ret;
 }
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 81b40c663d86..911589ad3837 100644
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
+	local_bh_disable();
+	state = this_cpu_ptr(&nft_numgen_prandom_state);
+	ret = prandom_u32_state(state);
+	local_bh_enable();
+
+	return reciprocal_scale(ret, priv->modulus) + priv->offset;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
-- 
2.30.2

