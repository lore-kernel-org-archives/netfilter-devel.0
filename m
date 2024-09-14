Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10DE179BF;
	Sat, 14 Sep 2024 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726327317; cv=none; b=KoS5xIFGW9CPEu3+WXKdcR/7qwRxR6iUaF2K8EA5cM/JWaJfEjM/N/RSd4i4ijK99PWG03GYQlSKvvE2ri6BLUmKdg8gQxJZemxS9UkeCRytafCZSxNqbdLArJ5Uw9XR3uABzTycfjYwYWzVwFhJu8fZHDkQxOWQb07EFgh9hNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726327317; c=relaxed/simple;
	bh=vVbuT2PkbiZL2oGC7T+8Tw6ga9ngmRsKtudtTJXUgnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZxii28dCrJuJc5YgxUDSJTCap1iJZXVh3Q5AysvHAAIuhw26QHK1TAEpadGmNMNrTC/yk8Nu7Oga/IhAuDotFZpS/hSNvab+Vt0R7wAGffSWo5SvgwaDgWqGYeqtQDlFyqPpEbOWCOQEHNp+QIpdCBnCzPtXkTFCx8rWTM/K6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWaN+8jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWaN+8jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1531C4CEC0;
	Sat, 14 Sep 2024 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726327317;
	bh=vVbuT2PkbiZL2oGC7T+8Tw6ga9ngmRsKtudtTJXUgnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWaN+8jmxXZQmoGzbOiKHglQ47GMu2Z+l01o1N+NukiwUTayXJ5sd+Gi9TDL4yml/
	 HgzlD/r2qBF+9VXl5fL5/+PgrEqJqC8MbLzWbqzAHVReW2GzokoowdMcjiL+/f5jST
	 jBtxb45SWFvstOK1YLrQUBI5Ov7Tbm8suYJaiS8wEtKBbZkEfXpUPTYpABCl3ZBwf0
	 1v2s/ELNeaw+kELN5zq14BggtTGtnDMyDRocK4j0iKtehTGubfRGCZV9a9dRgbzTgH
	 eSVpQUpPWQMsUhjn4ObnZRr56q51vAgDZIMYPWGMv0lxaXi4LoPiOMmEeVw9slms7M
	 f8/EtKTLLt0AQ==
Date: Sat, 14 Sep 2024 16:21:52 +0100
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in
 nft_socket_cgroup_subtree_level()
Message-ID: <20240914152152.GB11774@kernel.org>
References: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
 <20240914111940.GA19902@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240914111940.GA19902@breakpoint.cc>

On Sat, Sep 14, 2024 at 01:19:40PM +0200, Florian Westphal wrote:
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > The cgroup_get_from_path() function never returns NULL, it returns error
> > pointers.  Update the error handling to match.
> 
> Good news, I will retire in the next few years so I don't send shit
> patches anymore.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Everyone makes mistakes, don't be too hard on yourself :)
