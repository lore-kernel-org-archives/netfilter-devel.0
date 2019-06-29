Return-Path: <SRS0=xEq4=U4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38684C5B57A
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jun 2019 18:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16053215EA
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jun 2019 18:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfF2SCR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jun 2019 14:02:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SCR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jun 2019 14:02:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4DB014B8D0DF;
        Sat, 29 Jun 2019 11:02:16 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:02:16 -0700 (PDT)
Message-Id: <20190629.110216.897222978158891297.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net v2] net: make skb_dst_force return true when dst is
 refcounted
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626184045.2922-1-fw@strlen.de>
References: <20190626184045.2922-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 11:02:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 26 Jun 2019 20:40:45 +0200

> netfilter did not expect that skb_dst_force() can cause skb to lose its
> dst entry.
> 
> I got a bug report with a skb->dst NULL dereference in netfilter
> output path.  The backtrace contains nf_reinject(), so the dst might have
> been cleared when skb got queued to userspace.
> 
> Other users were fixed via
> if (skb_dst(skb)) {
> 	skb_dst_force(skb);
> 	if (!skb_dst(skb))
> 		goto handle_err;
> }
> 
> But I think its preferable to make the 'dst might be cleared' part
> of the function explicit.
> 
> In netfilter case, skb with a null dst is expected when queueing in
> prerouting hook, so drop skb for the other hooks.
> 
> v2:
>  v1 of this patch returned true in case skb had no dst entry.
>  Eric said:
>    Say if we have two skb_dst_force() calls for some reason
>    on the same skb, only the first one will return false.
> 
>  This now returns false even when skb had no dst, as per Erics
>  suggestion, so callers might need to check skb_dst() first before
>  skb_dst_force().
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
 ...
>  Alternatively this could be routed via netfilter tree, let me
>  know your preference.

Applied and I'll queue this up for -stable, thanks Florian.
