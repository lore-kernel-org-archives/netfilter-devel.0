Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E77D3C3C15
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798605; cv=none; b=VTActwgVsIIADLSwftxwO/NG7w+BZ/aLiYtzyGbHoOIbDZOdsmgXdxgOKSK5U2ydbsEc7+eiO//8/adV+a9w37C1PvnuP90Da0Fan+x+MUk5HPY+5JqKiOhhDHqmPDLsroKx+c/Dax2hzGJqTmLAvrd00VPFWY//L1bYL2uPwIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798605; c=relaxed/simple;
	bh=Ikh3dwvkKhx6JiT3yjt7MQwSXtc9mE4oyDfetDG4xvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUdSuOAK7IlKRiDNS4gmtMgHZA1K25igUY6dg7dDdPOZE+MGG6UBarWeJmEq/gshIkn360ji0Cw3OZfW1v1z9OC+BQKUFikkZ4Ny5UMPDujQe+nfOI5sPiVdIk2pZc4mkQepmtqfNKEU4X1r9oEO8Oj8zXYGzQ7dNsYxNpHQisA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o6RxxVE/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o6RxxVE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VYPhLd7kxbqgNamClVBWOV7gN2NRgCn/s3nteRhQGzA=; b=o6RxxVE/UAVNiWi93PpfmP8GJ2
	a3/QPyFuExzqhJxB2XMwTU/5aEihACDLmazDlj1UA/Sx8tbATSqhd94Te0XPSl/tRc3VZYp52QhhE
	412YQ5dwkTz0ZZUCA9Ka/KhKDS4Kyul83xhtdcFFDUI56q6z4ycLc3wDCX35atMecdIu4mF3h8pFz
	FJP1ne4Cv4eVf9cq59eWUrsSnlyfjnnWAV6vt3rzlBSxTmONcT/jtsQipS9Zl6vn/7kD0f6b9kEZu
	g7sKqyqGKY/8KfRLI+RLmdbr4XdLL9eZkgzyC9ooRtsOQyabdhKmDM53v/Ro7zys5tc8Th395OI5L
	wWVYc5WQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wmpe6-000000002v0-2a9l;
	Thu, 23 Jul 2026 11:23:14 +0200
Date: Thu, 23 Jul 2026 11:23:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] netlink: Call tunnel getters unconditionally
Message-ID: <amHdggcRQjBqk9zO@orbyte.nwl.cc>
References: <20260603192923.1378815-1-phil@nwl.cc>
 <20260603192923.1378815-7-phil@nwl.cc>
 <aj5oN3PT7_QusykI@chamomile>
 <akeHC8TJrsAJZwkG@orbyte.nwl.cc>
 <amD2ZqPDRpu0R4ia@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amD2ZqPDRpu0R4ia@chamomile>

On Wed, Jul 22, 2026 at 06:57:10PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 03, 2026 at 11:55:23AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Jun 26, 2026 at 01:53:27PM +0200, Pablo Neira Ayuso wrote:
> > > Series LGTM, only one nitpick, see below.
> > 
> > Thanks for your review!
> > 
> > [...]
> > > >  static struct expr *
> > > > -netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
> > > > +netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr, int alt_attr)
> > > 
> > > Maybe I would suggest:
> > > 
> > > netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int ipv4_attr, int ipv6_attr)
> > > 
> > > for easier reading.
> > 
> > Fine with me! I'll introduce 'int attr' auto-variable then, because the
> > code would otherwise conditionally do 'ipv4_attr = ipv6_attr' which is
> > more confusing than the original version.
> 
> Ok, thanks. Feel free to merge this series once you're done with it.

Fixed, rationale added to commit message and pushed after making sure
'make check' passes.

Thanks, Phil
