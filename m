Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD32185A8
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755553274; cv=none; b=jjYlAucDShZngkzng6zx4h5B0kO3osbqXJUMOYp44DS5IlseAZhMHnfN5KhtgCKNbqpGhqCO+nKADf8v3eoHDBSg0Fc3UGMqqbJGwyMgstlEkuLYkqDdVgUSe+MEmxNdyhwvhjLasHCpydKoe8LC30fbpvP04cOKhBnB/10c+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755553274; c=relaxed/simple;
	bh=do7/r72+9PVdPlWr0C0irtg8mvCsSRygZPbaPnpglNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phnR+QLz+7BXtWb/S3VRxeMNDI9ZvVaJL7kTgTCcsFYzKdRwEETRgYV2/UBo37tcjxOm6CtD0S3bOTQjXeIErOfswWyaYzIX8DLCb+sh3gYLCLNS4onxIUfDOUtphSBV2zWUK+fcpjLrzLW/RwupoPv0ldkYfbMkTlmTjD8giPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2F31960242; Mon, 18 Aug 2025 23:41:09 +0200 (CEST)
Date: Mon, 18 Aug 2025 23:41:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: use avx2
 algorithm for insertions too
Message-ID: <aKOd9GYEljvmWcUU@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
 <20250815143702.17272-3-fw@strlen.de>
 <20250818183227.28dfa525@elisabeth>
 <aKNv_lcbE6kMtqws@strlen.de>
 <20250818205605.3cf49465@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818205605.3cf49465@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> I think that would just make it... hidden. I'd rather leave it like it
> is.
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Thanks.  For the record, I did fix up the various typos in the
comments meanwhile, I'll retain your reviewed-by tag as i did
not make code changes.
