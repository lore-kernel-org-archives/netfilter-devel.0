Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5058BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiFWS4a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiFWSqv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:46:51 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC832EFD4E
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c65so52698edf.4
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6UIbEr9Bg7r7svR8oJYq5NwtqsRAmGoJUpfmJb5Ku/g=;
        b=Ak6tmSoexZlETBG/dUEapShxrCP32xQUQBHrMU8PE7MZ2n1PUEFfvwjAVZIZEsT8tf
         u8ITT7Kvur+DO3wU7vkhyxuJq2a/2T00Mb7hjSCv7PblQXpbaQNSSLHZXoLOQbx/ngDB
         K9obQ7ioCrz3WvAgmIsWdTG8/bz/2OPCcSUbxU3guIcjrbbfHStOjf2AvMTQ6WOV9GGd
         KnGw7XaSgcpxWxIOJp7LLKbVpgJR43qCI1hDWigO+GLixGaeugB5xBmfaYt4bWzR5/k3
         5RdW0B3JRz3kTt1M0RY94arGjvXfUIjbPkaUyhAfoOMztdOTbnmVcpGppZUZN92bZ765
         7ZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6UIbEr9Bg7r7svR8oJYq5NwtqsRAmGoJUpfmJb5Ku/g=;
        b=U8A+bTCzam29oNZ5oGerOW5Fq6mBf9VGYZHtKWaL4gZWmgXOkiMemV7PUWP7WC0XyH
         kR/bVySkSzi5sVgNOXJ/R4t1rNziU85iKgjbN2Sns77XWGi2cgzWT3qtEDT9bwze4L3P
         rblY6l34dZcJHRHokVh63+IE7FMAUmF1WwS7yxAdAJnTfhEJMtIn0qokOgDVtC+rGmPz
         jd/2uxBjkGPN75EHnEOu5TVYHpIGeW3rPiMGsdY7TdZLakmKxwN6vVSqo+hy77SUxui3
         p4tLM4+5n7p7EA1FGxEBPjQRvLT6ZLcejMr0lqLrFNayPmNKoTXCFi3rOvBm3eH0BYMs
         oe8A==
X-Gm-Message-State: AJIora+hst++TjJa14OOTb6X9Kq1VN3Yqc8ciY1L/ct9LRwEu3H2AWRP
        ulMb3WMKuQz/Nc2nWvn8L+T84s38xQAxcw==
X-Google-Smtp-Source: AGRyM1uKnypWsR0dDB9hnCncFxjialXAeaYjp040y0tj93pHdidMgRjxDgv0UKd5tEfH27gCDhRtGA==
X-Received: by 2002:a05:6402:510e:b0:435:9052:3b16 with SMTP id m14-20020a056402510e00b0043590523b16mr12398894edd.20.1656006623551;
        Thu, 23 Jun 2022 10:50:23 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:22 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 2/6] conntrack: set reply l4 proto for unknown protocol
Date:   Thu, 23 Jun 2022 19:49:56 +0200
Message-Id: <20220623175000.49259-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Withouth reply l4 protocol being set consistently the mnl_cb_run
(in fact the kernel) would return EINVAL.

Make sure the reply l4 protocol is set properly for unknown
protocols.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 extensions/libct_proto_unknown.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extensions/libct_proto_unknown.c b/extensions/libct_proto_unknown.c
index 2a47704..992b1ed 100644
--- a/extensions/libct_proto_unknown.c
+++ b/extensions/libct_proto_unknown.c
@@ -21,10 +21,21 @@ static void help(void)
 	fprintf(stdout, "  no options (unsupported)\n");
 }
 
+static void final_check(unsigned int flags,
+		        unsigned int cmd,
+		        struct nf_conntrack *ct)
+{
+	if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO) &&
+	    nfct_attr_is_set(ct, ATTR_L4PROTO) &&
+	    !nfct_attr_is_set(ct, ATTR_REPL_L4PROTO))
+		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, nfct_get_attr_u8(ct, ATTR_L4PROTO));
+}
+
 struct ctproto_handler ct_proto_unknown = {
 	.name 		= "unknown",
 	.help		= help,
 	.opts		= opts,
+	.final_check = final_check,
 	.version	= VERSION,
 };
 
-- 
2.25.1

