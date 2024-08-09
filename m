Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135CBA41;
	Fri,  9 Aug 2024 09:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723196390; cv=none; b=EqoyPX/WI9PKCfxWaUCMHZHMVyIi/oH5dWcpITNZBMavdI3LKCV2z5nwlFXnIQ5F1OOugmw/CcxmZAWiC2CUmtoW8VY61HsYs1nvk/I9oyJTF1RjqkkcXBsoI4ey/4+nPFh/OwO8lQiS2Q9KAorKy7noPBzxgFvFhA5Z7gdpR/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723196390; c=relaxed/simple;
	bh=PK7PvAZsXJ5cj6JCY6grw1kxewR519uv5Bc52JWIjkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qo01sbWMS+Ppysyj42U4P8TX+bjf01sDpL5SCmo0+boqEpT97Y6chkRAq3J6nWqs9+7Y65g8YhXrHbwkTjEhNVaSSJID1tRU2wJYsAwpbtQ2QNp0yhpxXhPuKhwf3x/QDoq6+PF0QEB4yhIvIyzd1QjzKSxEvmeCwii6/j9bZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsWUeUvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsWUeUvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF587C32782;
	Fri,  9 Aug 2024 09:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723196389;
	bh=PK7PvAZsXJ5cj6JCY6grw1kxewR519uv5Bc52JWIjkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dsWUeUvLd+Z6QdNDqnyI78xJ3V2bNRx3NIdYvPa66x4n3Zjsn9s2cVSDPZi4kECyI
	 8BH5ieiaWn0F11OyV3y15lZNPart4HG4VGmnGaqREB7ig5p0kVeChZMsNRIzmgnYNK
	 iAAgL+0EGB41tjza4PHj0ov56pG2obesIN6wkh5SrzhW6ryRVKXIKVssT71dGol1Bo
	 MbeoTtSwyu2n79ShzO7VUGJd+xHFWnD8fx585nw7thNtXX/A8vepYtOZtNV5Oqanpf
	 88VLS4YC9AdEmkh+XI4yOpV6+vHuv7kdpHXu+zmWrSCNmZ9LVmC0piaVKjqAhcEqC3
	 IkMtQ2UC/z8xw==
Date: Fri, 9 Aug 2024 10:39:45 +0100
From: Simon Horman <horms@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH nf v1] netfilter: flowtable: initialise extack before use
Message-ID: <20240809093945.GH3075665@kernel.org>
References: <20240806161637.42647-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806161637.42647-1-donald.hunter@gmail.com>

On Tue, Aug 06, 2024 at 05:16:37PM +0100, Donald Hunter wrote:
> Fix missing initialisation of extack in flow offload.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

Reviewed-by: Simon Horman <horms@kernel.org>

