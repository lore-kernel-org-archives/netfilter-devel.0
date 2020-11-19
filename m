Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21AAC6379F
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 19:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6136224655
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 19:00:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8nwrkTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgKSTAH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 14:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727292AbgKSTAG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 14:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605812406;
        bh=awsBQKIb9yz8PNPsnrGB++344Ac/GiSnUsOxKtArYHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j8nwrkTyXieELSrHH4IkmP8D+MeHZjmvamx1NZxXuXg0sbelq19uW7JnXMUhdoEX5
         B8iD13BFmaogQuc8pxetuvpTAKZ1A75CcN+pjZvIHOL9jfaMiT+UuB4bOgCp2lOt8r
         54U07H0Pvyprv8w8VbWZ6mP/T02gZ5NsUGCzqiwo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: Remove dependency of ipv6_frag_thdr_truncated on
 ipv6 module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160581240611.6156.2848486844975021359.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Nov 2020 19:00:06 +0000
References: <20201119095833.8409-1-geokohma@cisco.com>
In-Reply-To: <20201119095833.8409-1-geokohma@cisco.com>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        rdunlap@infradead.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 19 Nov 2020 10:58:33 +0100 you wrote:
> IPV6=m
> NF_DEFRAG_IPV6=y
> 
> ld: net/ipv6/netfilter/nf_conntrack_reasm.o: in function
> `nf_ct_frag6_gather':
> net/ipv6/netfilter/nf_conntrack_reasm.c:462: undefined reference to
> `ipv6_frag_thdr_truncated'
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: Remove dependency of ipv6_frag_thdr_truncated on ipv6 module
    https://git.kernel.org/netdev/net/c/2d8f6481c17d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


