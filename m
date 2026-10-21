Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792548609;
	b=vyUivlsgg6FQwHPmLcsKBqfEVGYzo4nXY2QOahb3MeNqfJdQ2ax4zeoIPelhA+C/o7Df
	 dJ9KBzAVAIVCCiLwmqrsKLebtbnZRo6KYaOGuut7swgRJECd3BgqArLg1wxjMd4TCKHx5
	 h+yibBYwm8x8vB9sc/39D57jCKC+0HgfkBsNqKWg/B0A+Ku5vCWXkEdVUT1Mqg+K4dUIa
	 O/Pk2LD90TSF23kZG8TLr6Cp5Urf1iNLx8Lotw/qjEG86uEy0uA9Hl9JoOsS1mrS7TrEE
	 mcU3Nvg7UIUap7tYVid0z0qT5Tsfs3G5OjzRodAO99Lju0CMg+osjNVoJm6MRlMIdQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792548609;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Oy9Y+Nh0izvjoZi1CnAEtiDpI2daSsikIR7SEEnvW7s=;
	b=mcra/0vs18bYuSO+wNqdgwrd9sTJtgCNG7RMgMWrhBOORS+l/HvKPfFcPX/Qp5nezOKj
	 H8xSRH1Uc/kjFYcVQGaCHbvN+FZg+C0G9Lmu0KBo8oOShG7XPc9rO4rK6i0+CTMM/iNrA
	 Kn7rg34KljbiyFtE5Bl4fUQm0MKW7aAstQb0522ukCVxsZGLKmgnOT/LSigeHFUzjV4f5
	 zYtkNKYet3NencuOJG3ceQsJFTPfD5WLPygd1OCTn7ON9sslvBr/DTsiKskAMvFPeXnOA
	 e4xQjtUAIleG78zgde9It0bmLm91zUoPC9mEnr032T+U+ym1rz6gmungPjXfozVJXYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPOCTbHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD49A606A31A;
	Wed, 21 Oct 2026 02:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPOCTbHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085971F000C9;
	Wed, 21 Oct 2026 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792548608;
	bh=Oy9Y+Nh0izvjoZi1CnAEtiDpI2daSsikIR7SEEnvW7s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lPOCTbHyXJ505XEzTCXV5SEMfT5mwYGc5WPS6k59jmfJHzZOMpxSld3uSFcU5SMpi
	 5cyvfBhrtmB4YuL1K39xPLU4eJCROBJ1ltumkdZ1n8JL94xUTp5izho7VbvAZRJsKw
	 wkTpKpwyDO8WBeiQKLbFRsfdzHmU3KanqhWhny74kDXIrvAHvhcqE+o+DmED78rA+u
	 X1FMsI1jJbvBB3rl+bme84JFCw+7pcHAq8mQtn67mqX1bRqObZH6auoAiGUHV/HKrE
	 7gKxSceGPHqzZ6zEIoySHCrOvPXlzYkOlRRGB/gWo5sq+3UydDPDzf1JV31eIpVapt
	 k9Hjd8xyRtEKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F153C3809A0D;
	Wed, 21 Oct 2026 02:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: nf_conntrack: avoid truncating IPv6
 nexthdr offset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179254860678.327181.10126118111103524829.git-patchwork-notify@kernel.org>
Date: Wed, 21 Oct 2026 02:10:06 +0000
References: <20261019150249.1879516-2-pablo@netfilter.org>
In-Reply-To: <20261019150249.1879516-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 19 Oct 2026 17:02:40 +0200 you wrote:
> From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> 
> find_prev_fhdr() returns the offset of the Next Header field before an
> IPv6 Fragment header through an int pointer, but stores the offset in a
> u8 local.  An extension header chain can put this field beyond byte 255,
> causing the offset to wrap before it is saved in the fragment queue.
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
    https://git.kernel.org/netdev/net/c/48d522b65fb0
  - [net,02/10] netfilter: nft_payload: restrict checksum offsets to known values
    https://git.kernel.org/netdev/net/c/c2226f0c7fe9
  - [net,03/10] ipvs: fix more races around the overload flag
    https://git.kernel.org/netdev/net/c/3ba20137287f
  - [net,04/10] ipvs: skip committing sync_threshold when proc_dointvec fails
    https://git.kernel.org/netdev/net/c/7f1a04254a05
  - [net,05/10] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
    https://git.kernel.org/netdev/net/c/c203ecf90574
  - [net,06/10] netfilter: nf_reject: initialize IPCB at inet ingress
    https://git.kernel.org/netdev/net/c/73a73d442f99
  - [net,07/10] netfilter: nft_set_rbtree: narrow down range completion to anonymous sets
    https://git.kernel.org/netdev/net/c/86d47d4c84a1
  - [net,08/10] netfilter: xt_dccp: handle reserved options as single-byte
    https://git.kernel.org/netdev/net/c/2edda78aa4eb
  - [net,09/10] netfilter: flowtable: reset transport header after nf_flow_encap_pop()
    https://git.kernel.org/netdev/net/c/08f7882637f2
  - [net,10/10] netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter
    https://git.kernel.org/netdev/net/c/cd37ab22a74e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


