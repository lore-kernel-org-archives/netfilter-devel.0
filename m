Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD948826;
	Thu, 25 Jan 2024 05:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706159427; cv=none; b=p1uXLYxsSLCRJJk9CDNPnS4hOjVVeMUXjjk4tHghmIKMtcaDqPXOlarIFnkbo2as0Anf1XjAc2PseFd+HN7Ived4MKGlpImUTZhDnwSzCnGP3k0t6B2mII8EWPUfp1qPOzlIbKqrdlGGDHu3uvCCtXvxgTTXs4etApLKqfTmboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706159427; c=relaxed/simple;
	bh=QC0301SrHzJHW9DYLg53H0SRvTyQVG4kPx+tfSccbSg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Nn+DIN3ShMuSVvCLCxQVxwuhdgqtoSP61rCVGWdpeqVbz8u/rN0EMCATrV9Q/T451JfzWK2VLJaErlmWHRnqMcYn9vC+yMhEkHGjSY6+zEf6TLxOzulc6ziQfvlWQvnRY8ehJXvnvHFQh+T0hH7QcwVNXN9YRPchwL9w1++9z/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvGKlbKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvGKlbKi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6F67C43394;
	Thu, 25 Jan 2024 05:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706159426;
	bh=QC0301SrHzJHW9DYLg53H0SRvTyQVG4kPx+tfSccbSg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fvGKlbKiyg/FMD5GZu6CON467TGlU4YfeNcohtxx8tM90qWYiBwBZElpQT1AR1azq
	 /0bI/FFoSVqkBce6+Oz5EdDJSm5iCn/jc1H40t4AgZ5aBTBEZHCn5t4NvI8dBdD7Oj
	 m7iwltY+vmQ6GQ3N5wJZxNyjioYkhr4gW+wq4pzk+iW2zJuzYEdIe5sR4OYLlVy2fh
	 QBxevNvTuqfg8tUB2HtrwoAtSpKjFR1njYsehbPfD9zwh5pbXQC5Juj3qb57X/DA1B
	 dvayIZJh436OJYPpZzESilCkX+FEbiV1mtEHh+aA8/rqDKcUdcWCZjULClx+9GJsRz
	 l+ph35EsZbbzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8FB83DFF767;
	Thu, 25 Jan 2024 05:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: cleanup documentation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170615942658.29950.2948954213736733610.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jan 2024 05:10:26 +0000
References: <20240124191248.75463-2-pablo@netfilter.org>
In-Reply-To: <20240124191248.75463-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 24 Jan 2024 20:12:43 +0100 you wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> - Correct comments for nlpid, family, udlen and udata in struct nft_table,
>   and afinfo is no longer a member of enum nft_set_class.
> 
> - Add comment for data in struct nft_set_elem.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nf_tables: cleanup documentation
    https://git.kernel.org/netdev/net/c/b253d87fd78b
  - [net,2/6] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
    https://git.kernel.org/netdev/net/c/01acb2e8666a
  - [net,3/6] netfilter: nft_limit: reject configurations that cause integer overflow
    https://git.kernel.org/netdev/net/c/c9d9eb9c53d3
  - [net,4/6] netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
    https://git.kernel.org/netdev/net/c/b462579b2b86
  - [net,5/6] netfilter: nf_tables: reject QUEUE/DROP verdict parameters
    https://git.kernel.org/netdev/net/c/f342de4e2f33
  - [net,6/6] netfilter: nf_tables: validate NFPROTO_* family
    https://git.kernel.org/netdev/net/c/d0009effa886

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


