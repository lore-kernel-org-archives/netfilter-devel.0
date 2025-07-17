Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980812E540E;
	Thu, 17 Jul 2025 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752758620; cv=none; b=QSjvGArQH3g4cEwKv4guKviEL8OPZUyQjPOjhUd/58ANJcC4axzxmU0oIBmRQYplFePa/pB83/J1mLN6MOntC2tUAkFTctpUg0nAgsFvlvBRve0v4600Ee1zSgcRdkjA6pi2HYTUpVhNGEBYhsGX8zmRwRztbDj1del6TaDDhfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752758620; c=relaxed/simple;
	bh=mx50udsOrY4nJPMx/5UO61lbKUIUfTH0aOk0LIinwV4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjLpq5Q5tsUAg9mpGGFDyRsDNQBP4hyGhnjSXYkpo3zhkAVHNc0cswG+UyGl0+ibk45AyS6N0T011MWixVC9pqyh50Zw0rok7XQusLzMms4YeNsHk4DFBsJqUhsDfqmCoUajK0hf/YIibsLtEkPwp+xr3DXxAEFJ6+xz4ATBVEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxXAauIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxXAauIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD82C4CEE3;
	Thu, 17 Jul 2025 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752758620;
	bh=mx50udsOrY4nJPMx/5UO61lbKUIUfTH0aOk0LIinwV4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LxXAauIz0QShsLSZoVEwvtUCG9wn71iRWgX71iSUEnoa105FTe61ZLRJaXByv7Ezh
	 58mTHqVB52FdkJvx9wsZR4NLTwDFuH6qKOpQnOwOgjoWv5vyctgmU+rf47waLh6d6m
	 RJ8wR7IP5tOf54Y9kp8xbILo26PwUJnqXYEfo9PcUJIJuekLfnLWl4Fmd/uGMvXdzj
	 WJNOOAt7j0WLW9sfOvnl7L9jymujSKoIpHH+9H2I8JkNTLXr1Xo7Og8zTvWYiFqOl4
	 rdQhuOg8f/KzJH+DyRRFEkWX5VlcR5GonZoOv6S8tbwly62tLI2trySmmkZmka27BD
	 +yfNP7DCbDVsw==
Date: Thu, 17 Jul 2025 06:23:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 horms@kernel.org
Subject: Re: [PATCH net,v2 0/7] Netfilter fixes for net
Message-ID: <20250717062338.18ed7f69@kernel.org>
In-Reply-To: <aHj0QSJkzexEKE2T@strlen.de>
References: <20250717095808.41725-1-pablo@netfilter.org>
	<33ce1182-00fa-4255-b51c-d4dc927071bc@redhat.com>
	<aHj0QSJkzexEKE2T@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Jul 2025 15:01:53 +0200 Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
> > The first run of the newly introduced conntrack_clash.sh test failed on
> > nipa:
> > 
> > # timeout set to 1800
> > # selftests: net/netfilter: conntrack_clash.sh
> > # got 128 of 128 replies
> > # timed out while waiting for reply from thread
> > # got 127 of 128 replies
> > # FAIL: did not receive expected number of replies for 10.0.1.99:22111
> > # FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
> > # got 128 of 128 replies
> > # timed out while waiting for reply from thread
> > # got 0 of 128 replies
> > # FAIL: did not receive expected number of replies for 127.0.0.1:9001
> > # FAIL: clash resolution test for 127.0.0.1:9001 on attempt 2
> > # SKIP: Clash resolution did not trigger
> > not ok 1 selftests: net/netfilter: conntrack_clash.sh # exit=1
> > I think the above should not block the PR, but please have a look.  
> 
> No idea whats happening, I get 100/100 ok :-/
> 
> I'll send a revert or $ksft_skip for now if I can't figure it out.

Oh, I see this disembodied thread now, sorry.

No need to send the skip, we can ignore the case when ingesting results.
