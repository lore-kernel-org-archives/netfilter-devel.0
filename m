Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2820EC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Oct 2022 03:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJWDXC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJWDW7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2022 23:22:59 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318922285
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2022 20:22:58 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 199CA320047A;
        Sat, 22 Oct 2022 23:22:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 22 Oct 2022 23:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666495374; x=1666581774; bh=wYVG4Dx/QV
        UwLfjtvj0JPAxTjlMCvWQmOT5pWInycSk=; b=WTHA33ZUXj1/1ctrRtP2nYookC
        oYAhfnGI+L4kplHfHJNWEtStJCq8sDy1QeQPGC3HeyxDsC+KKiyTXWUAIKkb0iI0
        QouK6LSkz5iiTVkV4oAhukb6tAHVxHSGfGPr7GlF97xWbIo1Y36tDMJMepZViSps
        CiReye/b6Q/YPFi65nS0Yp3j2SbshlH2uotIvVNmb1ojepI7xwqOACo/ju0uSQPu
        MAzcUlrz2+8N7ypaQ3g/P8nPqYnHJm+O1yCYVbBX38qDPrErJu24DsVTtsr1Ts0n
        58kYBDkEm/Z3TPAICJLRjD+DMklJbEHkStgecN799VtIhUMRqycudt2OqC0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1666495374; x=1666581774; bh=wYVG4Dx/QVUwLfjtvj0JPAxTjlMCvWQmOT5
        pWInycSk=; b=Z/SzmTGd0nXCRH1RQA0YucKSDqBeQQARWeI5Y7kIba9Cl8jAbA8
        qJp4VytRxvo2CiIiLdBZ6CY0Bu7rFS3+OjxvQfuys5H8qwtXz3XfDMEgJn114Brf
        ISl4ibWYkJwKYM6Q25Vl2jDtgRxmD2d4VsIuu7IIFElpTgTPsNFB+EbvsSzfcZt5
        +6OTZoDf+WBzOqGZKCSYgl2KORZGuIJfHqRcZE30il6hhzbW7AgUGErYSYJpI1zp
        4lr6N52kbwcBmirfocmAWsX0XYhW7iM/QrpAKf7vPcS+NxDSOn/ztWBHI10MMEhF
        J3kKXQHwVRaqI6F2eCipruV8kxAWoi56pfg==
X-ME-Sender: <xms:jrNUY_UGDeb8kprj_gHs7wCTZ2zs7Ubf8Wj-qVkscSTMr-MOBKJUpA>
    <xme:jrNUY3kwns-htSO_QjkXy-_wi40bZdxfhpERy4BZQc50hY1_LAQ4QtILfD6HSX3Pk
    8-VDl5pJtfp7Z2Y_w>
X-ME-Received: <xmr:jrNUY7ax0xo9hEc3E_UwpJ1TZa9W1ZiBOSvlu6SDpXW_mAYne1DCk31rTuT2-4AqibpuiiYyy6AQKCv_Jz9FcPYrEg9r040GEOtYd7XCW4cTCO5s9oq-kSo3nvvhkyE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtuddgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflohhhnhcuvfhhohhmshhonhcuoehgihhtsehjohhhnhhthhho
    mhhsohhnrdhfrghsthhmrghilhdrtghomhdrrghuqeenucggtffrrghtthgvrhhnpeetje
    evgffggeekffduledthfevgfeugeelhfeuveeiueekgfegffetudevhfdutdenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgihhtsehjohhhnh
    hthhhomhhsohhnrdhfrghsthhmrghilhdrtghomhdrrghu
X-ME-Proxy: <xmx:jrNUY6Wad4pDhz2sA6WyCaSKZ3RY5lP3jUuZw1mM0pxSXyYjJTlDRA>
    <xmx:jrNUY5naPEzyPxJtdffWkbo2kVEP-KLSCqXFIaiZkB-sboQXl8vRBg>
    <xmx:jrNUY3clQdaOr3nCMmK9MO_rjzAFOQIpXOYioGrALbjbwkbSiCm5-Q>
    <xmx:jrNUY4sPRdJpHJslLKCBtr5-bTypS6nkTHcmSxKttMVXJgDzFnjhCg>
Feedback-ID: ic081425d:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 22 Oct 2022 23:22:53 -0400 (EDT)
From:   John Thomson <git@johnthomson.fastmail.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     John Thomson <git@johnthomson.fastmail.com.au>
Subject: [PATCH RFC xtables-addons] build: support for linux 6.1
Date:   Sun, 23 Oct 2022 13:22:39 +1000
Message-Id: <20221023032239.808311-1-git@johnthomson.fastmail.com.au>
X-Mailer: git-send-email 2.37.2
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
RFC due to:
only compile tested aarch64 6.1rc1
not sure about the change for htonl(prandom_u32_max(~oth->seq + 1));
---
 extensions/xt_CHAOS.c  | 8 ++++++++
 extensions/xt_TARPIT.c | 6 +++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/extensions/xt_CHAOS.c b/extensions/xt_CHAOS.c
index 69d2082..5db8431 100644
--- a/extensions/xt_CHAOS.c
+++ b/extensions/xt_CHAOS.c
@@ -67,7 +67,11 @@ xt_chaos_total(struct sk_buff *skb, const struct xt_action_param *par)
 		ret = xm_tcp->match(skb, &local_par);
 		hotdrop = local_par.hotdrop;
 	}
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,11,0)
+	if (!ret || hotdrop || (unsigned int)get_random_u32() > delude_percentage)
+#else
 	if (!ret || hotdrop || (unsigned int)prandom_u32() > delude_percentage)
+#endif
 		return;
 
 	destiny = (info->variant == XTCHAOS_TARPIT) ? xt_tarpit : xt_delude;
@@ -94,7 +98,11 @@ chaos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_chaos_tginfo *info = par->targinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,11,0)
+	if ((unsigned int)get_random_u32() <= reject_percentage) {
+#else
 	if ((unsigned int)prandom_u32() <= reject_percentage) {
+#endif
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

