Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE11D61A3;
	Mon, 13 Apr 2026 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776081572; cv=none; b=LiuyrAJKBM+5ltNFnnEzpMy0HN2uA/oUfqWRGMWMP2fRvm9tx6p+Os6HWpSXj9IXzBQRaNsuMnl4e1lVkaygqbtfVENOOkhujWjH6pQiBL2MP1Rn1WKYPqwD+XJpVx3O8jPWWK4UOMf6E8+ZjGnWF93s1as62eVLF0xXd6p6mto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776081572; c=relaxed/simple;
	bh=aEyJLS5pKAqzyDFhV+V2dHBfpEyLJ6FcOXc82hX/FQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUY65p1Kw/+6HR1Z+6J70KVJuty0yNEeT0xCGC4pqiAGrdfOnPLXhi2qbkqzt9/dSylWw0JKEtDD/5EISc4goLcED/ML6SBR48PVWcNxRYZYqI3HNgplkAZYATtV5uKwOyqETLIb9VMYhKYHOltup0b4kYZzi7uhHBkzEe7jK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iM2Szv72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iM2Szv72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91CFC116C6;
	Mon, 13 Apr 2026 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776081572;
	bh=aEyJLS5pKAqzyDFhV+V2dHBfpEyLJ6FcOXc82hX/FQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iM2Szv72NalA6zpSUcBznN1T4oT4GCmcQw+3HTaCf3IMqa6UhwoVzToKaeptjhDz+
	 +TDVDH4GATyF5axrwqaP1tRDdSL1mHsIznElmGuLQ42nJ/5rdLea4dtKpN71RAa720
	 7qu2eLqTMuNfnl3j/sq5QrzQCRHPEpiJ0sFImtWw=
Date: Mon, 13 Apr 2026 13:59:29 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Cc: stable@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com, yin.ding@broadcom.com,
	tapas.kundu@broadcom.com, Stefano Brivio <sbrivio@redhat.com>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: Re: [PATCH v5.15-v6.1] netfilter: nft_set_pipapo: do not rely on
 ZERO_SIZE_PTR
Message-ID: <2026041319-spur-purse-2433@gregkh>
References: <20260413043247.3327855-1-keerthana.kalyanasundaram@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413043247.3327855-1-keerthana.kalyanasundaram@broadcom.com>

On Mon, Apr 13, 2026 at 04:32:47AM +0000, Keerthana K wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit 07ace0bbe03b3d8e85869af1dec5e4087b1d57b8 upstream
> 
> pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
> but pointer is invalid).
> 
> Rework this to not call slab allocator when we'd request a 0-byte
> allocation.
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Mukul Sikka <mukul.sikka@broadcom.com>
> Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
> [Keerthana: In older stable branches (v6.6 and earlier), the allocation logic in
> pipapo_clone() still relies on `src->rules` rather than `src->rules_alloc`
> (introduced in v6.9 via 9f439bd6ef4f). Consequently, the previously
> backported INT_MAX clamping check uses `src->rules`. This patch correctly
> moves that `src->rules > (INT_MAX / ...)` check inside the new
> `if (src->rules > 0)` block]
> Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
> ---
>  net/netfilter/nft_set_pipapo.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

Does not apply to 5.15.y :(
