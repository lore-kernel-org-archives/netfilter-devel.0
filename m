Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5875245DF4C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251432; cv=none; b=SWCUD8ES5mQlsq53yqNUVXChr5ubfeZYbM4GwDCYoalQu/mW9Dy7Zn5B243woLHo/v/UnRf1nv8ZEU1xFq0Qj1oYBPZjzmPLyg/BdNBrmfkFPD3oycEUZb3oPWrlnzVFx46s/F9T70/UBLzU994afl3I887/qcf1ZSkOXHGdHsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251432; c=relaxed/simple;
	bh=AB6ZoqHf37kum702HQU0DvuN9pOpQLGaAAb3QXDk9Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeYnIUFWkMIR8aSc9gQydFLIwE4w5xI+NxXDApBWKFSaisENcHSbwaA4G0FWbvfFglqwkTFSXqIhJ+gtQBkLDtNywgm802UKtqxbOmkT1rOoUd89AYlcl+FJG7i2RymR79lC3B4QdN8BoF2DTX151cEbG7r62+t50OpQC2ykAp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GxR26uep; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GxR26uep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iFGPe6T9mLp0Zc9KZ/RSHzJ22OoEMtsMExVzTGskic4=; b=GxR26uepPJ4IlcV4G2qraJQmmO
	zZp4ilB9GxhfscE3dvccnAjknMj2OVOtq7CIDIXT3WsAiC3YGTMmGDhGfdPK/3PQO+dZHer/EiInR
	jEqGnMmtw/nemcC4nYEM7pEiGti5DuEFE4FIVQ8POt2WV1HxRRbR9eAFHv5SpQ6VW+mjwj08FP2e6
	GrurEvvl7SvqhC8GKmkz8hdzWwXgDN18HeCqc3vlIGKi8Ud6jEGLzrreWHqiqaMMeFhAJAh9ZR5rQ
	SaMbRUaZGdPCcIhek/wGMN0cwUFLTd1gTvXuKOeSp/UG6R5Ox/LbcySHtfYe/0LCDI1nmMgrZCLjq
	SspelOqQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wojRq-000000000q7-2NiK;
	Tue, 28 Jul 2026 17:10:26 +0200
Date: Tue, 28 Jul 2026 17:10:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Cc: Eric Garver <eric@garver.life>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Fix for bison < 3.6
Message-ID: <amjGYmHKMiUf1UJE@orbyte.nwl.cc>
References: <20260611125231.652353-1-phil@nwl.cc>
 <amHoSglXwfNia7V7@orbyte.nwl.cc>
 <amdMsU0e0JDYYXkD@egarver-mac.redhat.corp>
 <2756315.9Mp67QZiUf@imladris>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2756315.9Mp67QZiUf@imladris>

Hi,

On Mon, Jul 27, 2026 at 03:02:02PM +0200, Jan Kończak wrote:
> I guess the right way is to add 'autoconf-archive' package to build
> dependencies - it ships the missing file. Hopefully adding this as
> a dependency won't be a big issue.
> 
> 
> On poniedziałek, 27 lipca 2026 14:18 Eric Garver wrote:
> > Hey Phil,
> > 
> > I see a configure failure after this change [1] on ubuntu-24.04.
> > 
> >   ./configure: line 5247: syntax error near unexpected token `3.6,'
> >   ./configure: line 5247: `			AX_PROG_BISON_VERSION(3.6,'
> >   Error: Process completed with exit code 2.
> > 
> > Does ax_prog_bison_version.m4 need to be added to the m4 directory?
> > 
> > Thanks.
> > E.
> > 
> > [1]:
> > https://github.com/firewalld/firewalld/actions/runs/30020547439/job/8996965
> > 4992

Sorry for the mess, I submitted a fix meanwhile:

https://lore.kernel.org/netfilter-devel/20260728101038.1213031-2-phil@nwl.cc/

Could you perhaps give this a quick test?

Thanks, Phil
