Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B0BC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 05:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9319F64FB4
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 05:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBEFIl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 00:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhBEFIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 00:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8889164E24;
        Fri,  5 Feb 2021 05:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612501679;
        bh=ulBEqcu3uB/xXFXJGBCw5AtPU0BmN4KWSiBM/1b2+F4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e++b4k9sV6hSevPgZIJ/JhKzd5knmr9mIJmFhKbl//RPLsK7MBJGluO9Z54NTWIJg
         3PkPBROBlhX8eFVj1fAxlhMqjV6V9wyNuGDhcqtT9hF4qkV+AWPH1s3re6AK7QDJwq
         mp4Cej7dWdn1Xf8pHyti76LS5XdRyBmmneQJZ2BC6E9OkWhyxzqvyrtRS+l3+5O2XS
         MGhpShgamjgGhSOtf5Yr3/4L0b6l3qTG0t+izkzSnbQWd4grjQATGEIkDHrYldNlBL
         J6VRcocMTF5T+3qy3X3tbmHCHJieyZqrS+2/CmUfZy0acxECVUAer7DNk4Leg1BROU
         Oco+/q6wBJ8Fw==
Date:   Thu, 4 Feb 2021 21:07:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>,
        Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next v2 0/4] Fix W=1 compilation warnings in net/*
 folder
Message-ID: <20210204210757.5f3f4f5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203135112.4083711-1-leon@kernel.org>
References: <20210203135112.4083711-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed,  3 Feb 2021 15:51:08 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v2:
>  * Patch 3: Added missing include file.
> v1: https://lore.kernel.org/lkml/20210203101612.4004322-1-leon@kernel.org
>  * Removed Fixes lines.
>  * Changed target from net to be net-next.
>  * Patch 1: Moved function declaration to be outside config instead
>    games with if/endif.
>  * Patch 3: Moved declarations to new header file.
> v0: https://lore.kernel.org/lkml/20210202135544.3262383-1-leon@kernel.org

Applied, thanks!
