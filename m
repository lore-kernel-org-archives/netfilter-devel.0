Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36C32192E3
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236351; cv=none; b=IQHflIo8BbVAxOHQvi0GhK/xOwKMv0zE3yAdxCOq0QCPwMhBm1Vtpt9CIWWzePD9+Of6ykcIms+J1lVo9auYOIHwtzWo+2KvGRV69cqiQ2mppZQfFC7tP0JdlUSIWMAdKxaTMZhWzNqrkVM1WDmw+mcaEvoXuFQH6oPzCGh1+mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236351; c=relaxed/simple;
	bh=szpW2Mm0jDBS6HcUOjL/jqsLe9sBKPNBZYxd65VV2sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU9XshrgbPOusoJ6VdJ4p+S3uAhA0UrflIjZKj3GQohoPXDIRuRZGookT6X+5as3aaBCU7FQ94txBv1FuK8uYIuWkCPm3QSpg45VZp3HpwKWV3ZB5EiR8BIyFptu/UdUNOfqPZY+AWELFSdZ6dgxXuzKrmOauTXHD89CuE57mDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kDFsjU1E; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kDFsjU1E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sybZ++CT5tA1qaeHWj/5CR+wMi1KmRRrMqYxzq9TUKk=; b=kDFsjU1EBZPgfOL5atDQBPW6zF
	1cC2bWdzQpsrLynzKdJ/+MXtNudGM092w/xQYT3vvwhuPJ5t2qJlEdLJCIm8StWtxGdNTGrgSBgGQ
	iLx4e5FwenLP51tsSTO5UyfrjuQFTFNXI7V/dPgms7cDoFaLMzmw+0/Ymu3TNMYKud87eibTR3TnH
	xb97qv9Uvevbi3j2KS3xwcMQXUuU0i8wD8Ontfh8iC7guAetdTZ5oBeB04ssUnr14xcvPXCQ8A43A
	5nfb88vWbbjbjBSAaSA3P/7TTyxS6ZBw+Dk0SHqIfUfrh65u2lYCnx+Cp5rplTv3nvgODRosFoSHe
	j0/APs/Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uaCiW-0000000026O-1hJI;
	Fri, 11 Jul 2025 14:19:04 +0200
Date: Fri, 11 Jul 2025 14:19:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG7wd6ALR7kXb1fl@calendula>

Pablo,

On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
[...]
> If you accept this suggestion, it is a matter of:
> 
> #1 revert the patch in nf.git for the incomplete event notification
>    (you have three more patches pending for nf-next to complete this
>     for control plane notifications).
> #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.

Since Florian wondered whether I am wasting my time with a quick attempt
at #2, could you please confirm/deny whether this is a requirement for
the default to name-based interface hooks or does the 'list hooks'
extension satisfy the need for user space traceability?

Thanks, Phil
