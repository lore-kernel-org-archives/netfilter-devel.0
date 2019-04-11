Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E816C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 09:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77953217D4
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 09:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfDKJQB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:16:01 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35040 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbfDKJQA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 05:16:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hEVoM-0008Jz-TA; Thu, 11 Apr 2019 11:15:58 +0200
Date:   Thu, 11 Apr 2019 11:15:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nft] parser_json: fix segfault in translating string to
 nft object
Message-ID: <20190411091558.dytqgrgcwelfbhad@breakpoint.cc>
References: <20190411085940.l47vszzffm4e3e3c@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411085940.l47vszzffm4e3e3c@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Laura Garcia Liebana <nevola@gmail.com> wrote:
> The obj_tbl array is allocated with the maximum element index even
> if lower indexes are not populated, so it produces null pointer
> items.
> 
> This patch ensures that the maximum number of possible indexes
> but also the element is not comparing a null pointer.

Applied, thanks Laura.

>  static int string_to_nft_object(const char *str)
>  {
> -	const char *obj_tbl[] = {
> +	const char *obj_tbl[__NFT_OBJECT_MAX] = {
>  		[NFT_OBJECT_COUNTER] = "counter",
>  		[NFT_OBJECT_QUOTA] = "quota",
>  		[NFT_OBJECT_CT_HELPER] = "ct helper",
>  		[NFT_OBJECT_LIMIT] = "limit",
>  		[NFT_OBJECT_SECMARK] = "secmark",
>  	};

Phil, does this need updating?

It looks to me as if this should also init NFT_OBJECT_CT_TIMEOUT and so on.
