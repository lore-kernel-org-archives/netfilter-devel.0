Return-Path: <SRS0=wVpJ=EP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4666DC4741F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 09:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB79206ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 09:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfg4eU3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgKIJTy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 04:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgKIJTy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 04:19:54 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEFFC0613CF;
        Mon,  9 Nov 2020 01:19:53 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 33so7851858wrl.7;
        Mon, 09 Nov 2020 01:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GUBLLHbst2zeH9c/A9PODgvPT5XA5rVjk1jholZ9SRQ=;
        b=kfg4eU3VVoKvTjZjQS8sEhcZqElqp8XNyGsIdRnYkMYgri+stxfPtjWUdzVkHaLivh
         D9cYFvEwbHvIgANjHGO/WOgF9ujbCKGKSxWQUflX22LZ/+Qftl1YaZNOE2Evr4oNHyiP
         yogLQ29pzKUtD8YvTlYjNKKastnRKNOPq3+zSet9fzCfB9MH3rp0OpdCZ/0IOVKsEJXJ
         PJKTafiYyLmrqqEAi3ND0NRwWxZFCJPI6urdk1xAT4qPrktxoFBBXVL/ksGvNZsbaP7S
         i3EmWoB5kv9CvMmM9qVlSJLI03PVn9QRAL+W4Fz67yQh+JH/CKDfTy4j463pzcXSOCjO
         xyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GUBLLHbst2zeH9c/A9PODgvPT5XA5rVjk1jholZ9SRQ=;
        b=HCbfB4QqwE+xAolvAklGve/XMmHEKM15tSf+YFx/lYy7544IvArWqkK0tU8N7Fp/vh
         VEGHw0ZvQ8BNSorr9uYfOj6Dz7s1uOO11Hp98AcrwAMu1UKavjIvDkrd0vlFWl7mT+Jz
         FWxw8MHmO5+AkmmxaQgcKAN0dltc8ieVN6wlIEzAHXIvFnVqJc/29SLL/+5catWQqO42
         n2XJMM/GEDUbD78xG8y09xchrnZFvvVfecp3DKMJawctjSzoKrdHXA02+Iyjf3bYO9Ac
         JHAco3HJZvpIPqTnREm9fn5WeeG0I/Ugb25z9tbztSAPe/0+YJ65VAhMfScx78GrnUBe
         QMrg==
X-Gm-Message-State: AOAM533NehUqmAYsx46DdAjeoKvkBKhRJZXHFWpfpx5HEryZkPWuQPzY
        wFFWs7NwTAFkpVuW5DQ9ZwU=
X-Google-Smtp-Source: ABdhPJwu3gruSVyzNdsY7JRGI+5F9eOc2RfKuCvT6dlP/5VnN22JiqZ5VBwPY1g+RHnRn+ytK29Iog==
X-Received: by 2002:adf:f24b:: with SMTP id b11mr2099778wrp.342.1604913592343;
        Mon, 09 Nov 2020 01:19:52 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2dd6:1d00:48a4:9af6:6f6a:ebcb])
        by smtp.gmail.com with ESMTPSA id f16sm12696366wrp.66.2020.11.09.01.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 01:19:51 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify file patterns for NETFILTER
Date:   Mon,  9 Nov 2020 10:19:42 +0100
Message-Id: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The two file patterns in the NETFILTER section:

  F:      include/linux/netfilter*
  F:      include/uapi/linux/netfilter*

intended to match the directories:

  ./include{/uapi}/linux/netfilter_{arp,bridge,ipv4,ipv6}

A quick check with ./scripts/get_maintainer.pl --letters -f will show that
they are not matched, though, because this pattern only matches files, but
not directories.

Rectify the patterns to match the intended directories.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on v5.10-rc3 and next-20201109

Pablo, Jozsef, Florian, please pick this minor non-urgent clean-up patch.

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cba8ddf87a08..572a064a9c95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12139,10 +12139,10 @@ W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
-F:	include/linux/netfilter*
+F:	include/linux/netfilter*/
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
-F:	include/uapi/linux/netfilter*
+F:	include/uapi/linux/netfilter*/
 F:	include/uapi/linux/netfilter/
 F:	net/*/netfilter.c
 F:	net/*/netfilter/
-- 
2.17.1

