Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E25C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 17:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjKGRLJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 12:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjKGRLI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 12:11:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256949B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 09:11:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BCC433C8;
        Tue,  7 Nov 2023 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699377065;
        bh=8Lk7coUZChVrUjWOCb0vKBTKyCO8PapJdoRvSdg/KgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EXxdeJq7J1awfpj9plI4EFeTZ2kKiaSAC7DbIBqJr3pGpAM6Jv2PJ1sC1QvN1Dhiy
         HX3T0QksrIRTxhQrtfB8whfkevHObygzrfQt4zjVZCvLgfY89A+Rck5rIXs5d+sYXn
         DCHwQg6bO/ZRVr9l5tnEgwFbwb7K7JEoQbFGrJ8lRyqfwCD8YuRKn5YR2os20xfPb9
         4jjnU/XCPCBwn+fWZMKqkFPL4DqNMKPiqNSnAxMaAqguZhlEFarNB8BPNt+eq3MWj/
         VtEdyfbj8oVSVvULNKUwMkBg5IxxQVy0m/FjGWmgiuuAfVUV8C8e4HLbeVLiwndUR7
         luV+Aa//lb+BQ==
Date:   Tue, 7 Nov 2023 12:11:03 -0500
From:   Simon Horman <horms@kernel.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net v2] netfilter: xt_recent: fix (increase) ipv6 literal
 buffer length
Message-ID: <20231107171103.GA316877@kernel.org>
References: <20231105195600.522779-1-maze@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231105195600.522779-1-maze@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 05, 2023 at 11:56:00AM -0800, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <zenczykowski@gmail.com>
> 
> in6_pton() supports 'low-32-bit dot-decimal representation'
> (this is useful with DNS64/NAT64 networks for example):
> 
>   # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:1.2.3.4 > /proc/self/net/xt_recent/DEFAULT
>   # cat /proc/self/net/xt_recent/DEFAULT
>   src=aaaa:bbbb:cccc:dddd:eeee:ffff:0102:0304 ttl: 0 last_seen: 9733848829 oldest_pkt: 1 9733848829
> 
> but the provided buffer is too short:
> 
>   # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:255.255.255.255 > /proc/self/net/xt_recent/DEFAULT
>   -bash: echo: write error: Invalid argument
> 
> Cc: Jan Engelhardt <jengelh@inai.de>
> Cc: Patrick McHardy <kaber@trash.net>
> Fixes: 079aa88fe717 ("netfilter: xt_recent: IPv6 support")
> Signed-off-by: Maciej Żenczykowski <zenczykowski@gmail.com>

Reviewed-by: Simon Horman <horms@kernel.org>
