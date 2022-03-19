Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413A7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Mar 2022 23:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiCSX2x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Mar 2022 19:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiCSX2x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Mar 2022 19:28:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B302260C5E
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Mar 2022 16:27:31 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CA53A62FFA;
        Sun, 20 Mar 2022 00:24:54 +0100 (CET)
Date:   Sun, 20 Mar 2022 00:27:28 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: conntrack: Add and use
 nf_ct_set_auto_assign_helper_warned()
Message-ID: <YjZm4OzzZjKeSYhA@salvia>
References: <20220302210255.10177-1-phil@nwl.cc>
 <YjZZYCNd0juT1gAc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YjZZYCNd0juT1gAc@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 19, 2022 at 11:29:55PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Mar 02, 2022 at 10:02:55PM +0100, Phil Sutter wrote:
> > The function sets the pernet boolean to avoid the spurious warning from
> > nf_ct_lookup_helper() when assigning conntrack helpers via nftables.
> 
> I'm going to apply this alternative patch, based on yours. No need to
> expose a symbol to access the pernet area. I have also added the Fixes: tag.

Scratch this, I'll take your patch as is. The symbol is indeed needed.

Thanks.
