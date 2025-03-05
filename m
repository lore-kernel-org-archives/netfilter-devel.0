Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554831DA53
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741208622; cv=none; b=GXlhzQEA30cTBUopXrrGKwnLiCER5XQO+F16fUI7P+RXpNEHiOjyVtroYnMk65SP6YEbzeJwWg5vqTRTM9FTnGG8aVTaJLUDAi9xHKTzUpo8m14HmaQIhh4Mh8UAeBirbK6wN1i6/1aWgPim9GTGlI2SYxGOAXcLqFKEPPS5fdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741208622; c=relaxed/simple;
	bh=wl6VqONx3qiynxVrMrvLoL8ENtWm+ALgDsVFSf+RRig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qV3Fyf7bCOFB/G7vRCDM/ei+0Uifz1vsQWzKz189whPuF2sA+Owuc5CefVHV/j/9WHdLFNqZkDu+S0JQeDNTt0yM2/G3W5Vua1qTOqVAiXBKEI8iP1gQPziul+nQHfRnr+FYXTmjq7b7ila+wEhlh8v+JRGuJi77VvhBFvO0ilM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W8yce8Fg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HwzTZuD6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W8yce8Fg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HwzTZuD6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3A64D602A2; Wed,  5 Mar 2025 22:03:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741208609;
	bh=0197NEsCUB5flz2zcTDl3TOh9hUyEqJcN+p+TbcKRH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8yce8FgLyL9pS+fhdFVY0Di1pvjSlszsGpcjrNhK0lr03l6qy/lDcmepS56BCP6T
	 D+uC8fGixcrG++2H8705E8wr/3VFR0rKom0AdmPlggMWPd/apWsHB5qeSSvG6rlASQ
	 Hz63DZDTthc+7YVveM3N4XYrihSNATPSheoMvrC+Eulqa7wNzhd/q/xPvdDzsoSpvT
	 T4hVaLRPYYWigGqCcoLtOnQxBClAvTlEjGmZDc+Jm08T0UfVblslHneyermAPeOO8i
	 HIf4oeXkPMLOXkBJtoHEZnUm/bPaWTOm9m3MiQPiscVak6DFKrrSdES73cM21RnWru
	 VESguJhPw2O2A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 914526027E;
	Wed,  5 Mar 2025 22:03:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741208608;
	bh=0197NEsCUB5flz2zcTDl3TOh9hUyEqJcN+p+TbcKRH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HwzTZuD6RBt8fTk8X307ALVdBIbZDj5IsOcilPaBO5DP5Qegj+w88xZhl15ARPXM1
	 l1KOOmZE2zBxJi1HyRBbBIBM4R4OLfryT/gLEJzlZ5taheWMLeTHp7tMDLAewmPZDp
	 dTSR+FLY11BR5B+Cz63F8oxtC0LF9SprR6reYuchgiRxdy8qhRw8HBQ1jcAjUYVOOo
	 s8RRnEj2znFRHayIBOYn97CpMmJxozwuhrwXQW/SQqeRWyEJiKhK9e9M/9M+s4EYU3
	 P+5MkVbLNlhc2zaL5lQXBPJ0KN5wL7b/AvoEYQ0VQuJtw7/MwVgL+VwoIoNLujnoJF
	 zfYLRPsFt+PKw==
Date: Wed, 5 Mar 2025 22:03:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/4] add mptcp suboption mnemonics
Message-ID: <Z8i8HoNQwtif911v@calendula>
References: <20250227145214.27730-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250227145214.27730-1-fw@strlen.de>

On Thu, Feb 27, 2025 at 03:52:06PM +0100, Florian Westphal wrote:
> Allow users to do
>   tcp option mptcp subtype mp-capable
> 
> instead of having to use the raw values described in rfc8684.
> 
> First patch adds this, rest of the patches resolve printing issues
> when the mptcp option match is used in sets and concatenations.

For this series.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
