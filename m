Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB0319ABD5
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603078; cv=none; b=dqMZPm29I3UIsKxZYjGp6QKWjybg/RR16yBPVDE/pKFrX3gJbNFiNP1VcCjbpNYi2C4huFdJxoK5Dy9gxOw+xg+ZD3ihTIUTEjTh2rqno2Xtb7NSDzqQb6WyPQuTMB+qJSShgHmT+lfM9LJQp16+OdW7OBxUZDAU9D8lVkx4QpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603078; c=relaxed/simple;
	bh=Jh0+HmOCrepVMgjFJLBSI1k+D0rvQVLUmnaCH8mTOhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRNg7GOjYqTGAxuHeIrIR1pOeKDX4zn9HiX2YjPgP7iHGfoN7Rc6UQ72GXs7j0NNT4QuInWfnfMtqIBm/UfRf27iauJe2K+kaYuBNJtg/G0gZjSZAkpCzJXKxGnisGB0CZGPvKg8nDdKNBcPCJriXfRhiYwTdHYpfGxsGkp1TiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=URu+iFB7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="URu+iFB7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YZqCvmBBsEGSfHbS8ho/6hCgOd1KnqkurxmU2qoBx3I=; b=URu+iFB7ZA3VbGPM2DIlxJQdcL
	+OfJ+P8c5i4dWc8aNOL2hgBueLOtWECEQ8civbkwGijE91dfzj1VNqGfRegDFFs1frtMdl3NEhW2k
	LxqdGJhGiktbyXdTnNwqzDK9yVm7Q6R05U15bYlZNw6hYDk1P3d2aJZy13yRyECOT3UTFA4wrl7mF
	YQoiqKJi+6mwXKHyUgxWEOClu9lP+/VNWVf2jEm/oNTjimxCoJ2NUn2+TN2LNKujxZ2vV1jBBJVO4
	MckzbkZgRQPB41mp49mxFNMLouHHg5Lb45oR35weVdenMBTgaPaNt9JT4TAkex466PUOvyaO7xHkj
	V1HV3fAw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3Elm-000000007LV-2tiv;
	Tue, 22 Oct 2024 15:17:54 +0200
Date: Tue, 22 Oct 2024 15:17:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH] src/utils: Add a common dev_array parser
Message-ID: <ZxemApONbVWrFoQB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20241016164223.21280-1-phil@nwl.cc>
 <Zxejh_KRhd81uWSC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxejh_KRhd81uWSC@calendula>

On Tue, Oct 22, 2024 at 03:07:19PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 16, 2024 at 06:42:23PM +0200, Phil Sutter wrote:
> > Parsing of dev_array fields in flowtable and chain are identical, merge
> > them into a shared function nftnl_parse_devs() which does a quick scan
> > through the nested attributes to check validity and calculate required
> > array size instead of calling realloc() as needed.
> > 
> > This required to align structs nftnl_chain and nftnl_flowtable field
> > dev_array_len types, though uint32_t should match the size of int on
> > both 32 and 64 bit architectures.
> 
> Maybe go the extra mile and add an internal object for string arrays:
> 
> struct nftnl_str_array {
>         const char      **array;
>         uint32_t        len;
> };
> 
> and use it in chain and flowtable?

ACK, will do.

Thanks, Phil
