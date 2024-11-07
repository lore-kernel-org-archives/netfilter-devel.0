Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CEC218339;
	Thu,  7 Nov 2024 20:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012484; cv=none; b=WHPTCgPnYxCTm7DtVPl9ilLPBdJ9mdtariszmAghJotmnqHvw9C4K7RnV80Wte5cJqKsjdR4+INN3jvcp3SCDnAuOQ30poVd4n/kHZrfKZk9HyShJyLWXtXUBN65josH+pK1x3OpVkiFRaDe5l9xfuC+zbUdtqamihMP4bT1K10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012484; c=relaxed/simple;
	bh=CkYOhQy63q7pImPZKagyugMZd1sNN57Pz9JKej/6hj8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T60ngjDQg7u7xU8M2D/g4iwfU3HDu4G/0z5ihmv25chIxQZV5ODxsDe1MRz49/nVwuP4CJFu8DYNz/KUCpdTO0dCPnP3YFEPju1CGUkHEPTGT5S0abEaZN9a1AzCv3tgVQihGh551Zf8/Y3OFkk+/Q4TZRXx4kiZV374JK8Io9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BT1HdpCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BT1HdpCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82019C4CECC;
	Thu,  7 Nov 2024 20:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731012483;
	bh=CkYOhQy63q7pImPZKagyugMZd1sNN57Pz9JKej/6hj8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BT1HdpCNKhD9AcYUIPYyyaERtBXIgMAggRp/17ZfCfC1cJJYp0kdCUhP4bKfGjZE6
	 kXJW4vmRzqqZ+N0VlwqXrQHvyPGho/xO4Y56hmt3KkG7B56rpsTJSNdrwZBTpsBny2
	 3jbE951oUr0dZ7ANsxlBhox088HJDO5Dh7cCKVPbwGJ4xRF5KliEE2oYaRtBrcQxNJ
	 hYnSF3RJaMIf0IuH0LyaMXv53323HVyLyPU1mBiR7AHW6hbcef9a9WN45uqNlYgJLb
	 tyVw+YWCvplWQmHT8OnA2bqHCm0YaENQdol7q9gOY4OsZ7X50bPZ7meu5uQaHJqj5z
	 pnxv4kyw1tXig==
Date: Thu, 7 Nov 2024 12:48:02 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 00/11] Netfilter updates for net-next
Message-ID: <20241107124802.712e9746@kernel.org>
In-Reply-To: <20241107070834.GA8542@breakpoint.cc>
References: <20241106234625.168468-1-pablo@netfilter.org>
	<20241106161939.1c628475@kernel.org>
	<20241107070834.GA8542@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 7 Nov 2024 08:08:34 +0100 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu,  7 Nov 2024 00:46:14 +0100 Pablo Neira Ayuso wrote:  
> > > "Unfortunately there are many more errors, and not all are false positives.  
> > 
> > Thanks a lot for jumping on fixing the CONFIG_RCU_LIST=y splats!
> > To clarify should the selftests be splat-free now or there is more
> > work required to get there?  
> 
> I tried to repro last week on net-next (not nf-next!) + v2 of these patches
> and I did not see splats, but I'll re-run everything later today to make
> sure they've been fixed up.

Great! I was double checking if you know of any selftest-triggered
problems before I re-enable that config in our CI.

I flipped it back on few hours ago and looks like it's only hitting
mcast routing and sctp bugs we already know about, so all good :)

Thanks again!
