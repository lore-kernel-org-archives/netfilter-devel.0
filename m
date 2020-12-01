Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC21BC83013
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 08:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815B2217A0
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 08:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgLAIrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:47:41 -0500
Received: from correo.us.es ([193.147.175.20]:51316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgLAIrk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 03:47:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF44E1F0D08
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 09:46:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95CE711C369
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 09:46:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94C8D11C367; Tue,  1 Dec 2020 09:46:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D92C11C368;
        Tue,  1 Dec 2020 09:46:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Dec 2020 09:46:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4145B4265A5A;
        Tue,  1 Dec 2020 09:46:55 +0100 (CET)
Date:   Tue, 1 Dec 2020 09:46:55 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiakaixu1987@gmail.com
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] netfilter: Remove unnecessary conversion to bool
Message-ID: <20201201084655.GA26468@salvia>
References: <1604650813-1132-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1604650813-1132-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 06, 2020 at 04:20:13PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Here we could use the '!=' expression to fix the following coccicheck
> warning:
> 
> ./net/netfilter/xt_nfacct.c:30:41-46: WARNING: conversion to bool not needed here

Applied.
