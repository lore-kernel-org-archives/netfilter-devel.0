Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909815A8;
	Wed, 15 Oct 2025 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760496023; cv=none; b=tvlfs1B4tlN2W2ppPzP14X0yrc4JlxneTMZq/WwLwowVLcsOh/NaPCB7ux1QGDH7J2uga7C09AcUJtc5/B5hcNeMoNlFAcZgqtF2YgPrMWU4RlwUG39+/8sk3yNngG+jgdff6S+jBFxmK/Am9423ogm3m/fPmNdFA8uos60Q4C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760496023; c=relaxed/simple;
	bh=1sqiiP9jBdXP1f9uwkO5V3Wjjvpidmjin5tLGzVX+vY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BUoF7GnxAo6D5gdfhD0QRU1fc3j+m+J5GKXFWG0bsy/dra836eYD3TFVAOQTK+E2uk8FpWEf2YZFFqGLH8xYeRo2vxbsTcXX5UkMzIaCzBZrYg+uVDK0VcMxNdoe4Ibv0JBffjnFPXqN8rL1402LkKz/AOP2PwPThTHr4XJD05k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H01HI8Xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H01HI8Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7058FC4CEE7;
	Wed, 15 Oct 2025 02:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760496021;
	bh=1sqiiP9jBdXP1f9uwkO5V3Wjjvpidmjin5tLGzVX+vY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H01HI8XuS1VAIL7i9d/C5nIxXtBeEjkcQZUkzdex6tEB6vzSwPPg/QnJiIzYoWtFS
	 feh/rH0eo2cx7oazi6rDIzxGHGHExWtzvlczCVN3QEQE+mvr6H6uETyjkb5kGLBbXq
	 eXmd3AGAcOUZUvblnIWeUS3Hn4J3JFfiql7R7+fwhgntWbKT7dQZf6fzdfpfO6EXFZ
	 n1cwW+k5cKGI9PiPCo4MQOe+uWrEdUWZ0y2ZD96FkjGnVxGAiE/MiPLjnbFQibLWhc
	 qHK9enHpF/ItnuqJtNcGuAXQKgipNtDMdUJJLwHim2VXwMDQ2kY19OjR3RKt/89plR
	 tTsRDHONxaK7Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE828380CEDD;
	Wed, 15 Oct 2025 02:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: core: fix lockdep splat on device unregister
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176049600651.193903.16031508442804598392.git-patchwork-notify@kernel.org>
Date: Wed, 15 Oct 2025 02:40:06 +0000
References: <20251013185052.14021-1-fw@strlen.de>
In-Reply-To: <20251013185052.14021-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org, sdf@fomichev.me

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Oct 2025 20:50:52 +0200 you wrote:
> Since blamed commit, unregister_netdevice_many_notify() takes the netdev
> mutex if the device needs it.
> 
> If the device list is too long, this will lock more device mutexes than
> lockdep can handle:
> 
> unshare -n \
>  bash -c 'for i in $(seq 1 100);do ip link add foo$i type dummy;done'
> 
> [...]

Here is the summary with links:
  - [net,v2] net: core: fix lockdep splat on device unregister
    https://git.kernel.org/netdev/net/c/7f0fddd817ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


