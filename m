Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8702AC433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5452964DA8
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB0Vew (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Feb 2021 16:34:52 -0500
Received: from correo.us.es ([193.147.175.20]:52040 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230079AbhB0Vet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Feb 2021 16:34:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1877F15C101
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:34:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 033C4DA704
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:34:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EC552DA72F; Sat, 27 Feb 2021 22:34:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD556DA704;
        Sat, 27 Feb 2021 22:34:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Feb 2021 22:34:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C053442DC6E2;
        Sat, 27 Feb 2021 22:34:05 +0100 (CET)
Date:   Sat, 27 Feb 2021 22:34:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uapi: nfnetlink_cthelper.h: fix userspace compilation
 error
Message-ID: <20210227213405.GA15963@salvia>
References: <20210222080000.GA5900@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210222080000.GA5900@altlinux.org>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 22, 2021 at 08:00:00AM +0000, Dmitry V. Levin wrote:
> Apparently, <linux/netfilter/nfnetlink_cthelper.h> and
> <linux/netfilter/nfnetlink_acct.h> could not be included into the same
> compilation unit because of a cut-and-paste typo in the former header.

Applied, thanks.
