Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE2819939E;
	Fri, 15 Nov 2024 23:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712221; cv=none; b=VL24s+Najk+KDO3ri+3zmPL7nuvKpYstn17NiwBdAJNY2gHuih/jwb0L0hD9NzDjxR5/7ogll/BBobZ1w4F2kMRFEVbrj1wm3rbxlVmjj9cN0uAf89Dp8Gr5DKHsIEEZtbvCIiKUwpGCUuvV+zLw6l2ofDlvuGcknXsOV2r8Ock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712221; c=relaxed/simple;
	bh=zU6jZgPuH47V+0fJsvxWznPhNrauHBt8/gyVGAQAvXM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BjDylMobikZTvT8FJdwl64Byux9nkatSfrsojem2x58U1BpzcAr9WS45S9WXgFmU75F2RboJhliC74Q1Ric9qLkzTGPZBpd2DdkVZyGF77QPoFc+a4/b1H5QowjvPNyIEDTxTyzvxGUv9lEVLTk7xXfErtXyiztU3c+FNkHD4m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3wwk30R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3wwk30R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2731DC4CECF;
	Fri, 15 Nov 2024 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731712221;
	bh=zU6jZgPuH47V+0fJsvxWznPhNrauHBt8/gyVGAQAvXM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V3wwk30RQPu1GvL2/GD8tSUGURWHggC1HoSnqsG/llv9LEZnUhXFHYbjaJb1a9jdG
	 SpD/NWS1RLH0YY13u/dKXAqxpSIaQyn8XsW+WlPyK7D+weZRi+Baj8+RuW9slXdmLD
	 cLqV0Z/hdqRJ4GbDydAZsBb130NTUrG3Z+SnwdfWeQejlflZxvH4uAvmwKTaNk6N4s
	 ts530wsL40k28LYbqXzMGCQNYNFG9VEVqu69RLyN/I5gIDFnB2mIty2ZTojuGleYQF
	 QIKsZ/g0rvQfKfqpJ1d13/zn572NhNv6OpEyGnzHasaEEZOj3butzMZ/sIOwcNoPhZ
	 /1i8W6v58kFbA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33AE13809A80;
	Fri, 15 Nov 2024 23:10:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] selftests: netfilter: Add missing gitignore file
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173171223169.2762542.5187225285708817674.git-patchwork-notify@kernel.org>
Date: Fri, 15 Nov 2024 23:10:31 +0000
References: <20241114125723.82229-2-pablo@netfilter.org>
In-Reply-To: <20241114125723.82229-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 14 Nov 2024 13:57:21 +0100 you wrote:
> From: Li Zhijian <lizhijian@fujitsu.com>
> 
> Compiled binary files should be added to .gitignore
> 'git status' complains:
>    Untracked files:
>    (use "git add <file>..." to include in what will be committed)
>          net/netfilter/conntrack_reverse_clash
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: netfilter: Add missing gitignore file
    https://git.kernel.org/netdev/net/c/df6cb25f0779
  - [net,2/3] selftests: netfilter: Fix missing return values in conntrack_dump_flush
    https://git.kernel.org/netdev/net/c/041bd1e4f2d8
  - [net,3/3] netfilter: ipset: add missing range check in bitmap_ip_uadt
    https://git.kernel.org/netdev/net/c/35f56c554eb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


