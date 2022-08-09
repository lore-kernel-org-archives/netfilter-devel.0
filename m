Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC389C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbiHIQuQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243173AbiHIQuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 12:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328422605;
        Tue,  9 Aug 2022 09:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C175C60BC5;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22FCEC433B5;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063814;
        bh=BPQSBqEaQVzFpZHDlwohZzsm0tw/oJ4LWmWRpVos5IM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IAOoCZs07cjAlr8jyRSeGEVSmew3TyUJytSv4FfbPWVc44dCy8W8JsPmMfk1P+q6Q
         61u2/pdgyc6vg3MeNY0pEfttufH3+IZ3Cctc2eO+LXavqNAro5v2kBfAsmlr8Fc+Vx
         WkCeS8OiOGBBAKR8/wiBXwlvZPEcmiwNPPPdYEmuazZgDHD1QuphTwv1ZhoIOGD0aP
         +60kWA1niedGEpXaT75yAeEkAjAeTXhPwpIRsTfGJ3DSrrAU1QvDWVm0j8FEvEOPnp
         dRtBh1S1dV7iBwIm5sOpekx+VLNYScLimDmvj2PKk/kYlJK1EiMDK/iSHhZhooBJCl
         6rFwoMTHmGV8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A214C43142;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] net: netfilter: Remove ifdefs for code shared by BPF
 and ctnetlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166006381403.15335.8424596913469962895.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 16:50:14 +0000
References: <20220725085130.11553-1-memxor@gmail.com>
In-Reply-To: <20220725085130.11553-1-memxor@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, pablo@netfilter.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 25 Jul 2022 10:51:30 +0200 you wrote:
> The current ifdefry for code shared by the BPF and ctnetlink side looks
> ugly. As per Pablo's request, simplify this by unconditionally compiling
> in the code. This can be revisited when the shared code between the two
> grows further.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] net: netfilter: Remove ifdefs for code shared by BPF and ctnetlink
    https://git.kernel.org/bpf/bpf-next/c/6e116280b41b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


