Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7099D378D9A;
	Fri,  4 Sep 2026 02:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487468; cv=none; b=mDjOq/WYSZtuWkf1jG0FAkbdrJq74yyDNlmbI0zHzYJQj1rmPQ5ka0F4pqtOJlMDrntU95G0B9LVdll9ZR9qowJfAQbYBQpqFcNg869LoUyLTSRrQSDRoC4wbWDavjL4OvgWyidOR0uZ28Ln0uaiZ3uZKxqemrw7QZYcwuffqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487468; c=relaxed/simple;
	bh=Uh7Q9iZZz3SOiUFNzzt9kQAVGn0G6cLXZDWAFmg+iDk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7bFOy2qsXojqF6Qt9Ah4bsz5/7CHkggr0YgPFvHZQ56dJPBXeUCEZJ/G3ghYGZrSU0OPmblr2F83iHYq3qpIG8+TZrnfJFnrmYDDhq+v7yi8R/dXuPNWZ+ELRohfnhFyHkLclxIf2SwxzG90g7vhskTEAzDFaoUEaZUDj5JRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFZDIP5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFZDIP5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B41F000E9;
	Fri,  4 Sep 2026 02:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487466;
	bh=lhtpRqn5xkD7HX2ojfxltZtIMiBUmZJ7XD+0YdwazbM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YFZDIP5SyEy05XvZVaqedoCiCEEuacyVw28RPQSZcOguKewcRmN5D0FerSS6mmvNJ
	 V+JQZI+BL82IVgNQtb+xnRQc8/Hv+Yz55J1BJJK0B2yHDy1Ec8NoYZK7kMsfbLW8MH
	 cKqERrGelqCaqC8yRR34CJhwv98QefPaj6dxtLnougWN8D8oR0iA0qys/D3wu+qHTJ
	 3hkvqAC92DzZUHbV/zNr3X/zdpPdNDYDOI79Vi779CfYgojXZ1ZjunE2w+2ye3d8Ak
	 1pYhP7B5uoF+i9LcuvfNpVuU1Hi+mpaZnict5bU54Wan1yfJj9jpeV9YiqOKa7DVjF
	 4ZRpUuvdxWvhQ==
Date: Thu, 3 Sep 2026 19:04:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/12] Netfilter/IPVS fixes for net
Message-ID: <20260903190425.332cd930@kernel.org>
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  3 Sep 2026 02:41:37 +0200 Pablo Neira Ayuso wrote:
> netfilter pull request 26-09-03

I think the AI is now going too far claiming the patches don't fully
close the issue and/or the commit message isn't 100% accurate.
But we missed the net PR today, already, so why not confirm..
