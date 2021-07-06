Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B64EC07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 12:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3007A621DD
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 12:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhGFMJC convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 08:09:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51382 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbhGFLzn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 07:55:43 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 81EBF6165C;
        Tue,  6 Jul 2021 13:52:52 +0200 (CEST)
Date:   Tue, 6 Jul 2021 13:53:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     aabdallah <aabdallah@suse.de>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: improve RST handling when tuple
 is re-used
Message-ID: <20210706115301.GA3835@salvia>
References: <20210520105311.20745-1-fw@strlen.de>
 <7f02834fae6dde2d351650177375d004@suse.de>
 <20210705192349.GA16111@salvia>
 <20210706100410.kxsjk23zpnwbynpw@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210706100410.kxsjk23zpnwbynpw@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 06, 2021 at 12:04:10PM +0200, Ali Abdallah wrote:
> On 05.07.2021 21:23, Pablo Neira Ayuso wrote:
> > Ok, I'm assuming that you're fine with Florian's proposal to address
> > your issue then. I was actually waiting for your ACK.
> > 
> > I'll place this patch:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210520105311.20745-1-fw@strlen.de/
> 
> Thanks a lot!
> 
> Please also take into account the following patch:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210527071906.s7z72s7wsene5lib@Fryzen495/
> 
> which was already acked by Florian.

Patches applied to nf.git, thanks.
