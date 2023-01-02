Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBA4C4708E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 14:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjABOMW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 09:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjABOMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 09:12:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83B4A6586
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 06:12:17 -0800 (PST)
Date:   Mon, 2 Jan 2023 15:12:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] ipset patches for nf
Message-ID: <Y7LmPTOaBLorqtPK@salvia>
References: <20221230122438.1618153-1-kadlec@netfilter.org>
 <bfd683-b621-9d38-4139-74486f70e834@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bfd683-b621-9d38-4139-74486f70e834@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Fri, Dec 30, 2022 at 01:42:01PM +0100, Jozsef Kadlecsik wrote:
> On Fri, 30 Dec 2022, Jozsef Kadlecsik wrote:
> 
> > Please pull the next patches into your nf tree.
> > 
> > - The first patch fixes a hang when 0/0 subnets is added to a
> >   hash:net,port,net type of set. Except hash:net,port,net and
> >   hash:net,iface, the set types don't support 0/0 and the auxiliary
> >   functions rely on this fact. So 0/0 needs a special handling in
> >   hash:net,port,net which was missing (hash:net,iface was not affected
> >   by this bug).
> > - When adding/deleting large number of elements in one step in ipset,
> >   it can take a reasonable amount of time and can result in soft lockup
> >   errors. This patch is a complete rework of the previous version in order
> >   to use a smaller internal batch limit and at the same time removing
> >   the external hard limit to add arbitrary number of elements in one step.
> > 
> > Please note, while the second patch removes half of the first patch, the
> > remaining part of the first patch is still important.
> 
> In the versions I sent the first patch was collapsed with the part for 
> hash:net,port,net from the second patch. So now for proper functionality 
> it depends on the second one. If it is not OK, just let me know!

If you think this is the best course of action, then I am fine with this.

Thanks for explaining.
