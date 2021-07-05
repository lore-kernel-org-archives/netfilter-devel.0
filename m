Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BC4C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 19:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE1F6197E
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 19:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhGET0c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 15:26:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48702 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhGET0a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 15:26:30 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 950E160693;
        Mon,  5 Jul 2021 21:23:41 +0200 (CEST)
Date:   Mon, 5 Jul 2021 21:23:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     aabdallah <aabdallah@suse.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: improve RST handling when tuple
 is re-used
Message-ID: <20210705192349.GA16111@salvia>
References: <20210520105311.20745-1-fw@strlen.de>
 <7f02834fae6dde2d351650177375d004@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f02834fae6dde2d351650177375d004@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 05, 2021 at 11:27:51AM +0200, aabdallah wrote:
> Hi,
> 
> I see that this commit [1] is still under review, is there is any change
> that it will be reviewed and merged soon? Thanks.
> 
> [1] https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=244902

Ok, I'm assuming that you're fine with Florian's proposal to address
your issue then. I was actually waiting for your ACK.

I'll place this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210520105311.20745-1-fw@strlen.de/

into nf.git.

Thanks
