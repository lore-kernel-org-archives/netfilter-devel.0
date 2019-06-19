Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06183C31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 07:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC48F2075E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 07:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aaUigfkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfFSHDT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 03:03:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43041 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfFSHDT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 03:03:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so2033291wru.10
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 00:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eq5K0xBfEPyGpRmxdOphLLXyrEdsH7neGMEfo0cLd8=;
        b=aaUigfkLo/6GItDE0N3efW9WH+B9akIcyE5TDb+5qz60odDxMqWAdPiE16iZpihc5g
         XGb3k81jlatshgyahIl/gxpYOpoBeqCQhnW2PtCyO//1N+2XTACsAs65y1i2kjhj92vK
         6teRYJJPv9FG31sXSaBb54kd7zknTj2wOd74AyAY3JgGG/ugxU0hLog8V64xI4rq1dEg
         j5IiWXIdZn9pj37WwipjGH1UnTmpdIgeiQQ2dAHOyWHbViAUArT7aECuDFzH9jfkH936
         dsmM6wBIuJItUXUNiN2+4RHJNkz/fqly/jxrCSa2oDWJBWLwMctgby3nSuN0AU1NcYGx
         nQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eq5K0xBfEPyGpRmxdOphLLXyrEdsH7neGMEfo0cLd8=;
        b=IOVdPai8JPTopokTXiX7c7c/9L+0hVLeEKwkVKcZbKYExPNKgBjMTcOe3QF30l0SN6
         kPTb4PoLW+qsuGCywYjyt4395iNoTe/4WEIqUbBypJRT5j2x8JmDyCYT13t9DgLPjQhf
         9OE169TuQWV5Vrc9SxGtW6S21K/lYr8Ykqa5rQ2JSE3cgjRnX5YobeuIuBQcYd3y0vtz
         wjnDcWfQncoZpNJWbYqGxghoAKcEPToZv3xrv1uFoGFCsALP9B0fGzdoEKyaEBbqInoA
         Z6HhZzayvPLDnUxgCFObVSbvSsCx5xRtgjCnC3TeFl/nGX8i9eJBsSyklnLvqdQP0eEk
         byOw==
X-Gm-Message-State: APjAAAW7OoNHqHCt3QM4Y01FQ//HnvTyPu1sZElNImKr5pnbtLJOnD6p
        5HaGlilRr7jaxKSJ/ttkdykfy6Mv
X-Google-Smtp-Source: APXvYqyGtXVrJSmwQjB3kopZfHc6OgUakfJuS3fmDqhLWreIn/LsPOpLitqKS7MRvIXToABClSl4SA==
X-Received: by 2002:a5d:4843:: with SMTP id n3mr33257846wrs.77.1560927797473;
        Wed, 19 Jun 2019 00:03:17 -0700 (PDT)
Received: from VGer.neptura.lan ([2a01:e35:8aed:1991::ab91:6451])
        by smtp.gmail.com with ESMTPSA id r2sm606422wma.26.2019.06.19.00.03.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 00:03:17 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nf-next v1] netfilter: nft_ct: fix null pointer in ct expectations support
Date:   Wed, 19 Jun 2019 09:03:14 +0200
Message-Id: <20190619070314.12839-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As discovered by Coverity, nf_ct_helper_ext_add may return null, which must then be checked.
---
 net/netfilter/nft_ct.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 06b52c894573..dd731d5d9fb5 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1232,6 +1232,10 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	help = nfct_help(ct);
 	if (!help)
 		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	if (!help) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
 
 	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
 		regs->verdict.code = NFT_BREAK;
@@ -1241,7 +1245,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		l3num = nf_ct_l3num(ct);
 
 	exp = nf_ct_expect_alloc(ct);
-	if (exp == NULL) {
+	if (!exp) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-- 
2.21.0

