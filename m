Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91BEC10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25BC2075B
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfDKKeS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:34:18 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45310 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDKKeS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 06:34:18 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hEX27-0005t6-Pf; Thu, 11 Apr 2019 12:34:15 +0200
Date:   Thu, 11 Apr 2019 12:34:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH nft] parser_json: fix segfault in translating string to
 nft object
Message-ID: <20190411103415.GY4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20190411085940.l47vszzffm4e3e3c@nevthink>
 <20190411091558.dytqgrgcwelfbhad@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411091558.dytqgrgcwelfbhad@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Apr 11, 2019 at 11:15:58AM +0200, Florian Westphal wrote:
> Laura Garcia Liebana <nevola@gmail.com> wrote:
> > The obj_tbl array is allocated with the maximum element index even
> > if lower indexes are not populated, so it produces null pointer
> > items.
> > 
> > This patch ensures that the maximum number of possible indexes
> > but also the element is not comparing a null pointer.
> 
> Applied, thanks Laura.

Thanks for catching this, Laura!

> >  static int string_to_nft_object(const char *str)
> >  {
> > -	const char *obj_tbl[] = {
> > +	const char *obj_tbl[__NFT_OBJECT_MAX] = {
> >  		[NFT_OBJECT_COUNTER] = "counter",
> >  		[NFT_OBJECT_QUOTA] = "quota",
> >  		[NFT_OBJECT_CT_HELPER] = "ct helper",
> >  		[NFT_OBJECT_LIMIT] = "limit",
> >  		[NFT_OBJECT_SECMARK] = "secmark",
> >  	};
> 
> Phil, does this need updating?
> 
> It looks to me as if this should also init NFT_OBJECT_CT_TIMEOUT and so on.

Actually, it is not strict enough. The function is used when handling
'add map' command. In bison, only counter, quota, limit and secmark are
allowed as stateful object "destination". I suspect ct helper is a
leftover from reusing the function somewhere else. I'll send a patch to
remove it.

Cheers, Phil
