Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F22F066B
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756473691; cv=none; b=shdqWIDwP0QYBuCs9CJVpKCo6rAqntk9SHaEfBtfbF4AQ4uaYolEaC0JPN7Zu3ZJWi+cPsSNphwyKa/N744W+zBA4gHM8it9NVuPqTlEW60P5gL/8LZFDtTbGClZh9LyqQ/H1az2ttRGogrTFsPtoEnmXYBRxFs9+OVOXqHNd3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756473691; c=relaxed/simple;
	bh=TxyOIq7mlKokSeQvDnu6Emks6CALUHqZsEY2FZ6hDh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0+epxW0OcX0XTClsOWjogvEdEgkOmlg69NbYFxBBqqmN6KruCb/NYi+xuAMvPOt6fUvqBksVHdtzLY2+9aSvWu4RhQpYHi/IztA/q6eXA+6Fn0tX175CalKW1wvfrHxAy1dTg4YPj2onpWj/ncD8+Juh76Dg6y8KhHOkFkntqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z+OUwyRh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z+OUwyRh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZmUiheA05bggaSIwJir36jM3xd7ho0zVHwEPuER0z74=; b=Z+OUwyRhE/Sd7wbcYYx30BE9cz
	vA0VvnXBU/9tL+lVe92cMjUt8v4Zav/Ew1x2ytl0X4JLVuaZ8IgFoeyjBhIZDhvqvXARmcXV+i23R
	sgZfY/UxTUp1faGrf6pH4Cwj0SvwMe1eOAyuExkG7WJsJlPmalg6M0cKCmaz6byfkdOp3w82OqwAE
	nxAk+5r65uNZxV/g/SpqRcmZYcSfrqBhMAW+Xu7hSVrN8lArJ4ZJKB3fMkxJlp0aiwse7d7918nRx
	vAG/iZ3o/IBPu3uca/Y0yYFCK9aEb47OI1ozwp2jo3ePoInMxcwTyifb26lXWsHjQyo2ZS72AfXp2
	Go2DHzDg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urz2U-000000000q0-0SGh;
	Fri, 29 Aug 2025 15:21:10 +0200
Date: Fri, 29 Aug 2025 15:21:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Remove unused htable_bits in macro
 ahash_region
Message-ID: <aLGpRloVpz6SnMvB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Zhen Ni <zhen.ni@easystack.cn>,
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org
References: <20250829083621.1630638-1-zhen.ni@easystack.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829083621.1630638-1-zhen.ni@easystack.cn>

On Fri, Aug 29, 2025 at 04:36:21PM +0800, Zhen Ni wrote:
> Since the ahash_region() macro was redefined to calculate the region
> index solely from HTABLE_REGION_BITS, the htable_bits parameter became
> unused.
> 
> Remove the unused htable_bits argument and its call sites, simplifying
> the code without changing semantics.
> 
> Fixes: 8478a729c046 ("netfilter: ipset: fix region locking in hash types")
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Reviewed-by: Phil Sutter <phil@nwl.cc>
