Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6E31F989
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279029; cv=none; b=fsH+aGlMjiiPEw/k5iI2VajX1nrMBpEri6pud94er45k2PCiAGtVexGehUYO9CLoMB2bgLe3X3HBX9PlKNwkaZJXs+Z+a/o/q4NzA1v2o9MdIfZqsSZwr5e9XGlEBlIU9WmOYWmFRGosnMFC4yJiNLlF92XMxEwUtMMMiTHZIN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279029; c=relaxed/simple;
	bh=RE0vqxirl5fEnIOL+vSBJsSmf0JSwbRLCsMkBSBT8Qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELFKHIihGpDETVszKGLKmzM84ForyG0ntQk3Br00NTdNMRFGxoy6oMx2bmzTqAEvSJAHahju/mXx3YFZO1wzInepAj4MhuYpIxqBH0CYjmxPAnLiv8UJEBTYCbPwlvmpzYRSoTefgEh+hpJuYd4/usTGxQnF6c/0biorkzZDdyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y6bMEb6S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y6bMEb6S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FGLOx7/cGzzGuzTPNmAbGFzvoh8MTQert+My3RsqOvM=; b=Y6bMEb6S+ucU7CU8O4w15E/E51
	77fqO6io0DTQGr12jvRYjeP+6JoQtZjJJIi/YJYPSqyWf+F6Adp2KHHWsJqLyihJk11lvfpzVeQHf
	H/U+86ysrogsrPrRpqNndKNdexoQeR7sOTuL/YFYFrmO/xbHYNY2uN5KN72X8d5N20vny4/8WN9Ds
	RUkC9y2Hs9TuPcDygrGXEvTp8Br47yJVd+4UjWrWrhCQ/zTQUkSn+riiW8vytUl3rVkxC3K5r4PLu
	v/aYssGiDWPM7U6QGtrkg7b6Eg8KDAoOt2zhVtPc+nDYnmatYqgumsgJPcBa0/TQ1pAjZseM+P8j3
	Ps/BKdsQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xE1V4-0000000024q-3eAM;
	Tue, 06 Oct 2026 11:30:18 +0200
Date: Tue, 6 Oct 2026 11:30:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] Fix for warnings when compiling for 32bit arch
Message-ID: <asS_quHWadVhbEel@orbyte.nwl.cc>
References: <20261002144547.2293527-1-phil@nwl.cc>
 <asK3PzqW4orq3BmH@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asK3PzqW4orq3BmH@chamomile>

On Sun, Oct 04, 2026 at 10:29:51PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 02, 2026 at 04:45:38PM +0200, Phil Sutter wrote:
> > This eliminates several, probably harmless warnings when e.g. compiling
> > with '-m32' for x86_64:
> > 
> > - Printing code assumes NFT_MAX_EXPR_LEN_BITS is unsigned long, when on
> >   32bit it is unsigned int - cast to uint32_t and print using '%d'.
> > 
> > - Pointers are unsigned long, casting to uint64_t yields a warning on
> >   32bit due to the different size
> > 
> > - Bison tokens of type 'val' are uint64_t, print their values using
> >   PRIu64 macro
> > 
> > - On 32bit, UINT32_MAX is of type unsigned int - cast to off_t when
> >   comparing against state->indesc->line_offset to avoid different
> >   signedness warning
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied.

