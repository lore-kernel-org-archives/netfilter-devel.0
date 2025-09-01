Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21042765FF;
	Mon,  1 Sep 2025 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756758006; cv=none; b=VrJjfBQGL6tPwfRj3OaDlUlSyJe2fWXCojs0E0dYBJq0+WCWk3e4vQh7aK+toOpx5Gen+MVH4smeWuz5kkGXJX8cPRlU48eknGshlJuUfBxKOSDM9TU4Iyx1HD3tuYkTs4wHrukjQjInx2a12UzPbnLHAQNKRy7glUrkFxolqgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756758006; c=relaxed/simple;
	bh=eVgmRLaiF3mJuF/PUT8j6hrhv/EjCtq39HqhUjiXua0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YxF83H/IArpzHJuLqazCO/BCIqJ8v3nj+wm4ko+B52dqGr7tj0yKbU0sKGF1gHUUUJl/tl9hbIrEWbyYwy8Q9xPkVHKqFB8WesGR2Xp1MoEfL7LIe6aljt8VGRL72ZKMnSuaAHLx72hzAaEXG7vj+vypEAUXKmPqz/1rNHNwhCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tq9YMEpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tq9YMEpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E40C4CEF5;
	Mon,  1 Sep 2025 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756758006;
	bh=eVgmRLaiF3mJuF/PUT8j6hrhv/EjCtq39HqhUjiXua0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Tq9YMEptNU4euU0b4PGsRm2sHuggs4Iz5dS5Ln7iykdAE6yaoGwNbrYsW1DhMQvwI
	 1Z7QiQlSxAcQZVpV6uXhrp1yp1XytR0eLX/dXAg1Fjh34krN/L/oaBk8QryHWM+F9v
	 jaHMjfnS9xbTOzwmo4puMiEmmS4DwtVKddLFKNmNMepjNzF/qTEUceg6ouetWX+6ms
	 BTa3qAlVEr4HEvUs07nk/TS54wkvSSCtbfGY5fRfkep5TfxUY/nJcdjtFjRbqLg6EV
	 JfyXGYPNQM66Kl/E6+iZp4xvRXxFIaD6PUBU82tlZV6BdfL8axqaAZyTHqZvBwDeYS
	 bgtUIUD443vqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF39383BF4E;
	Mon,  1 Sep 2025 20:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175675801224.3872744.8064607447852052673.git-patchwork-notify@kernel.org>
Date: Mon, 01 Sep 2025 20:20:12 +0000
References: <20250828091435.161962-1-fabian@blaese.de>
In-Reply-To: <20250828091435.161962-1-fabian@blaese.de>
To: =?utf-8?q?Fabian_Bl=C3=A4se_=3Cfabian=40blaese=2Ede=3E?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jason@zx2c4.com,
 fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Aug 2025 11:14:35 +0200 you wrote:
> The icmp_ndo_send function was originally introduced to ensure proper
> rate limiting when icmp_send is called by a network device driver,
> where the packet's source address may have already been transformed
> by SNAT.
> 
> However, the original implementation only considers the
> IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
> source address with that of the original-direction tuple. This causes
> two problems:
> 
> [...]

Here is the summary with links:
  - [v3] icmp: fix icmp_ndo_send address translation for reply direction
    https://git.kernel.org/netdev/net/c/c6dd1aa2cbb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


