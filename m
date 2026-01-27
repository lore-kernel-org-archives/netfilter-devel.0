Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3C21B185
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769551453; cv=none; b=Uqlp7u1EAGxVOuBmp/2Fo/MkG+sf1zWYEC1587TLDnwO1fP2alfUFuT8v9X8o+29MjcxpeLbkZiVzLgvrVfqgjRkpsNzXu4EEvSiYFSjmsaMfAyjleD0nF6gpF018Vagznwj04OhgTO2DTrWCyaLWoLxJdVVAYBCccOLUOyaglc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769551453; c=relaxed/simple;
	bh=b6OLjBTTke+Uaee9ObUmmD9fYTmjbx7AX5NLZeItJLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAdm32aGV+4RrHX8IYnrykJT8Hqtj1cb/TpP8/G+TCk/i+egPxf5t0V3Fe6SDDuToqW83aEUW/uQP1XIAGQW0knKYLztWI+e4ULKt3qtxF8bqeDdX4H3XT6MaTqcCpBp5q+6eikOF2YbNMPCu082C7Aiy+j2omyqtlGI+Bl/Dbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O6npxGh3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O6npxGh3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N3c4Bwg5aRCgM9xH3l8YZGf28JZydAyBxkf/b/53vFw=; b=O6npxGh3TNDXbuS6K40LH/MafU
	3z1mG2hZ/gbos8b58unzYzV0wbmlku38AXMNjbcI1sIWi9rcr1bTZfobPOysC99qEKDbWu40Atrjq
	n0W8nZDgQNlLJw5HKinq4LNcRHdQrh3jCAyHcE/8En7AnJgWx8Z1Je1sJ7viJbSI0GbNVyRYVrXN0
	pO3Sx2jeenxJwlhfCxEg3M5a/nbDYhS0xeSIqLin2MIzq/t1Z2s3CUTqoMiTm7gVYpDPLtE92BnT4
	dVlp8/qNGoVCUEGJ+GoVpZKES0vDjMiXjiq25TlQOFbF1df+HDXpIbTV1IfGdcgc16iyZYKxtkyJL
	UMVLsIYg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrAO-000000002IW-0QyV;
	Tue, 27 Jan 2026 23:04:08 +0100
Date: Tue, 27 Jan 2026 23:04:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 0/9] Fix for debug output on Big Endian
Message-ID: <aXk2WCle6ES3iAIr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023160547.10928-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023160547.10928-1-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:05:38PM +0200, Phil Sutter wrote:
> This series aims at providing identical netlink debug output in nftables
> on Big and Little Endian systems. Particularly problematic are all data
> regs in host byte order, worsened by the potential for byte order swaps
> within a single data reg (concatenated set elements).
> 
> A bonus task is cropping data reg values to their actual size.
> Previously, every four-byte register containing data was printed which
> further reduces data expressiveness.
> 
> This series introduces data attribute setters for expressions and set
> elements which accept a byteorder value (plus an array of component
> sizes in the latter case) and changes the data reg printer to:
> 
> - Print only nftnl_data_reg::len bytes at max
> - Print data byte-by-byte, not four byte chunks as u32 values
>   interpreted in host byte order
> - Print data in reverse if in host byte order on Little Endian
> 
> If nftnl_data_reg::sizes array has non-zero fields, data is assumed to
> be concatenated and bits in nftnl_data_reg::byteorder signal host byte
> order in components. Each component is then printed as per the above
> rules and separated by a dot (".").
> 
> Patches 3-8 implement the above. Since debug output changes
> significantly, use the occasion to:
> - Print a colon (":") and flags value only if relevant (patch 1)
> - Fix for missing object name in objmap elements (patch 1)
> - Avoid ambiguity between data and flags value by prefixing with 'flags'
>   (patch 1)
> - Avoid trailing whitespace or space before tab (patch 2)
> 
> Finally, patch 8 tries to avoid userdata values in host byte order by
> storing u32 values in Big Endian. Since nftnl_udata_put_u32() is the
> only typed attribute setter (apart from the unproblematic strz one),
> this may be good enough for the purpose.
> 
> Phil Sutter (9):
>   set_elem: Review debug output
>   expr: data_reg: Avoid extra whitespace
>   expr: Pass byteorder to struct expr_ops::set callback
>   data_reg: Introduce struct nftnl_data_reg::byteorder field
>   data_reg: Introduce struct nftnl_data_reg::sizes array
>   Introduce nftnl_{expr,set_elem}_set_imm()
>   data_reg: Respect data byteorder when printing
>   data_reg: Support concatenated data
>   udata: Store u32 udata values in Big Endian

Series applied.
