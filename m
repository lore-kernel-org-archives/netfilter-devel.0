Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4416E893;
	Mon,  1 Jul 2024 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719870791; cv=none; b=dlVGNUWkjUa+ZW8+eyNnBCGjUNJ0yLVDQKmDImUJ9Hkgdhq/riD4YkyfTcC3BGmGBSUodcxl+PU900RS/qpOx9ToTAdRSrMcLXVYrgkxieSg2n72K0gd+JegqZn0uSiM6y9ke3t7taEmCNUq1U7SbHfiTbqpizyEzLoYa1DoTuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719870791; c=relaxed/simple;
	bh=0xRG/K2ne/2zW/PFU8qmwsk5KYrEt26kg1GOOqiu+i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCezQ3BDv+d2s5p8Gc6riexKcTprP8gEO4wWEiq5cAqsvNPk/PenL420aP/yOb4v4Qjhit4sqOh1Ra5GFEu6bnA0AiFSAFLP35bswc5JCOKn25YVntbFRrdUWTZArucOcC5weTtYKaNWM356usUhp0vid3kC06DTqyExImmDUE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.216.127] (port=3132 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sOOxL-00HQyz-AU; Mon, 01 Jul 2024 23:53:05 +0200
Date: Mon, 1 Jul 2024 23:52:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org, patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Thorsten Alteholz <squeeze-lts@alteholz.de>, jeremy@azazel.net
Subject: Re: [PATCH 4.19 164/213] netfilter: nft_set_rbtree: Switch to node
 list walk for overlap detection
Message-ID: <ZoMlOF3HVq3UP0aa@calendula>
References: <20240613113227.969123070@linuxfoundation.org>
 <20240613113234.312205246@linuxfoundation.org>
 <861740945d6a21d549d82249475b6b5a573bc9ed.camel@decadent.org.uk>
 <ZoMkPqf8AOpROvRd@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZoMkPqf8AOpROvRd@calendula>
X-Spam-Score: -1.9 (-)

On Mon, Jul 01, 2024 at 11:48:51PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 01, 2024 at 10:51:17PM +0200, Ben Hutchings wrote:
> > On Thu, 2024-06-13 at 13:33 +0200, Greg Kroah-Hartman wrote:
> > > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > commit c9e6978e2725a7d4b6cd23b2facd3f11422c0643 upstream.
> > [...]
> > 
> > This turns out to cause a regression for nftables user-space versions
> > older than v0.9.3, specifically before:
> > 
> > commit a4ec053812610400b7a9e6c060d8b7589dedd5b1
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Wed Oct 9 11:54:32 2019 +0200
> >  
> >     segtree: always close interval in non-anonymous sets
> 
> This is really fixing up userspace as the commit describes, otherwise
> incremental updates are not possible on a set/map.
> 
> > Should nft_set_rbtree detect and fix-up the bad set messages that
> > nftables user-space used to send?
> 
> Problem is that a non-anonymous set really needs close intervals,
> otherwise incremental updates on it are not possible.
> 
> It should be possible to backport a fix for such nftables version.
> 
> I can see Debian 10 (Buster, oldoldstable) is using 0.9.0 but it was
> discontinued in june 2022? But who is using such an old userspace version?

Oh, I misread, it is still supported in oldoldstable in Debian.

Then, userspace really needs this fix, because incremental updates on
a set are not really possible.

I can take a look and send a backport of this for nftables 0.9.0.
