Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EAAC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA7C603E7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhHBLGI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbhHBLGI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:06:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3E0C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 04:05:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mAVlb-0005eM-9r; Mon, 02 Aug 2021 13:05:55 +0200
Date:   Mon, 2 Aug 2021 13:05:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] ebtables: Dump atomic waste
Message-ID: <20210802110555.GW3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210730103715.20501-1-phil@nwl.cc>
 <20210802090404.GA1252@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802090404.GA1252@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 02, 2021 at 11:04:04AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Jul 30, 2021 at 12:37:15PM +0200, Phil Sutter wrote:
> > With ebtables-nft.8 now educating people about the missing
> > functionality, get rid of atomic remains in source code. This eliminates
> > mostly comments except for --atomic-commit which was treated as alias of
> > --init-table. People not using the latter are probably trying to
> > atomic-commit from an atomic-file which in turn is not supported, so no
> > point keeping it.
> 
> That's fine.
> 
> If there's any need in the future for emulating this in the future, it
> should be possible to map atomic-save to ebtables-save and
> atomic-commit to ebtables-restore.

I had considered that, but the binary format of atomic-file drove me
off: If we can't support existing atomic-files easily, we better deny
unless someone has a strong argument to do it. And then I'd try to
support it fully, so it's not a half-ass solution with a catch. :)

> Anyway, this one of the exotic options in ebtables that makes it
> different from ip,ip6,arptables. Given there are better tools now that
> are aligned with the more orthodox approach, this should be OK.

Let's hope most users went with the familiar save/restore approach
instead of opening a whole new can for ebtables alone.

Thanks, Phil
