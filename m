Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69A121B9FC;
	Fri,  9 May 2025 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746755988; cv=none; b=ReOrlfgUd33Qo5yA3RzKgQXtUdyQxmDL988KqjV2zUMN24nZn1U+fsvbF14EE6p8dMu8SyqaQLiv4VDc7YvOisfamkvoT+JQDa8c4RS89BhUoRlcixv7YcFyrzhZODH8bSHIgbveGd0EyNH4pl5DNX/6niTgsHI9KUSJU0IJ3hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746755988; c=relaxed/simple;
	bh=H8CqdGDqcMJN7tGaZLTrnM8ZdswZoMI7c2u2YZCfwyM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kza1UAykt9faQn5V6l6avAazg7Wxi0n1Z+WdtKESmyizsERoU1bdTdR4Bt1n3ttLd+GtB9h4BeWeQN9XRrA3P/L94lWbrst27CgukhZfstQ7ndTdrbziJX5VC0v+kqpCllOI0h2d9LizuSBByZ0BiNV374arnk9XZ+6NOnevAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmG0DrnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmG0DrnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D0EC4CEE7;
	Fri,  9 May 2025 01:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746755988;
	bh=H8CqdGDqcMJN7tGaZLTrnM8ZdswZoMI7c2u2YZCfwyM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FmG0DrnWUGYpnt5vJIAeg43xSUmpwrOZZ7v/96Fou1lKpf/+uN6DD4FnGrhltdHMV
	 +pl3gwL41U4mwoQvylxQn1cNWY3H98uBxUE7yJBj8F2uyfsDx5zQ3QmLCO5tp15zxZ
	 BfAg6jfc1u4WHr6OanfLY6gT2lZyRfPXVHKwOlYnphXqqh30b9h6W1hJW9+jHPttAB
	 o7uNZIYeguNi4kteBsjgcEcItI2z9f3pCC1tMFrdYFNZwOmU0MeW5taJXcRbZqmOef
	 09e/jz+5n1z9Yq7PF4earmZn2i3HeXW3Y61WiKZ/0g8c1C5KZUfBcz8aUI8UI7Fgds
	 tnkfe3dd1pY5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BB8380AA7D;
	Fri,  9 May 2025 02:00:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: fix conntrack stress test
 failures on debug kernels
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174675602728.3099791.5492591067359411672.git-patchwork-notify@kernel.org>
Date: Fri, 09 May 2025 02:00:27 +0000
References: <20250507075000.5819-1-fw@strlen.de>
In-Reply-To: <20250507075000.5819-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, kuba@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 May 2025 09:49:55 +0200 you wrote:
> Jakub reports test failures on debug kernel:
> FAIL: proc inconsistency after uniq filter for ...
> 
> This is because entries are expiring while validation is happening.
> 
> Increase the timeout of ctnetlink injected entries and the
> icmp (ping) timeout to 1h to avoid this.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: fix conntrack stress test failures on debug kernels
    https://git.kernel.org/netdev/net-next/c/1f389a648a3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


