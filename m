Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FA79C7;
	Thu, 25 Jan 2024 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706204050; cv=none; b=kW/dY2jPbEDwZYylYLiO9ioL1jAFxOfGIbWGAvr2P4jGWehr/RXQ9Ox0gAiITZohpYV/hNe63V7ka3dOmNfWEDgsw8LefRUmW5/HLu4Uf7l7Ranz/PdR4OPZch4EANoCG7MdUtd3kgayMwsmiNvb4tSSa88xc0x9fatMzLjhLjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706204050; c=relaxed/simple;
	bh=flQDoBICzx4xLkb8iZUYGlijqQR95FEGMh21Q5BpQqY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFZEY15nCbmvqe+10DCn2uNP2SN8jJOm6VUa9x/JWXQ4hKS/ktKaxsVmTet411NbTfYf3bAbwTTHXXLh2gEjZXLYzVUBS4H0Z3NNZl/DwbW3RB50hSOT/yQIFoZElHCiEMwSZEpLvMT8JuoqEm/ZX0zvr8zieYP7LRMCFbsfmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqslmzuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqslmzuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDAAC433F1;
	Thu, 25 Jan 2024 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706204050;
	bh=flQDoBICzx4xLkb8iZUYGlijqQR95FEGMh21Q5BpQqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SqslmzuJaY7dnxixUN/BpMTjyBtTdD5a4Rs6eKUZVOLigk2uv4Utl81FwQk6h7BEf
	 BlsBAGlBJM3orsxrEYrSzG1SOFalHdZ/rkKN8BawTlDERTe+97E2qJTcT8mPN3XFaY
	 HPLTV/KF4/wmHOkuQ+hhdfG9SrG0svBPtWCLEUOK0cnf96TcFRw88/MU2Ut4rl1S+X
	 gdnUV1+QqRxiO38ykosp5Yq+KKcrLO0AGEIDiijQ+3ncx5fZS6TpXgiQ6DE8ogwzOd
	 /aCilOZmGXhQFB2hgQ7ih42yqiYVVsA2VUtCOnor+kOOV6xPUakYVBYIcP5SgxJbzW
	 qfHNJOjdpkNoQ==
Date: Thu, 25 Jan 2024 09:34:08 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Ahern
 <dsahern@kernel.org>, coreteam@netfilter.org,
 "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, Hangbin Liu
 <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240125093408.793d8121@kernel.org>
In-Reply-To: <ZbIqBU9I009KVqZT@calendula>
References: <20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<ZbFiF2HzyWHAyH00@calendula>
	<20240124114057.1ca95198@kernel.org>
	<ZbFsyEfMRt8S+ef1@calendula>
	<20240124121343.6ce76eff@kernel.org>
	<20240124210724.2b0e08ff@kernel.org>
	<ZbIqBU9I009KVqZT@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 10:29:41 +0100 Pablo Neira Ayuso wrote:
> > NFT_COMPAT fixed a lot! One remaining warning comes from using 
> > -m length. Which NFT config do we need for that one?  
> 
> May I have a look at the logs? How does the error look like?

With the config pointed out by Florian in addition to NFT_COMPAT
all the iptables errors in the logs are gone, without switching
to legacy. Thank you for the help!

Also LMK if you guys want us to try running netfilter tests.
I'm guessing we're unlikely to regress anything in net-next,
and you have running netfilter tests covered - but if it's 
not too hard we can try to hook them up to net-next, too!
(Or you can run them on our branch and report back :))
