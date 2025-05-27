Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31001C3F02;
	Tue, 27 May 2025 14:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748354795; cv=none; b=Hggr+YD3/1ans5biIvq49kq0Q+UWb+inVotUUstD7H5WCUYB5r/FOBBVazuj554c5EURLViOd+IUMqapglMsRD29Aq0xlqxm/dv9kplXMrRvxNOVtg6easGmCA8rnZkfMZ54BbmlNhULiVlAzBTjN7opXBbqUxZsHBPt2/AGDs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748354795; c=relaxed/simple;
	bh=0CPhxCBqr0R1jopFokNxvkOO/Hjj43TvTu00bPqX0eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBHdyu8BqxIIC6ILKwNyyXpJTQeTTKy0pNwtCg0RkbFX+lh/2Xgj7zZeCQx0ZWKm8cMTT19g2Nuh9/BB6zv/bP0gsxuXbXXTSX2gzBUy1J7JII2oaf3+JCWFPrj07fT4SmhY/d3Z3Lsw3oDbxpWzbbI3mNiGn/yKRdRboTC6uyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfxHiG/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfxHiG/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECF6C4CEE9;
	Tue, 27 May 2025 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748354795;
	bh=0CPhxCBqr0R1jopFokNxvkOO/Hjj43TvTu00bPqX0eQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bfxHiG/AHQYySvV5uNEt3u3NuXoeY0MIWjv0s6VODXCLUrhMs9bxYBvDMlQDXhqOU
	 Hnk+49V/3GcrmAi7fUP+AggrifJqkkcmgRd7qyBk5S+tATudl1kohIv19mZgWmBxgW
	 pHjzR2N2eKL61FeCUIPY2HJEm4gk4xlckmo1VcMAA9Hqm+nZMXyCwiGyf4IWkUBg8Q
	 3zxKsMVQ3I2GMdwMGMH/5NqDwkTEukxymedso6RjwsXQEv70iLeVYryJj0IH0sP0Pg
	 AFN7k6aSfMUMM4TwQNTO9AuvFbcuO8ut8pLcydSD/5nsGqm1JDrSTnMPKGfMgjB6D0
	 lCNcVPOrOOw1A==
Date: Tue, 27 May 2025 07:06:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org, Phil
 Sutter <phil@nwl.cc>, davem@davemloft.net, netdev@vger.kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 26/26] selftests: netfilter: Torture nftables
 netdev hooks
Message-ID: <20250527070633.1c8da0ce@kernel.org>
In-Reply-To: <aDV6OA2G99L4Xvuk@calendula>
References: <20250523132712.458507-1-pablo@netfilter.org>
	<20250523132712.458507-27-pablo@netfilter.org>
	<12b16f0b-8ba8-4077-9a13-0bc514e1cd44@redhat.com>
	<aDV6OA2G99L4Xvuk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 May 2025 10:39:20 +0200 Pablo Neira Ayuso wrote:
> > # selftests: net/netfilter: nft_interface_stress.sh
> > # /dev/stdin:4:15-19: Error: syntax error, unexpected string with a
> > trailing asterisk, expecting string or quoted string or '$'
> > # devices = { wild* }
> > #             ^^^^^
> > not ok 1 selftests: net/netfilter: nft_interface_stress.sh # exit=1
> > 
> > For some reasons (likely PEBKAC here...) I did not catch that before
> > merging the PR, please try to follow-up soon. Thanks,  
> 
> This needs userspace updates in libnftnl and nftables.
> 
> I am looking at the best way to address this.
> 
> Q: is CI getting a fresh clone from netfilter git repositories?

We update the OS image manually, it doesn't seem to be needed often
enough to bother automating.
