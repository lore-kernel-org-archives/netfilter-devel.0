Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3547C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E7FC206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Xv4gqdDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgIYM6N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgIYMto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:44 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65662C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gx22so3471551ejb.5
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ajUra2Bcick3BoFwzcMScJaNF9h4s1nfoGoG3nDAgAg=;
        b=Xv4gqdDxIYMupiO1PIhj626LmrOKJmhum2IutfPJEDNpWhvhtKIGShYh6QqsOyu+CY
         zcwwKptrXzEHfM9zV87yWrUWrClV4OF/0kQ5cvOyn5ViMgp+fxduwa9KmirXKPBWvLpc
         n1LQzBbSTsxno7y9EKaPbsllOFNDrU4Gdsb5wvSboVJ4/qNK6p6ZuR9jIljj7wXjZF2Z
         siYLc/H7ts/g3A8yPYW2yPWpKbs6Gn0GKLCjc3cMEUgOzizM5hLUa0ETxyshG+UCkSQ/
         pHiJ/I1BU+jxrRq5B1uLRicUpDcXSE+G+BsudC1zf1rEZuK0Tr1mMZWQedz9Idzb/pfb
         mHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ajUra2Bcick3BoFwzcMScJaNF9h4s1nfoGoG3nDAgAg=;
        b=s8edCWYn37CwfuvoBwwoAawFCEyTr0qUAJt4MWFFzNHNTz73m9yr+NOPYQGwENsvE/
         xDAfo/JkV9bcuUHyI00Rpe6tlaJzhNyprX9mP1VPlKJj3vlFCCKnDSowExUfV3/IgOjc
         LFm44pPUBzeyL+7GY3No74/Q9flHbFA8qLM+ku1zCo6R6JYdyCUEZuuDx7c/eRKxMRvs
         pBoz35xPPvBQW5MkLoO6+E7zRTbzF6GveRuZAX/ZqtMk8cvbangjXCnbth2z3L9oBVrx
         hMtZ3F9htJT6Eg7TYdito1gNPZu5fb1v/CSmev3/MMiPyrHXlZr96YkUwUwqwdvg2Fs1
         ZLmw==
X-Gm-Message-State: AOAM531iXl6PDHoe05e4IJMSbHcsjgE1HcQh1q5RHbhRChCHmkaidig5
        fLgKqFB2ZqcI9GO0qVSsjjqoMmXOCaL2qQ==
X-Google-Smtp-Source: ABdhPJzy6C2owtoe+wuZrllhmDFHBYcinLShkjVS/MF9JYA9DalWOS3y0uTq/0qQbgBwFVuWfvrpCw==
X-Received: by 2002:a17:906:b053:: with SMTP id bj19mr2462813ejb.146.1601038182889;
        Fri, 25 Sep 2020 05:49:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:42 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 2/8] conntrack: fix icmp entry creation
Date:   Fri, 25 Sep 2020 14:49:13 +0200
Message-Id: <20200925124919.9389-3-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Creating icmp ct entry with command like

conntrack -I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 \
   -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226

results in nfct_query( NFCT_Q_CREATE ) request would fail
because reply L4 proto is not set while having reply data specified

Set reply L4 proto when reply data is given for the icmp ct entry

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 extensions/libct_proto_icmp.c   | 18 ++++++++++++++++++
 extensions/libct_proto_icmpv6.c | 18 ++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index 2ce1c65..16c2e2e 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -78,18 +78,36 @@ static int parse(char c,
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_TYPE;
 			break;
 		case '2':
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_CODE, tmp);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_CODE;
 			break;
 		case '3':
 			id = htons(atoi(optarg));
 			nfct_set_attr_u16(ct, ATTR_ICMP_ID, id);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_ID;
 			break;
 	}
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index 18dd3e5..7f5e637 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -81,18 +81,36 @@ static int parse(char c,
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_TYPE;
 			break;
 		case '2':
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_CODE, tmp);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_CODE;
 			break;
 		case '3':
 			id = htons(atoi(optarg));
 			nfct_set_attr_u16(ct, ATTR_ICMP_ID, id);
 			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			/*
+			 * need to set the reply proto, otherwise the
+			 * NFCT_Q_CREATE call would fail
+			 */
+			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_ID;
 			break;
 	}
-- 
2.25.1

