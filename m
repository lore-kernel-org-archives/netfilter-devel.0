Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF21727A128;
	Tue, 20 May 2025 11:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739344; cv=none; b=DTDCf/WOOtSOvcS+0tcQvfmfgzFxdlvFRnBkEpmRRn5mp6d7OEkbaic5ZC1X0HRemWTRcSJTJGS71VsnBNKFN5TFNFbB9zRviEwyKV+lD9fXZDCY3WnqgeZ97gGmfUE7w9qNuKhHlxjQDbKgnLYNaLkRIxzJo9sxS5z27Uhrn38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739344; c=relaxed/simple;
	bh=wUBAPcM3h4h9sfAm09rqg5/mI3M5u/QWh9zdXEUH5So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3WFuuACWgS1jDJ7l2t2ZLKm8VSg7jVa3LQvITEbJb2Aia++5ppnNkCec3gr4HJKfbtZclRuEZRkKuNVF68wZpz16f6JsfWwuVJ+LnvjzB4wVCoE9UZuLeLqqK5LpDvd0+nmUqHil2p/geFws4fFaiM00GAfsgEnZLXYcCUagsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiAr+J3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiAr+J3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973CEC4CEE9;
	Tue, 20 May 2025 11:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747739344;
	bh=wUBAPcM3h4h9sfAm09rqg5/mI3M5u/QWh9zdXEUH5So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EiAr+J3+btA797hPhIByNLI2XSDgV8RczHGGS+rcgiDElj5vTmSX99zi/+q1D5t0q
	 ABl5TUxW3uqj7IqnyXfWWZgbF/mYYVxJRt2ZR7C6mSh8MrO4FCjY3RUpcQvLp1rRNQ
	 QxYYiOTvOJO0YqyUJ/CLuuIkX/d5V0DMkM4bFToE=
Date: Tue, 20 May 2025 13:09:01 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.1 0/3] Netfilter fixes for -stable
Message-ID: <2025052052-wistful-cork-c09f@gregkh>
References: <20250519233438.22640-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519233438.22640-1-pablo@netfilter.org>

On Tue, May 20, 2025 at 01:34:35AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains backported fixes for 6.1 -stable.
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) 8965d42bcf54 ("netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx")
> 
>    This is a stable dependency for the next patch.
> 
> 2) c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
> 
> 3) b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
> 
>    This is a fix-for-fix for patch 2.
> 
> These three patches are required to fix the netdevice release path for
> netdev family basechains.
> 

All now queued up, thanks!

greg k-h
