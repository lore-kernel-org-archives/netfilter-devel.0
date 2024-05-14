Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA58144306;
	Tue, 14 May 2024 13:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715693765; cv=none; b=rmZXtJbzkHasJm8dhFO6+YuEgEd4EYuE2T5Y0X1fgBpTyn6p6FaAR6CZATFYtvHBBXJBK/7hUF/bMmatCd7UpIUF9Pcp99y/ID6v3gKuj8UgG9C1+LQli+7a7wh1hwffzxFO0pUF0ZbeNqgxYxDgQHCWpet5EW34vsP78wZGGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715693765; c=relaxed/simple;
	bh=kX5gvg7vRassOfVg9WOjYsBfAxZcTK6+oGoeDBE0bjk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tK30Kw0KXG2VkOV4+L+ACkVxNUvEDj0vxUQWZ9gflPIfHAV4T3rCUNLDs7Bpu304TRJuFNMzEU3H2VQ5uDaAh7I7MjA4+3AvwM76FW02xJQphyD567T9IqOvzJBo+u7wFcj31EoAaOEL4DyDfg++22kdZTovb/RLKyco/MYn0YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/ZZKvEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/ZZKvEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD53C2BD10;
	Tue, 14 May 2024 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715693765;
	bh=kX5gvg7vRassOfVg9WOjYsBfAxZcTK6+oGoeDBE0bjk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i/ZZKvEGTtTlMy9h4QqPNGhXBCpv2BuvaEarn709cxyl1e2mon3dt4/AsER9FnOzT
	 wjVrFXby+A7W1/KU1GI7ENSPZuqJY9YfzdXPLCWAJGEdccE9lb6QGm4w7lviwYgUj9
	 nBf3TN0XhuVzRyMiYDhznZlECWmJWUXhV2NxbF/48XsJYiByiOpeq9NvCJJFmUGwLR
	 pS4ntF9CxYUwRftT+QdzijqrSxadokn9nY/H7yDNWV9Vv5NnIPdpwzna99CDnLA79d
	 +zdv2y+1MCNz11pJtXu4svZW84twyrU6ReGgVjIyS7UtW5qtNAL3DzckVKXEbbjvkj
	 HK7dl7tTCM6QA==
Date: Tue, 14 May 2024 06:36:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 16/17] selftests: netfilter: add packetdrill
 based conntrack tests
Message-ID: <20240514063603.45234a45@kernel.org>
In-Reply-To: <20240514050930.GC17004@breakpoint.cc>
References: <20240512161436.168973-1-pablo@netfilter.org>
	<20240512161436.168973-17-pablo@netfilter.org>
	<20240513114649.6d764307@kernel.org>
	<20240513200314.GA3104@breakpoint.cc>
	<20240513144114.2ae7bf1a@kernel.org>
	<20240514050930.GC17004@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 May 2024 07:09:30 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > Ah, makes sense. I added a local patch to the system, it should be
> > applied on the next test, just to confirm.  
> 
> Test is passing now, thanks!
> 
> Would you apply the patch to net-next or do you want
> me to send it myself?
> 
> Either way is fine for me.

You know all the deets, better if you send one, I reckon.
To whichever tree you prefer.
