Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518ADC25B08
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Aug 2022 20:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345876AbiHOUTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Aug 2022 16:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242296AbiHOURX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Aug 2022 16:17:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24950F46;
        Mon, 15 Aug 2022 12:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6833FB81113;
        Mon, 15 Aug 2022 19:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11F38C4347C;
        Mon, 15 Aug 2022 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660590014;
        bh=igEtDFyDX86Zzd6H6ZqMLRuFCiTeU4CezPBsoU96YE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2rm9cGD0iojsVby0QXR3dyizi/DpuQu4QRgtk7T/5+c64xKH/1UTgBzKJOwJTce7
         ycO2cIRkHEJ1YFpO4iCsDifaTUhMV8Lu46ddd63PL9IwAtXGOHWTbfavSyOLRahHS/
         Iq7jEBItDlMTbe1b69EMnV0v3BR0ZSFhG5c6Wyf0G1VrRife6W8jXw1eRMTCiFwMIi
         lO0HswApYjh7bdf8sh6XjCYbQqsNyTLwZ6RTZp13UQdgRNvSiR1PDKVIpettx3iHzT
         NnbOJfggTIdVmqkulPfaleaZx8/SbdB6gD22nnmQE+5giIX05+2ipMtfdHSyxT0ESr
         ZvyAQVT001Gww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB6DCE2A051;
        Mon, 15 Aug 2022 19:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4 0/3] Add more bpf_*_ct_lookup() selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166059001395.9081.18240847737000160882.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 19:00:13 +0000
References: <cover.1660254747.git.dxu@dxuuu.xyz>
In-Reply-To: <cover.1660254747.git.dxu@dxuuu.xyz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 11 Aug 2022 15:55:24 -0600 you wrote:
> This patchset adds more bpf_*_ct_lookup() selftests. The goal is to test
> interaction with netfilter subsystem as well as reading from `struct
> nf_conn`. The first is important when migrating legacy systems towards
> bpf. The latter is important in general to take full advantage of
> connection tracking.
> 
> I'll follow this patchset up with support for writing to `struct nf_conn`.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/3] selftests/bpf: Add existing connection bpf_*_ct_lookup() test
    https://git.kernel.org/bpf/bpf-next/c/e81fbd4c1ba7
  - [bpf-next,v4,2/3] selftests/bpf: Add connmark read test
    https://git.kernel.org/bpf/bpf-next/c/99799de2cba2
  - [bpf-next,v4,3/3] selftests/bpf: Update CI kconfig
    https://git.kernel.org/bpf/bpf-next/c/8308bf207ce6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


