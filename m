Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD78F3EFFC3;
	Mon, 31 Aug 2026 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788177897; cv=none; b=ZENtneFPwQ2l6ZUAeIMLBMWnGjVDsyHALbyKOLJy0SpDd3/LTdkHSFVu7ySx7WYWatiZwccbnQlIclZJVu06LTlZVkhdVrEesKnwaRclLjKqXn2AwaQGWsoI9qqUYN6IZC9Tlup19ukEtQFCaw5qqmjCP326YUU4K9C4uI4x1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788177897; c=relaxed/simple;
	bh=tIY7dQlb5Gk1CYhMKAlVMVje6PtTs02t2V3U72HYgPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxRmyQ78NLhg4W8SI2ZfzxCWza6VtCJ8raM4AL6fJcF/dmJgUIMya6+nLgs1/E3azW1JFFfTKaSS92V2iS7uwpFHpfRn9xbSarhAJU+vG0f7+rvzY+Oi2/qymzA1S+NC1OWow702DsrdCaG0JT/d9XdkSNbkBX8IwbZVxq2geiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fc2sPOJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fc2sPOJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07081F000E9;
	Mon, 31 Aug 2026 12:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788177896;
	bh=Bx49ICq7xa3C7JAp/BquHUAtLRu6OTUjCDKTPjc3Xco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fc2sPOJXSvSl7qA5GBl/IkLS1O054pQCMIj1OamgpFjEuqAzhSaKT2hsnmUm7xaV2
	 dYtPLmRa1XgHY+3STHmjYUGOVJFSmcnu+g7pAf3Vwm1ZyUtgJlHdeXdhb3fQE3ZXAL
	 sSt5xQPRfwkkajZf7E98fnf/mH8eqteE1+OVxp+I=
Date: Mon, 31 Aug 2026 14:04:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bin Lan <lanbincn@139.com>, XiaoHua Wang <561399680@139.com>
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: account mapping
 table allocation
Message-ID: <2026083125-bronze-stability-8fba@gregkh>
References: <20260831043755.29692-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831043755.29692-1-kmehltretter@gmail.com>

On Mon, Aug 31, 2026 at 06:37:55AM +0200, Karl Mehltretter wrote:
> [ Upstream commit 69e687cea79fc99a17dfb0116c8644b9391b915e ]
> 
> The pipapo set backend data structure is one of the ruleset objects
> that upstream changed to use GFP_KERNEL_ACCOUNT for memory accounting.
> 
> The 6.1.y and 6.6.y adaptations changed the other pipapo allocations,
> but omitted the mapping table allocation in pipapo_realloc_mt() because
> that helper does not exist in these branches.  The equivalent allocation
> is in pipapo_resize() and still uses GFP_KERNEL, so the persistent mapping
> table is not charged to the allocating memory cgroup.
> 
> Update this allocation to use GFP_KERNEL_ACCOUNT.
> 
> Fixes: a0bb39980635 ("netfilter: nf_tables: missing objects with no memcg accounting")
> Fixes: 1c4f72fa9699 ("netfilter: nf_tables: missing objects with no memcg accounting")
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

You lost the original authorship and signed-off-by :(

And it is very different from the original.

Also, why is this needed at all?
