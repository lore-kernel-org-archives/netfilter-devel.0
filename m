Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E387C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Feb 2021 09:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A70464ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Feb 2021 09:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhBTJai (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Feb 2021 04:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTJah (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Feb 2021 04:30:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D63C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Feb 2021 01:29:57 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t29so3464152pfg.11
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Feb 2021 01:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kream.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QrF77SJL0SciPjDS7THtTNTjxzmIs/aldoyMtF7aQ8A=;
        b=mbw4ImDxzdhE3NR7J945EXz/ju/PToqVsiL9TiNQHPRFMo4vAB/+imkaVVUrPPNhmV
         gcugwLZrl5na73eKJHQHjMLNbpf8QXO8bfhMOag+wTReyTZ98UyByRTGrtSTfUeZ9uME
         hGH5GgVAdCRhnxFhE31p6opNJuzDegKlbQFOn/4OBVzG79Zb0FbEfNoK8uRIdshGUtQg
         FewgYV74LqB4RLn7hgMEW+cffO+MOoXn9kSXWoQYaaP8XHxgdaupERgPrcojssOMsuKC
         /6pgdAiNTzkc6Fwq4GIJz3FJNMEXz+JqROthSfrBvZ/HhAvkqRnymkuhhXNDS/ALC0Sv
         J0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QrF77SJL0SciPjDS7THtTNTjxzmIs/aldoyMtF7aQ8A=;
        b=LezbKC52LMmhF7yz5PSfR2Gebgtb9+MvcILTtzpe/8TvjwbzbJJI77EzFGoxi9gC78
         ODN5qwcyFjwR0imI9HHdYFS8P3hwWqj8pQKGlCZ2kBty8cSkAwV6EICSu9kF5Rfn6Xqe
         Zw3trsaoCEhSB3HJhZQZK3BXX8Flx5pDDSOmd++8EYwKjTKtW2Bco7x+1YFK8l0j4ElA
         uDjldxV1Ecq91bJxG3d9+kxT3VjTuh0gX9CLFImJMucYBgGQ3jISRgrl391XgBoB7y62
         qFvzYp6UPGZylAOouW83eXgOd8BscPRfoArrh3K1YW2AZSneeQZYvMoxkfL9T6vr9oBv
         p5Zg==
X-Gm-Message-State: AOAM531qbFb6XF4iBC+BEG4UV632usgjStpXyIvz4TNht523tAggo5qx
        KuVEnTOdpRs/QtCAcloRCoBsZu+L8L8+8UhG
X-Google-Smtp-Source: ABdhPJx5T09U+cTraXCO7zRGIPBK7/SP6xKfqhSU1cYmEH5DIq3Y+ddaNpNMKhW5qS63cTRDpnwp9g==
X-Received: by 2002:a05:6a00:1507:b029:1e4:d81:5586 with SMTP id q7-20020a056a001507b02901e40d815586mr13436042pfu.53.1613813396735;
        Sat, 20 Feb 2021 01:29:56 -0800 (PST)
Received: from nNa-Laptop.usen.ad.jp (122x213x216x48.ap122.ftth.ucom.ne.jp. [122.213.216.48])
        by smtp.gmail.com with ESMTPSA id f23sm4773936pfa.5.2021.02.20.01.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 01:29:56 -0800 (PST)
From:   =?UTF-8?q?Klemen=20Ko=C5=A1ir?= <klemen.kosir@kream.io>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        =?UTF-8?q?Klemen=20Ko=C5=A1ir?= <klemen.kosir@kream.io>
Subject: [PATCH] netfilter: Remove a double space in a log message
Date:   Sat, 20 Feb 2021 18:29:26 +0900
Message-Id: <20210220092926.12025-1-klemen.kosir@kream.io>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Removed an extra space in a log message and an extra blank line in code.

Signed-off-by: Klemen Košir <klemen.kosir@kream.io>
---
 net/netfilter/nf_conntrack_helper.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 118f415928ae..b055187235f8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -219,7 +219,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 			return NULL;
 		pr_info("nf_conntrack: default automatic helper assignment "
 			"has been turned off for security reasons and CT-based "
-			" firewall rule not found. Use the iptables CT target "
+			"firewall rule not found. Use the iptables CT target "
 			"to attach helpers instead.\n");
 		net->ct.auto_assign_helper_warned = 1;
 		return NULL;
@@ -228,7 +228,6 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 }
 
-
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
-- 
2.29.2

