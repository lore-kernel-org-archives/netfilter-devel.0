Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D163812C478
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728768402; cv=none; b=JWxkgudLKs5J27tVZmdCUj8OG+nLo1hCNui7NZOQOfFGkjxejObUQMHRzR/V/uThaDA+1kPsBTqGlUhRVlpDnT2AbZnb5xmmAP2tpY46xQDvorWXqYjdJeO1757YNvPym87aBXsV1C/ymMd4/gemOn4P4ruWvI4G1IIiRCrPUik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728768402; c=relaxed/simple;
	bh=KBrTdw51ucNLvrnEbzhAd2Mq21K5dZtUQJlGUDL2rzQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rM1ATr3ud1i1pS7riB+C+lNjeNlemhgyVTz/wVc2967Ko0pFrclK0KRhVD349P8JITYEi6mYzSt1WRx+AMUYgxUuWyexu62n48imLuA+zQtpCHgmnD456ONHjfIdfwbyIsOmg3wMp2T//r0YglxWv4cOZkLD/AluTQ2I9TgyNyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34792 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szjdC-0024VO-1R; Sat, 12 Oct 2024 23:26:36 +0200
Date: Sat, 12 Oct 2024 23:26:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwrpiAv1PHEp1rwY@calendula>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwrT3JOmxLigw9gC@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZwrT3JOmxLigw9gC@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Sat, Oct 12, 2024 at 09:54:04PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> > Make it option, after this update it is still possible to build the
> > documentation on demand via:
> > 
> >  cd doxygen
> >  make
> 
> This is rather unelegant in an autotools-project. You probably did
> consider setting 'with_doxygen=no' in configure.ac line 48, why did you
> choose this way?

--with-doxygen=no would do try trick, yes.
