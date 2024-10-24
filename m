Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EF41CBE91;
	Thu, 24 Oct 2024 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762640; cv=none; b=BI/zWDTfrjrRDVBwHWRWg+5Rc4oT/fohpgW2PjIVfVq0fBsMXqYPDNqXqa3tJy+jeEim1u9PbTEhlMbqpWOiFHpCNFRUCh6lGBElyjb85krxfrYE85mr8rBgcklnGkgRenFVfk70fvSNfUWdusqhhPdy1lfBB+IrhlMpTk+WTVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762640; c=relaxed/simple;
	bh=7q5cze3Bj0cHVtRyxcwQfGbsZrOBofAuoclFOmnUXLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwyvZ7kfYSkzfser841G1dnMlfxiymonqQz2mvOP8NMxq84X1ZZ7VYs4L0Cd8wZVi7tMPxAj2udupzcMNEkSEGZfRTZ7FFE1nFnL4hQ7tkeqeeLbGvUrWvDYOPw/fjCLzM+bEeL/XzhtiVwV0O3Xe2snQdgvWl28WxZbA1W4+bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCsvb9M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCsvb9M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBABC4CEC7;
	Thu, 24 Oct 2024 09:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729762640;
	bh=7q5cze3Bj0cHVtRyxcwQfGbsZrOBofAuoclFOmnUXLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RCsvb9M0UNs/cqbkELlQtgBLP/ZC7jIVjsNqjClMocMYLV1vHlV5bSLS9rmfvkOEK
	 14kM64MiWhk6h+iRx5eCBVAyON1XseK/w310GFfOnSShf2zlmBumNen8j/veiFguoX
	 TWcSoSngaNIvYRB0in00QuKu/H1DPfXSoYIzAogcPNBVyJXrAb6kwQ3QdOChZ3x2pL
	 5KzMJfhO8+jSajq7WytRhcJyg/3rBZeR/ZG4UXAxQTdFEmetvMP/jK2SQvj7GO2qk1
	 i7BJ0aNqdACBeyELaEzJ5dZR2FUqYQWQ3M9UpWjWef15rp4WTtB0kmFleKqZA9Z5un
	 W/EpbpokfsOJw==
Date: Thu, 24 Oct 2024 10:37:16 +0100
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] selftests: netfilter: nft_flowtable.sh: make first
 pass deterministic
Message-ID: <20241024093716.GK402847@kernel.org>
References: <20241022152324.13554-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022152324.13554-1-fw@strlen.de>

On Tue, Oct 22, 2024 at 05:23:18PM +0200, Florian Westphal wrote:
> The CI occasionaly encounters a failing test run.  Example:
>  # PASS: ipsec tunnel mode for ns1/ns2
>  # re-run with random mtus: -o 10966 -l 19499 -r 31322
>  # PASS: flow offloaded for ns1/ns2
> [..]
>  # FAIL: ipsec tunnel ... counter 1157059 exceeds expected value 878489
> 
> This script will re-exec itself, on the second run, random MTUs are
> chosen for the involved links.  This is done so we can cover different
> combinations (large mtu on client, small on server, link has lowest
> mtu, etc).
> 
> Furthermore, file size is random, even for the first run.
> 
> Rework this script and always use the same file size on initial run so
> that at least the first round can be expected to have reproducible
> behavior.
> 
> Second round will use random mtu/filesize.
> 
> Raise the failure limit to that of the file size, this should avoid all
> errneous test errors.  Currently, first fin will remove the offload, so if
> one peer is already closing remaining data is handled by classic path,
> which result in larger-than-expected counter and a test failure.
> 
> Given packet path also counts tcp/ip headers, in case offload is
> completely broken this test will still fail (as expected).
> 
> The test counter limit could be made more strict again in the future
> once flowtable can keep a connection in offloaded state until FINs
> in both directions were seen.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  If you prefer you can also apply this to net-next instead.

Hi Florian,

No preference on my side.
But if it is for net, then we'll need a fixes tag.
Which you can simply add by responding with it to this email.
(I think it has to start at the beginning of the line.)

In any case,

Reviewed-by: Simon Horman <horms@kernel.org>

...
