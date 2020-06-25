Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE23EC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 02:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB2992078D
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 02:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLDmYs0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbgFYCgf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 22:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389174AbgFYCge (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 22:36:34 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEBBC061573;
        Wed, 24 Jun 2020 19:36:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e12so3505172qtr.9;
        Wed, 24 Jun 2020 19:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=BjUw+e7RBzl+fFZCpG/J9ul+joA7WTbi+IRNQGYR8AU=;
        b=dLDmYs0ga2LgRDLyp1GqnWRmoAZLmg8eFNtfLE1nX24zUF8pxtrCXup7wFnTXWsjZ6
         RTFcdPEQ0DMQne911dKzBZa0ouhs3A8W13jPdNXLeb6/kw0U75qLWCf3w0RaqOa2v39J
         k401fmYWVCZ0BuQGJ4SBz5ZGI7yJBx0BXZHTtt4ufPTQl+yd327SAmmPqrGqnAqnJQ84
         yVES9O2Q9m4pqrHcFLThXLFGu8ZXl8Kbd0YeQG+kN7sVCL4QYuPRhwPm+huH745k6u/u
         fgkx6AajweZTBOBZgYpSs05vDgKXUNXKnMRU45EJdtJKsWWeLbvwfQ8iVVoGT+oXUVIX
         g3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=BjUw+e7RBzl+fFZCpG/J9ul+joA7WTbi+IRNQGYR8AU=;
        b=nzFPYdNCYocJGYBb/tT9L+FFpfLoQlXpFruGe7k36x20Yov+L80cjBjQNIwNq8j7aA
         MFJEYW0pOuVTfwjJuXnIxZtUf7YBRT5VHtRxrWC6VOTehnY2KMrjWdF7FD/cqtkOE60X
         6zT01vTdjMZ45rabjdrN4RRYf1e3ewO4p6x9CN1hrqcKdL2lTUZ8yMZOgX5dZaQpiZgz
         Hqai5SuFPI5EM301W/mSVPGytxyH0mNp9i8YgCTkp8EebCbJWsCgPQHrwL2yUbOJMSjo
         Yit09WOVACdRzic4sHgTqo3XzPAiPqK0Vq+fw5iW99nMZoInP+CDv009Wg8fR0av/PPS
         UbJw==
X-Gm-Message-State: AOAM533zCiDFgsMROi2NVDU+9G4TJjTxTD2/PG+dIKnjJ/49LD8fwICI
        yXD9zHtkrMokP+RuReG6c2s=
X-Google-Smtp-Source: ABdhPJxeoZX+Kj1v6xu9PwF4FldQ6rniErBmar2FhtkdnH26+dnmWaVMcdkVdhNx4H+c3RitwLbcCw==
X-Received: by 2002:aed:27c8:: with SMTP id m8mr29666532qtg.302.1593052593670;
        Wed, 24 Jun 2020 19:36:33 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b4f5:b2c7:27bb:8a39])
        by smtp.googlemail.com with ESMTPSA id f15sm3970180qka.120.2020.06.24.19.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:36:32 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] Remove redundant null check in ah_mt6
Date:   Wed, 24 Jun 2020 22:36:25 -0400
Message-Id: <20200625023626.32557-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ah cannot be NULL since its already checked above after
assignment and is being dereferenced before in pr().
Remove the redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/netfilter/ip6t_ah.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 4e15a14435e4..70da2f2ce064 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -74,8 +74,7 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 ahinfo->hdrres, ah->reserved,
 		 !(ahinfo->hdrres && ah->reserved));
 
-	return (ah != NULL) &&
-		spi_match(ahinfo->spis[0], ahinfo->spis[1],
+	return spi_match(ahinfo->spis[0], ahinfo->spis[1],
 			  ntohl(ah->spi),
 			  !!(ahinfo->invflags & IP6T_AH_INV_SPI)) &&
 		(!ahinfo->hdrlen ||
-- 
2.17.1

