Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4258AC6FA82
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Sep 2022 00:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIKAuT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Sep 2022 20:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIKAuS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2022 20:50:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A009440BD6;
        Sat, 10 Sep 2022 17:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0908CCE0B04;
        Sun, 11 Sep 2022 00:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5ACFDC433D7;
        Sun, 11 Sep 2022 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662857414;
        bh=Vtm4P8fNdhOzhXWZOLB6CL1Oqs+jwbj3/shDxUT793o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nQadEecLAHR2pAFnr4z/9tQc+ARlkhX9zIrSL77DAHb0PwVe3S5mlQritepM06kB6
         J18P9pfggJnMqYtjjgB35RaxGXDrtgpg3Wg/QxHykLI4S7oQrpIDOU/QZHw5h3K6Iu
         XDgdeceKXCiamyJys86aCDx4IFXdHbZyVOviP0d7s7j41OocXRoKFjFSTSiP+KCufZ
         m6FxGnnkUyWDfZP/5K7vYGDjKKr1AEyUW43yU6kh0fYjOvP/M7eGZv5V3LlROpRkWs
         ZO/WkT/YZR0pzTi6bk33ANUpKwLsY1b9TPktLaqMC8a9EWEFpgN6VJiw2RJVJ4z8VB
         qrdxotiI/fAUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 378A3C73FE9;
        Sun, 11 Sep 2022 00:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix ct status check in bpf_nf
 selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166285741421.23649.1792728113996334824.git-patchwork-notify@kernel.org>
Date:   Sun, 11 Sep 2022 00:50:14 +0000
References: <813a5161a71911378dfac8770ec890428e4998aa.1662623574.git.lorenzo@kernel.org>
In-Reply-To: <813a5161a71911378dfac8770ec890428e4998aa.1662623574.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, song@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu,  8 Sep 2022 10:06:12 +0200 you wrote:
> Check properly the connection tracking entry status configured running
> bpf_ct_change_status kfunc.
> Remove unnecessary IPS_CONFIRMED status configuration since it is
> already done during entry allocation.
> 
> Fixes: 6eb7fba007a7 ("selftests/bpf: Add tests for new nf_conntrack kfuncs")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] selftests/bpf: fix ct status check in bpf_nf selftests
    https://git.kernel.org/bpf/bpf-next/c/f7c946f288e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


