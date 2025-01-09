Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB218EFD4;
	Thu,  9 Jan 2025 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736442029; cv=none; b=Qgokd+oGwECxHy6uh9S24ExFj1mYoj63cAqcIoIJwmq6jri+EIwHOLmezKKIZ4JW40U1ffeFfjZBirJD1cOsmB223PaARa2vo3x4eVWwUyIIlP3f955U7unfNI1QjOU/T6NA0eomjYnA7eBMkh62zB6mcWapUVxuWIUdSKMZXJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736442029; c=relaxed/simple;
	bh=RGcbmkp5R199fM6Pee+V30xTkmnsrNtH0sOMVIS+t7Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=E455j842M44J+yvpfoIAUHzb/1qX784cyioG0ilRXMG1A/x1IfzWROLMry2y3oX9Ojg3XBb80qMFER9GcupdKPeLC575ZFBwg735VOTN7gAuDLAQxoTJd7QyaO0xZLiTXG+0yX1YmOVEVNJX190YzMW0eCFDQPzfd6cFxoXgy7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8Rw+jU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8Rw+jU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2707CC4CED2;
	Thu,  9 Jan 2025 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736442028;
	bh=RGcbmkp5R199fM6Pee+V30xTkmnsrNtH0sOMVIS+t7Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=G8Rw+jU095YC7zTE9+QRDrFVAFsEW9tgxRFuX3yTnSawVEjlZbN29Duomh3ETGRhM
	 2/TmQUaO7i58x5vGF+xXPWc+TgWSPxfcMaEsp7aAcEMnZDduGq+ig7AQTmH1cDymvq
	 MYwo48MUDOY/VqunZpCVRXmjq6ZpOvTBh4AnaXLJ1UPAa92VSmffMvjondN5ZV4+Xe
	 icZefIRaWmlhme7yQ4rqtXfbNCkepimcTm53vWE+C/NbnZUwSBfWVhShjOECDW8sgM
	 JQaDLsKSwDY++8dNDxfAKEyN53ItrfktCdVS4sRUvUdVnVGuKcm5n/E2du9zkfYqLg
	 UITHv7DcLb5ig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1A3C4380A97E;
	Thu,  9 Jan 2025 17:00:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: imbalance in flowtable binding
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173644205002.1449021.7734848326971151272.git-patchwork-notify@kernel.org>
Date: Thu, 09 Jan 2025 17:00:50 +0000
References: <20250109123806.42021-1-pablo@netfilter.org>
In-Reply-To: <20250109123806.42021-1-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  9 Jan 2025 13:38:05 +0100 you wrote:
> All these cases cause imbalance between BIND and UNBIND calls:
> 
> - Delete an interface from a flowtable with multiple interfaces
> 
> - Add a (device to a) flowtable with --check flag
> 
> - Delete a netns containing a flowtable
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_tables: imbalance in flowtable binding
    https://git.kernel.org/netdev/net/c/13210fc63f35
  - [net,2/2] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
    https://git.kernel.org/netdev/net/c/b541ba7d1f5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


