Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6B4C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 04:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4529120872
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 04:22:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpAeOujx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbfCSEWu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 00:22:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46534 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCSEWu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 00:22:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id s23so12775841pfe.13
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Mar 2019 21:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aBy41+K7sxW0uucIGqkA9Fy7xOa54qhciATSI96atR4=;
        b=TpAeOujxHR/aH8Hry4IvPfaRslBsDxQ/oF/r1xsWIa9oZtmj2DsKCnre7D39vgjc0r
         QX1S63mm4mmckhG6aXIuEF6D/oB7bxC1dBBpEOCYafG/1qjvvUp7OopiS/q5Uu2yiIT8
         v66CBnBulMPAAvXbqX+fNNBUM+qlj59t9J0B3UVdZFFOoz5suG3edLo1nc71wZ2ygWdT
         APS9+gbKUrxmnOHS2dSDeMEl0QPmfqfQlxEN5uVUGIlNNe57lG6UQ8ozO0b7FTU56Jiu
         WqcNdmWLDRn3Hx0QOZlQsrJcjMFe4CyN6TNc8v/mRqcAFLkYep7W/jWCdkWUdHmhEhgw
         /3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aBy41+K7sxW0uucIGqkA9Fy7xOa54qhciATSI96atR4=;
        b=ZLT79i34lfRY1Ppp+ZbAuMmlizgCUDE1ieQb9V4cX0Kvke9Fy1YlMiiEMc8tOylJUH
         Ca0ZwSEOO/9xAbtnwVZuZkqFPFf1DQ6fLB4VP4BuGpcYy2cpjqWRfR7idRaS7VP6pmjy
         xy6RF+xYEyqRNcRD/ASYAGZfACK5hB+wD81V3qK+VgpKvOweqVRDwn4OUrm3IDo0Iaza
         OhuDPr0Tw15wCl6+ux0VLiY1PEmbJPu05/OLO2xYJQImvFTtBgJ5moKz+OKlBLHoPddc
         vgmQ6fHAE1ijHJ+0x3d5d/T1u7bRATR5sbthVCl5oH5e/qojHKk60NwcJXtqh6oUxO9/
         A9tA==
X-Gm-Message-State: APjAAAWl0mTE0+rtbaRuEsCoDnYWxN30nCdJiabDzVurATdwlejEYRSm
        4lM+h1AR59p/WIiTYJxigs0=
X-Google-Smtp-Source: APXvYqxHuGhDnu7ANsEE2Cxnmg0+UXNb/x5SUKxQq2z5CSCoKi31TqvwUK4YlFXBQ0dc9EwTABsjXQ==
X-Received: by 2002:a17:902:968a:: with SMTP id n10mr23689824plp.283.1552969369523;
        Mon, 18 Mar 2019 21:22:49 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id j9sm19975272pfc.67.2019.03.18.21.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 21:22:48 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf] netfilter: nf_tables: add missing ->release_ops() in error path of newrule()
Date:   Tue, 19 Mar 2019 13:22:41 +0900
Message-Id: <20190319042241.22680-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

->release_ops() callback releases resources and this is used in error path.
If nf_tables_newrule() fails after ->select_ops(), it should release
resources. but it can not call ->destroy() because that should be called
after ->init().
At this point, ->release_ops() should be used for releasing resources.

Test commands:
   modprobe -rv xt_tcpudp
   iptables-nft -I INPUT -m tcp   <-- error command
   lsmod

Result:
   Module                  Size  Used by
   xt_tcpudp              20480  2      <-- it should be 0

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 513f93118604..ef7772e976cc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2806,8 +2806,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
-		if (info[i].ops != NULL)
+		if (info[i].ops) {
 			module_put(info[i].ops->type->owner);
+			if (info[i].ops->type->release_ops)
+				info[i].ops->type->release_ops(info[i].ops);
+		}
 	}
 	kvfree(info);
 	return err;
-- 
2.17.1

