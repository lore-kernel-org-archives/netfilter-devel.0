Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BB7C352A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 14:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiKXOUB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 09:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiKXOTr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 09:19:47 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D81211DA2B
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 06:18:25 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oyD3Y-0007fa-7y; Thu, 24 Nov 2022 15:18:24 +0100
Date:   Thu, 24 Nov 2022 15:18:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 3/3] extensions: remove trailing spaces
Message-ID: <Y399MCSuWa64CTAZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221124134939.8245-1-fw@strlen.de>
 <20221124134939.8245-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124134939.8245-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 02:49:39PM +0100, Florian Westphal wrote:
> Previous patches cause minor test breakage, e.g:
> exp: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460'
> res: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460 '
> 
> So fix up the ->xlate callbacks of the affected modules to not print a
> tailing space character.

I am considering something like this:

| diff --git a/libxtables/xtables.c b/libxtables/xtables.c
| index 479dbae078156..367eefaba8e74 100644
| --- a/libxtables/xtables.c
| +++ b/libxtables/xtables.c
| @@ -2496,6 +2496,11 @@ static void __xt_xlate_add(struct xt_xlate *xl, enum xt_xlate_type type,
|         struct xt_xlate_buf *buf = &xl->buf[type];
|         int len;
|  
| +       if (buf->off && !isspace(buf->data[buf->off - 1])) {
| +               buf->data[buf->off] = ' ';
| +               buf->off++;
| +               buf->rem--;
| +       }
|         len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
|         if (len < 0 || len >= buf->rem)
|                 xtables_error(RESOURCE_PROBLEM, "OOM");

Maybe it needs an extra xt_xlate_add_nospc() but it should eliminate the
majority of the "whitespace here or there or not at all" fiddling all over the
code. WDYT?

Cheers, Phil
