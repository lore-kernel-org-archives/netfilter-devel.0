Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B008ECAAD5
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Sep 2022 00:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiIKAkX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Sep 2022 20:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiIKAkW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2022 20:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4A43DBF2;
        Sat, 10 Sep 2022 17:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECAE60D45;
        Sun, 11 Sep 2022 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 406E7C433D7;
        Sun, 11 Sep 2022 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662856817;
        bh=VHe5y+jAO6gJCiomfSt4X8g3GEnLnC9eWhfnpIYIqaA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhY2819sYk/XJv9sTc/PRoToAyLBBuVqu483USGNIw+N0h/ayyly3cIZgWASkM+uq
         FNH/M1MKDjC7yJWot9f5OG5D97FftXYWk+bKyakbwh0CL9c+WF5ZgZqwjemYFPlBtq
         p4kcYkbTVyO/POd6a9dQTgsCZaNLF127GJPdfATpPT2ABx4BbYx7Tsug2Q5soz+dC+
         mR4GXI4O+HSjyNrX38xLNQ6QLPKgUWj1m5RQ3fA8fZ73rA4WjbKB8Bcil7XDnTFt/G
         CfiDOb760sHeGSpAEj342W7xLoYZqAh+GexScelhC94bvpe+zB32uTo8E63zCuXfro
         xAiYGayR1JxiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FADCC73FF0;
        Sun, 11 Sep 2022 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 0/6] Support direct writes to nf_conn:mark
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166285681712.18334.81256966061837862.git-patchwork-notify@kernel.org>
Date:   Sun, 11 Sep 2022 00:40:17 +0000
References: <cover.1662568410.git.dxu@dxuuu.xyz>
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, pablo@netfilter.org,
        fw@strlen.de, toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed,  7 Sep 2022 10:40:35 -0600 you wrote:
> Support direct writes to nf_conn:mark from TC and XDP prog types. This
> is useful when applications want to store per-connection metadata. This
> is also particularly useful for applications that run both bpf and
> iptables/nftables because the latter can trivially access this metadata.
> 
> One example use case would be if a bpf prog is responsible for advanced
> packet classification and iptables/nftables is later used for routing
> due to pre-existing/legacy code.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/6] bpf: Remove duplicate PTR_TO_BTF_ID RO check
    https://git.kernel.org/bpf/bpf-next/c/65269888c695
  - [bpf-next,v5,2/6] bpf: Add stub for btf_struct_access()
    https://git.kernel.org/bpf/bpf-next/c/d4f7bdb2ed7b
  - [bpf-next,v5,3/6] bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
    https://git.kernel.org/bpf/bpf-next/c/896f07c07da0
  - [bpf-next,v5,4/6] bpf: Export btf_type_by_id() and bpf_log()
    https://git.kernel.org/bpf/bpf-next/c/84c6ac417cea
  - [bpf-next,v5,5/6] bpf: Add support for writing to nf_conn:mark
    https://git.kernel.org/bpf/bpf-next/c/864b656f82cc
  - [bpf-next,v5,6/6] selftests/bpf: Add tests for writing to nf_conn:mark
    https://git.kernel.org/bpf/bpf-next/c/e2d75e954c0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


