Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B5CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 01:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BEA60EE6
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 01:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350650AbhIDBbH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 21:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236158AbhIDBbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 21:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FBC260FA0;
        Sat,  4 Sep 2021 01:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630719006;
        bh=ri81owLxvHNap5rbhdSUEwyArMA59ToI1mtPQBMvcKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J9LGteZOZL65Z26Qcwe8W7n66AAveWbjkU/GQgk/LA6zXlB1nKLiSqRcWue5OMyVE
         CfeBESoB7tqxzJ1vLaqCDa1Z6YDcDcxZWFlMlk25KDp+/K0dr7DYrI1KenCVkTa7oj
         vro3Z1bxYgXeAq426pPQ+N1thI09uvhJVdwwuAexCCyG9Qnd0cv3I+3HkA/P9aD0Jb
         pnxJF7twcpDxUebI7y11d9BLXsa6mj78Y32lKYJVJmrYoyldv+HI1giZSPHasLciWG
         0EQiYfQdZLTecww9D/vZ31Rmb0/9PPuQXZwNTuBQ51BbjmWc2DPj6Pp69J3/B1dia9
         XfSJ7eC1/ZIbg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nft_ct: protect
 nft_ct_pcpu_template_refcnt with mutex
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163071900626.25925.3624674342955727770.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Sep 2021 01:30:06 +0000
References: <20210903163020.13741-2-pablo@netfilter.org>
In-Reply-To: <20210903163020.13741-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 18:30:16 +0200 you wrote:
> From: Pavel Skripkin <paskripkin@gmail.com>
> 
> Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
> missing lock protection for nft_ct_pcpu_template_refcnt.
> 
> Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
> mutex to guard transactions") all transactions were serialized by global
> mutex, but then global mutex was changed to local per netnamespace
> commit_mutex.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex
    https://git.kernel.org/netdev/net/c/e3245a7b7b34
  - [net,2/5] netfilter: conntrack: sanitize table size default settings
    https://git.kernel.org/netdev/net/c/d532bcd0b269
  - [net,3/5] netfilter: conntrack: switch to siphash
    https://git.kernel.org/netdev/net/c/dd6d2910c5e0
  - [net,4/5] netfilter: refuse insertion if chain has grown too large
    https://git.kernel.org/netdev/net/c/d7e7747ac5c2
  - [net,5/5] netfilter: socket: icmp6: fix use-after-scope
    https://git.kernel.org/netdev/net/c/730affed24bf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


