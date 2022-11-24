Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0672EC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 15:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKXPpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 10:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXPpB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 10:45:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43F793CF6
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 07:45:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oyEPL-0001Bt-DQ; Thu, 24 Nov 2022 16:44:59 +0100
Date:   Thu, 24 Nov 2022 16:44:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 3/3] extensions: remove trailing spaces
Message-ID: <20221124154459.GF2753@breakpoint.cc>
References: <20221124134939.8245-1-fw@strlen.de>
 <20221124134939.8245-4-fw@strlen.de>
 <Y399MCSuWa64CTAZ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y399MCSuWa64CTAZ@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Nov 24, 2022 at 02:49:39PM +0100, Florian Westphal wrote:
> > Previous patches cause minor test breakage, e.g:
> > exp: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460'
> > res: nft 'add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460 '
> > 
> > So fix up the ->xlate callbacks of the affected modules to not print a
> > tailing space character.
> 
> I am considering something like this:
> 
> | diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> | index 479dbae078156..367eefaba8e74 100644
> | --- a/libxtables/xtables.c
> | +++ b/libxtables/xtables.c
> | @@ -2496,6 +2496,11 @@ static void __xt_xlate_add(struct xt_xlate *xl, enum xt_xlate_type type,
> |         struct xt_xlate_buf *buf = &xl->buf[type];
> |         int len;
> |  
> | +       if (buf->off && !isspace(buf->data[buf->off - 1])) {
> | +               buf->data[buf->off] = ' ';
> | +               buf->off++;
> | +               buf->rem--;
> | +       }
> |         len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
> |         if (len < 0 || len >= buf->rem)
> |                 xtables_error(RESOURCE_PROBLEM, "OOM");
> 
> Maybe it needs an extra xt_xlate_add_nospc() but it should eliminate the
> majority of the "whitespace here or there or not at all" fiddling all over the
> code. WDYT?

I think its a good idea.
