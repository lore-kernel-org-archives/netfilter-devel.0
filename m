Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF8BC433DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F67864D73
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 21:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhB0Vfj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Feb 2021 16:35:39 -0500
Received: from correo.us.es ([193.147.175.20]:52070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230079AbhB0VfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Feb 2021 16:35:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A762015C10A
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:34:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 923A7DA78C
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2021 22:34:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8797EDA73D; Sat, 27 Feb 2021 22:34:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A131DA704;
        Sat, 27 Feb 2021 22:34:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Feb 2021 22:34:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0E6E942DC6E2;
        Sat, 27 Feb 2021 22:34:22 +0100 (CET)
Date:   Sat, 27 Feb 2021 22:34:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: gpf inside xt_find_revision()
Message-ID: <20210227213421.GA15981@salvia>
References: <75817029-1d99-0e41-1d5b-76fa4a45aafa@virtuozzo.com>
 <20210227161659.GB17911@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210227161659.GB17911@breakpoint.cc>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 27, 2021 at 05:16:59PM +0100, Florian Westphal wrote:
> Vasily Averin <vvs@virtuozzo.com> wrote:
> > nested target/match_revfn() calls work with xt[NFPROTO_UNSPEC] lists
> > without taking xt[NFPROTO_UNSPEC].mutex. This can race with module unload
> > and cause host to crash:
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
