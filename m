Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D191D23FC5A;
	Fri,  6 Mar 2026 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772767975; cv=none; b=mf8ko+n/7kqNprEJDTANCXatBY8T8h8mJy4jxj0OzClBQ7bzHR3Wlk9CvTZwwBfVBpYmz0L4z6rBZGh2lybyQamVeZa8NfayOH2JZGcCcRFYEb+JI3k89yYigVrm9IugId1tszd+WIfPQ5oD5bJ1MrBIhCD+tm33m0TMHjAaofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772767975; c=relaxed/simple;
	bh=ItxcF5VTyBZrcq32AWIPmuH9Y22asDFhrdXLRz3yiAc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=H3lCLOv9Guwa5zTrwDa0906tGeGNNv/xyt+4o1eN5bQXGO0OQtYc27dA72jA3lz8vzwApty4+UqaNXdySyaDBbY9p6PnHuIqP/r44PGhSVD7Xrl2Zs+lZNU7BqPwLuGOeBZZEsSxeuXOk1oZzHsxKQkEHNzfeDIXGj0/XcsDwWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/JVoGql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/JVoGql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D762C116C6;
	Fri,  6 Mar 2026 03:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772767975;
	bh=ItxcF5VTyBZrcq32AWIPmuH9Y22asDFhrdXLRz3yiAc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=m/JVoGqlhSDDv3/5nNGgQwpC1JqgNNV8G+dawI9dDrrBuxyP/36vLbz6DlqQD6bot
	 yNGwEBlQqKvuuzi8QkLeg4ZGtOsRmnqWHN2LSK7nMHHoGJVEsuxbdhED85b8cV1Ycp
	 K+FXZarRCkND/F5csawkaU/LHhbfgS5jlGT4OHK2owYbkfuEVauWQacvaJPwrMgJsn
	 I/bRMxWQupYoM1iEI1V122pjQ9Vlayv1QopjERwBvNKQs0KxEG5cZfy54jfx6N7miW
	 v35U+z2muTkQbDMtMbl0b452tWZdxGepJWVE9SKwXDl2hqdeVB2otkW4zE89mqVujl
	 BAR309JrEnkgw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CF1C3808200;
	Fri,  6 Mar 2026 03:32:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/5] doc/netlink: Expand nftables
 specification
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177276797504.3348267.1807799589469287173.git-patchwork-notify@kernel.org>
Date: Fri, 06 Mar 2026 03:32:55 +0000
References: <20260303195638.381642-1-one-d-wide@protonmail.com>
In-Reply-To: <20260303195638.381642-1-one-d-wide@protonmail.com>
To: Remy D. Farley <one-d-wide@protonmail.com>
Cc: donald.hunter@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 03 Mar 2026 19:57:16 +0000 you wrote:
> Getting out some changes I've accumulated while making nftables work
> with Rust netlink-bindings. Hopefully, this will be useful upstream.
> 
> v8:
> - De-duplicate operation attributes.
> - Fix typo in max-check, add missing max-check.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/5] doc/netlink: netlink-raw: Add max check
    https://git.kernel.org/netdev/net-next/c/bf5a54bc0e3d
  - [net-next,v8,2/5] doc/netlink: nftables: Add definitions
    https://git.kernel.org/netdev/net-next/c/a3a54ba4ef2b
  - [net-next,v8,3/5] doc/netlink: nftables: Update attribute sets
    https://git.kernel.org/netdev/net-next/c/482da27d5274
  - [net-next,v8,4/5] doc/netlink: nftables: Add sub-messages
    https://git.kernel.org/netdev/net-next/c/27c7ee6d26dd
  - [net-next,v8,5/5] doc/netlink: nftables: Fill out operation attributes
    https://git.kernel.org/netdev/net-next/c/568b370f128c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


