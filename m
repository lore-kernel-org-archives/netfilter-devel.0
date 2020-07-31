Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EACC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC11D22B40
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgGaRvw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 13:51:52 -0400
Received: from correo.us.es ([193.147.175.20]:43902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbgGaRvw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 13:51:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFFFDDA70F
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:51:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E03BADA844
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:51:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5A86DA840; Fri, 31 Jul 2020 19:51:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2738DA722;
        Fri, 31 Jul 2020 19:51:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 19:51:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B492D4265A32;
        Fri, 31 Jul 2020 19:51:48 +0200 (CEST)
Date:   Fri, 31 Jul 2020 19:51:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: make sure xtables destructors
 have run
Message-ID: <20200731175148.GA17099@salvia>
References: <20200724113446.29113-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724113446.29113-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 24, 2020 at 01:34:46PM +0200, Florian Westphal wrote:
> Pablo Neira found that after recent update of xt_IDLETIMER the
> iptables-nft tests sometimes show an error.
> 
> He tracked this down to the delayed cleanup used by nf_tables core:
> del rule (transaction A)
> add rule (transaction B)
> 
> Its possible that by time transaction B (both in same netns) runs,
> the xt target destructor has not been invoked yet.
> 
> For native nft expressions this is no problem because all expressions
> that have such side effects make sure these are handled from the commit
> phase, rather than async cleanup.
> 
> For nft_compat however this isn't true.
> 
> Instead of forcing synchronous behaviour for nft_compat, keep track
> of the number of outstanding destructor calls.
> 
> When we attempt to create a new expression, flush the cleanup worker
> to make sure destructors have completed.

Applied, thanks.
