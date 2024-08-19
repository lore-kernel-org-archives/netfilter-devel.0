Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F41E4964D
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724082898; cv=none; b=SiEafcBUMDMA/xkfq41WaEw2EHF0Sf3d/K3toqMfrXTXqYRTQNmes7Gi0jKmcrXmJHrMBo6pmEKU/UbqdvtNvWRo09hTGnDCuhRTiN/x680b+xWOHFAQ3O5j4fsNLDShc2509OB3dwTy6NFkWsGTAo8Ql8Jw1KsHJHDgsYODxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724082898; c=relaxed/simple;
	bh=4vxPPUCESqNFNzPWKkfKU84xQ2W/5ePeXYPpfP7eB88=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scz+wosX1ZpH84u5/0L08K/0qq4+ZfQ1L6N9ortzSWJuaNDBn8U+czLU/kwDqGbOtmwIeN9thPpbIwKgafVy5yTiqMjA3eC3S0IEdBJGbxFlS/mJMnRr62JfMCxwLCgVMd60w52/ZVkxsAMYBl/IZIl2DEe+xTNVJYY4DIvasdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39576 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg4iX-005WnL-Ck; Mon, 19 Aug 2024 17:54:51 +0200
Date: Mon, 19 Aug 2024 17:54:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <ZsNqyMw4t6Py1WBs@calendula>
References: <20240815113712.1266545-1-pablo@netfilter.org>
 <Zr4aCjGwkedu9ssB@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr4aCjGwkedu9ssB@egarver-mac>
X-Spam-Score: -1.9 (-)

On Thu, Aug 15, 2024 at 11:08:58AM -0400, Eric Garver wrote:
> On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > The following patchset relaxes cache requirements, this is based on the
> > observation that objects are fetched to report errors and provide hints.
> > 
> > This is a new attempt to speed up incremental updates following a
> > different approach, after reverting:
> > 
> >   e791dbe109b6 ("cache: recycle existing cache with incremental updates")
> > 
> > which is fragile because cache consistency checking needs more, it should
> > be still possible to explore in the future, but this seems a more simple
> > approach at this stage.
> > 
> > This is passing tests/shell and tests/py.
> > 
> > Pablo Neira Ayuso (5):
> >   cache: rule by index requires full cache
> >   cache: populate chains on demand from error path
> >   cache: populate objecs on demand from error path
> >   cache: populate flowtable on demand from error path
> >   cache: do not fetch set inconditionally on delete
> > 
> >  include/cache.h |  1 -
> >  src/cache.c     | 23 ++++++-----------------
> >  src/cmd.c       | 23 +++++++++++++++++++++++
> >  3 files changed, 29 insertions(+), 18 deletions(-)
> 
> I applied this series to nft master and tested it against the latest
> net-next and RHEL-9 kernels. No issues or regressions found.

Pushed out, thanks for testing.
