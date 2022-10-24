Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC65C38A2D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Oct 2022 09:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJXJ6z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Oct 2022 05:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJXJ6x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2022 05:58:53 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9834A817
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Oct 2022 02:58:49 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E4765C00A0;
        Mon, 24 Oct 2022 05:58:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 24 Oct 2022 05:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666605528; x=
        1666691928; bh=vApnq6w6UPlB3Pu+RDyC1scjt2nATLM8aCBAf303hK8=; b=a
        0PVj3PjPWPvbvZsSwv7e4Fzh5UOSmYm2Pd7+qRfhzA5kGOpcWQEyLk3rDmUkC7Ut
        p279fzk5GG8xAU/sD81k2Vd5fBaEuqcg2Q1nv3riWdlsu/DzwMlJ4+F+5y38Y6Vi
        ljbwhwzlMhqc6vqZK9EkJfeZRIJgYtLe+mNXUrclt36YETOhU0pb6/b1A14CmSIf
        d6vXNjK2H7MBln6H9ECv2Pypn1p3ceuqWg4vCyK4aBQlOVib3i/ughr7wOIt2Vmd
        EHAqVtpv6b1MyQPbZvWk1YBKShln4rR64HmOm04ikeiJ7c/CC6fVrSmFebgJWIzg
        0rv7na0McqF+ZePQBbPbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666605528; x=1666691928; bh=vApnq6w6UPlB3
        Pu+RDyC1scjt2nATLM8aCBAf303hK8=; b=JeYbb5CN0qnPedkzbn5obBtT8A0q/
        XI1q8/x5HgQmzc+SZS3mj+gS36BsJSdI7YaVlsY0Vu3l7m1tiSBWcRbnVuKPeNck
        3eQ0QULkP/KULl4t5GiZqFkMasejA/jN0oz7mnaxUXsR6iyyA85U43O7NEnthKLL
        a1ocCsQfNSFbEu7nNCdgvt0SOI31oE6NIuNeXom0t9ed/uewrgGJDdxp9ubmiRei
        N73QSLUlaPII3veQnOCYg/Vtvk12uJm73ziCYwjEldynY3qg8w8R3rV8ollr6316
        Nw4V/07jwBAkoOd1WVks2k4oK4Jkh0BGLajoiHMKHZi640NBQrR4SWdzA==
X-ME-Sender: <xms:2GFWY8xgLLOlBv_foxw0EMLAL56ngGmFkEM5w7PXL_6U84IzXuIT5Q>
    <xme:2GFWYwSb4pTVV-1fT4ilzjbh15uW7ujP0qiXQ7l98H63wMMjbf2vFWdDAC55WkJFZ
    JcKi_mN3Alq9-esiQ>
X-ME-Received: <xmr:2GFWY-Xw0VKeRJLF6IVn4zZ4Xs8wUpYdm1mqfvG_q415W6VzbLSmrd73F6_OLHng8SdFbsfzeu5f5LQamfkFSv0P1iJLntR92f1uidC2E-qGE91Z7ujAZfUCPQ_EWX4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtgedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhohhhnucfvhhhomhhs
    ohhnuceoghhithesjhhohhhnthhhohhmshhonhdrfhgrshhtmhgrihhlrdgtohhmrdgruh
    eqnecuggftrfgrthhtvghrnhepjefgffffieejtdeujeffkeegveeiuddvueekffejieeu
    teekffejkeevleeijeffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhithesjhhohhhnthhhohhmshhonhdrfhgrshhtmhgrihhlrdgtohhm
    rdgruh
X-ME-Proxy: <xmx:2GFWY6i70M-hEKWzcm-xAzejNV0BOiXP9IIk33OMmGgFAb3n6u5jgA>
    <xmx:2GFWY-CanO_t5kY9Dc6cFcYdiXYVokySm88QxRH3O6rCvs1QaUEVsg>
    <xmx:2GFWY7LNOUBlVoq9w5qTbhLD8qqFRb7uUJIwbvuxGcY1j94-G0PGqw>
    <xmx:2GFWY5plFEbMYm4kqFp-gCmM4BNzSZ2zQfiU79krQhE9EPH_cswyNQ>
Feedback-ID: ic081425d:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Oct 2022 05:58:47 -0400 (EDT)
From:   John Thomson <git@johnthomson.fastmail.com.au>
To:     git@johnthomson.fastmail.com.au
Cc:     netfilter-devel@vger.kernel.org
Subject: [xtables-addons PATCH v1] build: support for linux 6.1
Date:   Mon, 24 Oct 2022 19:58:02 +1000
Message-Id: <20221024095802.2494673-1-git@johnthomson.fastmail.com.au>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221023032239.808311-1-git@johnthomson.fastmail.com.au>
References: <20221023032239.808311-1-git@johnthomson.fastmail.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

6.1 commit de492c83cae0 ("prandom: remove unused functions") removed
prandom_u32, which was replaced and deprecated for get_random_u32 in
5.19 d4150779e60f ("random32: use real rng for non-deterministic
 randomness"). get_random_u32 was introduced in 4.11 c440408cf690
("random: convert get_random_int/long into get_random_u32/u64")

Use the cocci script from 81895a65ec63 ("treewide: use prandom_u32_max()
when possible, part 1"), along with a best guess for _max changes, introduced:
3.14 f337db64af05 ("random32: add prandom_u32_max and convert open coded users")

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
---
v1: no #if kver: compat_xtables.h warns kernels below 4.16 not supported
---
 extensions/xt_CHAOS.c  | 4 ++--
 extensions/xt_TARPIT.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/xt_CHAOS.c b/extensions/xt_CHAOS.c
index 69d2082..2b0d09f 100644
--- a/extensions/xt_CHAOS.c
+++ b/extensions/xt_CHAOS.c
@@ -67,7 +67,7 @@ xt_chaos_total(struct sk_buff *skb, const struct xt_action_param *par)
 		ret = xm_tcp->match(skb, &local_par);
 		hotdrop = local_par.hotdrop;
 	}
-	if (!ret || hotdrop || (unsigned int)prandom_u32() > delude_percentage)
+	if (!ret || hotdrop || (unsigned int)get_random_u32() > delude_percentage)
 		return;
 
 	destiny = (info->variant == XTCHAOS_TARPIT) ? xt_tarpit : xt_delude;
@@ -94,7 +94,7 @@ chaos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_chaos_tginfo *info = par->targinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 
-	if ((unsigned int)prandom_u32() <= reject_percentage) {
+	if ((unsigned int)get_random_u32() <= reject_percentage) {
 		struct xt_action_param local_par;
 		local_par.state    = par->state;
 		local_par.target   = xt_reject;
diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 9a7ae5c..22e6125 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -107,8 +107,8 @@ static bool xttarpit_honeypot(struct tcphdr *tcph, const struct tcphdr *oth,
 		tcph->syn     = true;
 		tcph->ack     = true;
 		tcph->window  = oth->window &
-			((prandom_u32() & 0x1f) - 0xf);
-		tcph->seq     = htonl(prandom_u32() & ~oth->seq);
+			(prandom_u32_max(0x20) - 0xf);
+		tcph->seq     = htonl(prandom_u32_max(~oth->seq + 1));
 		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn);
 	}
 
@@ -117,7 +117,7 @@ static bool xttarpit_honeypot(struct tcphdr *tcph, const struct tcphdr *oth,
 		tcph->syn     = false;
 		tcph->ack     = true;
 		tcph->window  = oth->window &
-			((prandom_u32() & 0x1f) - 0xf);
+			(prandom_u32_max(0x20) - 0xf);
 		tcph->ack_seq = payload > 100 ?
 			htonl(ntohl(oth->seq) + payload) :
 			oth->seq;
-- 
2.37.2

