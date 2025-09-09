Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C31D5160
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 22:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757458137; cv=none; b=IxgG8aWPymtW/Q0V9/cR6RzICRfyIdcafGxzilcEPDQP92N7IwF/iHGwZEn04JCr7fdjacVCHCcQY0FjC2I6v0IyAjCPfoD0sYXwRjvjAAXNA6GR/ylIQf73fMEXPAFEbNZ/Holn0U5g3JaaVFjD/OGmepxvwt7y5sJoV96BEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757458137; c=relaxed/simple;
	bh=7HsyNxiuLQJ0oFfSK/S/mGa/9C1xYtrie2t16Al4JPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YANacpQGbGpLSg+gmmIV1zuI+VmzcQttByOOLCaMfq6uRoOokzeIHobDbI7ymGhCUs1gmuf94a6uGLOeUbSwjwmOktSuJCQDo7emUVPfq05b26NPaXU5Ch0+ahrYeRqa5i2QwUVFm+9A/CIaKmwPT/pwMzFXZzQ2u1ohShAlvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PbvSiHMp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PbvSiHMp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=th5aovtSip3Dy4vcJdAFdxCNVjJRvQ5sAoEcBI/Npxg=; b=PbvSiHMpwOUiU6kHthdp1RpAsb
	SAHRP5r28sX+etAtz0awynS4cB/0cCYog4BB8VwJ5sPUn9g2wOfaLXaEAq61mWRp0g+B1FP7dQe89
	Njr+pZAHHMl1qL1WB7CiRc+CaMmue9IqisFksa+vTke+W86N6EIEcvY6ZrOTsgRIjqkfGasK7P1O6
	ainabeJzRa5vRO87FztfcuHs5dOVp2N6nQX8mru4IqFWDmAGQfCu7ifCwoMsIuh8DEwSjYh390/NE
	aiB8inoTBguDcabtLFswgQWcXlURkapCdECEgYAlRY/F5jlUVq5bdOKpRTPP53+SjT44T95h37eoY
	M+OH/FJw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uw78o-0000000009D-2Fkr;
	Wed, 10 Sep 2025 00:48:46 +0200
Date: Wed, 10 Sep 2025 00:48:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] fib: Fix for existence check on Big Endian
Message-ID: <aMCuzr9SaA--RG3f@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
References: <20250909204948.17757-1-phil@nwl.cc>
 <aMCdSDWhxCJM_kjY@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMCdSDWhxCJM_kjY@calendula>

Hi Pablo,

On Tue, Sep 09, 2025 at 11:34:00PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 09, 2025 at 10:49:48PM +0200, Phil Sutter wrote:
> > Adjust the expression size to 1B so cmp expression value is correct.
> > Without this, the rule 'fib saddr . iif check exists' generates
> > following byte code on BE:
> > 
> > |  [ fib saddr . iif oif present => reg 1 ]
> > |  [ cmp eq reg 1 0x00000001 ]
> > 
> > Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
> > byte of reg 1 only (using nft_reg_store8()). With this patch in place,
> > byte code is correct:
> > 
> > |  [ fib saddr . iif oif present => reg 1 ]
> > |  [ cmp eq reg 1 0x01000000 ]
> 
> Is this a generic issue of boolean that is using 1 bit?
> 
> const struct datatype boolean_type = {
>         .type           = TYPE_BOOLEAN,
>         .name           = "boolean",
>         .desc           = "boolean type",
>         .size           = 1,

Maybe, yes: I compared fib existence checks to exthdr ones in order to
find the bug. With exthdr, we know in parser already that it is an
existence check (see exthdr_exists_expr rule in parser_bison.y). If so,
exthdr expression is allocated with type 1 which is (assumed to be) the
NEXTHDR field in all extension headers. This field has
inet_protocol_type, which is size 8b.

Via expr_ctx::len, RHS will then be adjusted to 8b size (see 'expr->len =
masklen' in expr_evaluate_integer()).

IIRC, LHS defines the RHS size in relationals. I am not sure if we may
sanely reverse this rule if RHS is a boolean_type.

Cheers, Phil
