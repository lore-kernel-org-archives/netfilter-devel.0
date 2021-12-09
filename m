Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FBEC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhLIAfb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 19:35:31 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41972 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhLIAfb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 19:35:31 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C9ADD605BA;
        Thu,  9 Dec 2021 01:29:34 +0100 (CET)
Date:   Thu, 9 Dec 2021 01:31:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/4] second batch of typeof fixes
Message-ID: <YbFOeQqyiSrzfejb@salvia>
References: <20211207151659.5507-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207151659.5507-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 07, 2021 at 04:16:55PM +0100, Florian Westphal wrote:
> This series makes typeof-sets work in corner cases such as
> 
> set s4 { typeof frag frag-off }
> set s8 { typeof ip version }
> 
> frag frag-off @s4 accept
> ip version @s8
> 
> Due to the shift/mask expressions needed to cope with these
> delinearization can't figure out the correct payload/exthdr templates
> and nft lists this as:
> 
> (frag unknown & 0xfff8 [invalid type]) >> 3 == @s4
> (ip l4proto & pfsync) >> 4 == @s8
> 
> With this series, the mask/shift expressions are removed and
> nft can print them in a readable way.

LGTM, thanks
