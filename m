Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979458129;
	Thu, 21 Mar 2024 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711020628; cv=none; b=XL/HjjexM7AYNY82nlLo8+6HUoTVJAr9S+skXE6zYJLJqMCxpR9LaUOpG5gSBhZuzNZNoNTLYK25GCYO0vufP2U2kIMaXX758gSqU/DPquQP5FvnOQ6F3fKnkPbr8a0+I6ZOAoofaqJZKXXehrZ8OL3XpTMyIzWNUIbzVVA5W6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711020628; c=relaxed/simple;
	bh=/zDXgs/8yJDitqcsFp4hXCsj5PMMuUopeXf++m5GMU0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GGBI+wE15RCJ23qbwHQN4GoIaed0ythqhLsGjb83OM3TV35EI+hHo8q9ta9O2pBAtjy4BGx7vaq5KFLW2RJ5ydw7e+8FBSDt1l+1+0bYhYnM6hwjGJNJw2m6jv6iCMmbCv4gUhdaNQvFmxydeYsNrBVHBb3fuMHY7rgh5x9XFP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4B0LIMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4B0LIMh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 937B1C43390;
	Thu, 21 Mar 2024 11:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711020627;
	bh=/zDXgs/8yJDitqcsFp4hXCsj5PMMuUopeXf++m5GMU0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q4B0LIMhyzJgS+/kvNkHnVlv4Z0U9BR06AwFv938/Jo0OpA579tgi57io0vP1IFQz
	 txxnjruOQJsQaqImeQdFWrkD1eZ9ahK64CkUjwkoe/GgcVmw9EwALs+PVQx4M4lc3U
	 D62Kq5rUgXmK9qPxvZA7tpX64uim4Uo57ZuaZLmx0JhPTG2M/DuyNaDORHzVuFcwQ9
	 DACcKDoIFSx9UwgPFxccQtlL5lbKJWlZ1POA4UrmgXMxJ/gzmKhsJ3EoGODBzmysFM
	 2PIuu12LhYnsgOc1/3MOq5X3oLo+xwEEKx6qGsxgqVDg+aDR54JIQVA7C1AZptOGE+
	 WVEUUklb+g7mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FC7ED95060;
	Thu, 21 Mar 2024 11:30:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: step down as netfilter maintainer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171102062751.7572.15636806653890056442.git-patchwork-notify@kernel.org>
Date: Thu, 21 Mar 2024 11:30:27 +0000
References: <20240319121223.24474-1-fw@strlen.de>
In-Reply-To: <20240319121223.24474-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 19 Mar 2024 13:11:54 +0100 you wrote:
> I do not feel that I'm up to the task anymore.
> 
> I hope this to be a temporary emergeny measure, but for now I'm sure this
> is the best course of action for me.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: step down as netfilter maintainer
    https://git.kernel.org/netdev/net/c/b5048d27872a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


