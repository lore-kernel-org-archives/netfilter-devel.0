Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E79CC46460
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 08:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DEC12674F
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 08:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFAI1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 04:27:35 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfFAI1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 04:27:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWzMS-0001Ow-5U; Sat, 01 Jun 2019 10:27:32 +0200
Date:   Sat, 1 Jun 2019 10:27:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190601002230.bo6dhdf3lhlkknqq@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > »       iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
> > »       if (!iph || skb->protocol != htons(ETH_P_IP))
> > »       »       return -EBADMSG;
> 
> I mean, you make this check upfront from the _eval() path, ie.
> 
> static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
>                                  ...
> {
>         ...
> 
>         if (skb->protocol != htons(ETH_P_IP))
>                 goto err;

Wouldn't it be preferable to just use nft_pf() != NFPROTO_IPV4?
