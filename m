Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C93C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 17:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78CE20665
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 17:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbfHNRS3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 13:18:29 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35636 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbfHNRS1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 13:18:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxwuk-0004eT-4V; Wed, 14 Aug 2019 19:18:22 +0200
Date:   Wed, 14 Aug 2019 19:18:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: fallout from net-next netfilter changes
Message-ID: <20190814171822.7yuem4ji3od4zu3d@breakpoint.cc>
References: <20190814.125330.1934256694306164517.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814.125330.1934256694306164517.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> This started happening after Jakub's pull of your net-next changes
> yesterday:
> 
> ./include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
>  #warning "Please update iptables, this file will be removed soon!"
>   ^~~~~~~
> In file included from <command-line>:
> ./include/uapi/linux/netfilter_ipv4/ipt_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
>  #warning "Please update iptables, this file will be removed soon!"
>   ^~~~~~~
> 
> It's probaly from the standard kernel build UAPI header checks.

A patch that removes those #warning from the kernel is sitting in
the netfilter patchwork queue already.
