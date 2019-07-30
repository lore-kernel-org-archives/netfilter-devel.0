Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF629C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 13:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC6B2064A
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 13:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CM2YzWFS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfG3NdI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:33:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42985 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfG3NdI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 09:33:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so15902875wrr.9
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 06:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=I7R7Lu7Man6iro8iELUXTEg+6MoMuxeqhT4PmIF8ZP0=;
        b=CM2YzWFS3DfB4OqsQMtJAd6JpC2cONRbC/7LkVUJ4YSmiUnxP2Qb69h8513V3+64Rv
         j3BKPi0Vcv0uzKw5r/45aRAJ/0TzPE1Rgi0uOji5y8b1+NvBvuQyI+ASH1TOm0K0j4qY
         jvZkwZKhpOgBTlTLgy2NcHIVzEN0BXfdzgzz1/BgZmP5xF+1t+uUEBMZ+7cdmMzH6vqL
         cLJvoyEaeMuKgxsOzeASYAGnn7hBOYtIiodOrF2NFLF7GJNJgBUosi72w6NACAmx+kcP
         3wUXOqXlyeeb0vdi9gnRnFWtOiNF4dwkpJC8z+MJwPqsSn3S6GBYukIf6dHGMq0ok35z
         tvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=I7R7Lu7Man6iro8iELUXTEg+6MoMuxeqhT4PmIF8ZP0=;
        b=b/4o93SiltQ4qZBA3FlzaKzopVBFmH3QCPnO4YHqTH5JdmgDQGGaJjX3/L5JqHAdKw
         Oc75rsZHbH5CLcR5uq08St1pwr/InKgj0d13AwRB9XjAasepYFp6BoBCwFh2x3ghOD/N
         z65iORO9to9u9o1EezKdInIGKhlI48JpfqyG6uZBcAZwRqSjurR70g16KEwSFcw0dgVg
         8srXUU2xfReBnZGhQ4N86/yZL/FXUZu4st/p6k3U4hp3cicnOOQhRlJsm3ur6RyfuI4O
         Ih9apMOp2Jgs47Ngs4PPt5+oOSZAvTtzH139q8zhaC6E+7eGw8HVGXaE3mqmxQuwTXrr
         Wgkg==
X-Gm-Message-State: APjAAAVCizmOfMvhvRh20HxmV5MG+2aqnLFABR7U9N/P23nO8MHrcLcY
        Q2PN8IhB4adi5D2TY1ooJFxYUp0x
X-Google-Smtp-Source: APXvYqxDSQuN+QkJgpAQK7RteDvuqvpHddTL9CEFGiDC4bJV/99H6OVofMDRglJAecAnPDMM0RALaA==
X-Received: by 2002:a5d:50c2:: with SMTP id f2mr33587405wrt.106.1564493585929;
        Tue, 30 Jul 2019 06:33:05 -0700 (PDT)
Received: from nevthink ([185.79.20.147])
        by smtp.gmail.com with ESMTPSA id g8sm64120538wmf.17.2019.07.30.06.33.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jul 2019 06:33:05 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:33:02 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: fix flush chain cache flag
Message-ID: <20190730133302.qlrguidpfpogtios@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After the new cache system, nft raises a table error
flushing a chain in a transaction.

 # nft "flush chain ip nftlb filter-newfarm ; \
    add rule ip nftlb filter-newfarm update \
    @persist-newfarm {  ip saddr : ct mark } ; \
    flush chain ip nftlb nat-newfarm"
 Error: No such file or directory
 flush chain ip nftlb filter-newfarm ; add rule ip nftlb (...)
                                                   ^^^^^

This patch sets the cache flag properly to save this
case.

Fixes: 01e5c6f0ed031 ("src: add cache level flags")
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 0d38034e..6f5fc342 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -71,6 +71,9 @@ static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 	case CMD_OBJ_METER:
 		flags |= NFT_CACHE_SET;
 		break;
+	case CMD_OBJ_CHAIN:
+		flags |= NFT_CACHE_CHAIN;
+		break;
 	case CMD_OBJ_RULESET:
 		flags |= NFT_CACHE_FLUSHED;
 		break;
-- 
2.11.0

