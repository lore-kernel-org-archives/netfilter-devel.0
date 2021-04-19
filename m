Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C97DC433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 23:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5296461279
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 23:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhDSXKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 19:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhDSXKp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C70461354;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873815;
        bh=b3xPWVurOx4H5tulhsmo382MBUVxI6ZSXYL0VdSOoTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RuYfIO7OVVprempwinbkEZjY936N5A6yz+iVKZMfVkDfyVWwXxPl2kAcUiBLERBmk
         Ere9gbVwl7AWCmn8bJSx7qT9a8LIQZEVBp+BnMY4ZRvbTslVpDQqz91Jk2OSqKdmm7
         K5n6jaKrukS6jyAPNBpoilddv6zTtQX5EU4GVWHHStVMO9qgXKvVwDelqGtkyQZoY9
         Xsejcji5+zSUlXBXmIQ5eVb+iBglj683JSf6pjldljfmsO/ddcnqE+rimu9Dj2upuZ
         ew9hmr2BAKpy1WCzcKLjnvYuuwxUPun20aQZRIskjMGaTi/MXGZ4y60J32TIy1dzUw
         pMkk6teJtBawg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/14] netfilter: flowtable: add vlan match offload
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887381522.661.4474273740552244895.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:15 +0000
References: <20210418210415.4719-2-pablo@netfilter.org>
In-Reply-To: <20210418210415.4719-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 18 Apr 2021 23:04:02 +0200 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch adds support for vlan_id, vlan_priority and vlan_proto match
> for flowtable offload.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] netfilter: flowtable: add vlan match offload support
    https://git.kernel.org/netdev/net-next/c/3e1b0c168f6c
  - [net-next,02/14] netfilter: flowtable: add vlan pop action offload support
    https://git.kernel.org/netdev/net-next/c/efce49dfe6a8
  - [net-next,03/14] netfilter: conntrack: move autoassign warning member to net_generic data
    https://git.kernel.org/netdev/net-next/c/098b5d3565e2
  - [net-next,04/14] netfilter: conntrack: move autoassign_helper sysctl to net_generic data
    https://git.kernel.org/netdev/net-next/c/67f28216ca04
  - [net-next,05/14] netfilter: conntrack: move expect counter to net_generic data
    https://git.kernel.org/netdev/net-next/c/f6f2e580d5f7
  - [net-next,06/14] netfilter: conntrack: move ct counter to net_generic data
    https://git.kernel.org/netdev/net-next/c/c53bd0e96662
  - [net-next,07/14] netfilter: conntrack: convert sysctls to u8
    https://git.kernel.org/netdev/net-next/c/9b1a4d0f914b
  - [net-next,08/14] netfilter: flowtable: Add FLOW_OFFLOAD_XMIT_UNSPEC xmit type
    https://git.kernel.org/netdev/net-next/c/78ed0a9bc6db
  - [net-next,09/14] netfilter: nft_payload: fix C-VLAN offload support
    https://git.kernel.org/netdev/net-next/c/14c20643ef94
  - [net-next,10/14] netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector
    https://git.kernel.org/netdev/net-next/c/ff4d90a89d3d
  - [net-next,11/14] netfilter: nftables_offload: special ethertype handling for VLAN
    https://git.kernel.org/netdev/net-next/c/783003f3bb8a
  - [net-next,12/14] netfilter: Dissect flow after packet mangling
    https://git.kernel.org/netdev/net-next/c/812fa71f0d96
  - [net-next,13/14] selftests: fib_tests: Add test cases for interaction with mangling
    https://git.kernel.org/netdev/net-next/c/8826218215de
  - [net-next,14/14] netfilter: nftables: counter hardware offload support
    https://git.kernel.org/netdev/net-next/c/b72920f6e4a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


