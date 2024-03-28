Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D97C6D5;
	Thu, 28 Mar 2024 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711624828; cv=none; b=MakYS7AgeylZfgef/rQXOg//1UwsAvAcqJqhCL9O/uvXN1LjflyuFhJ6BA45IFtphyt90z2iD+TkpAP2keGf9PNELS8AUPuBmLMV1atQdJpmegRf3z9tQllvflwda0oxUPobrxBxTpXWbBbzGF2VEW8YCnXOGDlD5cb4jBPhjUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711624828; c=relaxed/simple;
	bh=rln8LQGT49GIKShKZMPcgTPrafkfe0C1BUR0MNCCD6Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZRCTxuO7TgOvJCL/yG+pXdx0clk6XFeHKuP8KWiPqfDsT/PrLYvuW05bN5xA1ge+no5M+neCqHoJfAcqKOD7LAfMOTSwjtpWGiyMIS6ScbZs7p5zWoou6HqU9kVhD4TjiAh0BJdUUe2xx+eCR6LZxF3Fj9Ap8ZgqMK3zBYLQzCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r16ejzt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r16ejzt/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D162C433C7;
	Thu, 28 Mar 2024 11:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711624828;
	bh=rln8LQGT49GIKShKZMPcgTPrafkfe0C1BUR0MNCCD6Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=r16ejzt/TlGwqOFXTFztcrEN+zhTGC4oNurDiVTb3m7RS23WPQHwJ0zDZMiBhjbhC
	 4757YJvSyMqOyilnnNWqEzip17eBHav95s7oohNHDyp8zF6rkwP5OipqpVydCypHBv
	 UgpMTxI47K0kALr9ghXHHxNBCbR7iIr3UmtzWzxxNcXk2QEGPEQyq2KH0KeboRhupO
	 jMXA855kzcOVy/IMb8NMyt+JB6A0A+MSPXnd5f5KkgfElVaBAduajTGQlvuT9SJqQ0
	 3WP0fHEItDgVMjPpBK6ygU9DOCHeDDyuGkB580JP0c7g8pxOn9Y1QADU5oUGOZAFUX
	 mXT1y6a0MOdyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CF29C43168;
	Thu, 28 Mar 2024 11:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] inet: inet_defrag: prevent sk release while still in
 use
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171162482824.5741.7261983024812909275.git-patchwork-notify@kernel.org>
Date: Thu, 28 Mar 2024 11:20:28 +0000
References: <20240326101845.30836-1-fw@strlen.de>
In-Reply-To: <20240326101845.30836-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, netfilter-devel@vger.kernel.org, edumazet@google.com,
 xrivendell7@gmail.com, samsun1006219@gmail.com,
 syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 26 Mar 2024 11:18:41 +0100 you wrote:
> ip_local_out() and other functions can pass skb->sk as function argument.
> 
> If the skb is a fragment and reassembly happens before such function call
> returns, the sk must not be released.
> 
> This affects skb fragments reassembled via netfilter or similar
> modules, e.g. openvswitch or ct_act.c, when run as part of tx pipeline.
> 
> [...]

Here is the summary with links:
  - [v2,net] inet: inet_defrag: prevent sk release while still in use
    https://git.kernel.org/netdev/net/c/18685451fc4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


