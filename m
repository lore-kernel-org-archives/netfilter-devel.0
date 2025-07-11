Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE30021C186
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 16:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252001; cv=none; b=gik9i+Lw9KsxQLsaxCIRLysWXPER6Hi1KmAuTuIWjRIpV8Sg1VQZTOYjrH88fDKkSkAJwo67zfFAoyFB4Q9ZzJ6Kt9vDpndefLSFuPErK16lc4iAZQnzuCc8avuDPPXH1afHR/xsNp0yL8qsDKpwWqmg+TFVQ2A1Mh1eBgrufhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252001; c=relaxed/simple;
	bh=zE0NGmDduKh4wbTN/TPr0dgsfBP2HT4gIeEhGPf8tBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdI+RAwo45cV2K3KFLYDco3YBFXRCpO8dpH5Uec996ndxZ/G8TbyzhqPUtgfOKiBUEGNfJJ7A51yfMOEP99d934iguHk0m+JM7Qu4oqGkH+vzAz6dw+EZLRcSxyFchNK0On+p2/bVi7R4UErMRxfPjOhW0x1Bd+X55MgwgSD8Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=I5QtZVM7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="I5QtZVM7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KR9MReex/aRY6JpmCdckeFIYxH9zdXv+4m1YYGA7jlk=; b=I5QtZVM7VyHKPDp1KeuhRDfPKF
	zDNrZC7hoFMhUHw4LIIPFvJ+MI/GzmVBqipJ3UKMtIpOmyXsIid9EdSULTFz1s9MBnxrMRUgUuS4Z
	LsCDd4z8/aBJzL/z9oUpquuvD8UudYCn0XFIZQ3igrFuGSfHnQ9hiUXW+cXuhD1eb9X7E4YTEaG+A
	krZooSVhgvp435tAPHi4oGO5bzCYhnaPU4moh69FVnKZOgDryfGePaB5U1y6YrT6g860pri8Y6Tnf
	kRAhihf/tCJf69dqA6JGd/4Am4Xk3sI11GOUc+4SDG7v5wYc8dcOhVbECnww2ec7FRg268hnyhzYJ
	1VXqHKtQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uaGms-0000000019c-0wBE;
	Fri, 11 Jul 2025 18:39:50 +0200
Date: Fri, 11 Jul 2025 18:39:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHE-VmyBPBejy0GP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
 <aHElR53iOsae5qK3@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHElR53iOsae5qK3@calendula>

On Fri, Jul 11, 2025 at 04:52:55PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 11, 2025 at 02:19:04PM +0200, Phil Sutter wrote:
> > Pablo,
> > 
> > On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > If you accept this suggestion, it is a matter of:
> > > 
> > > #1 revert the patch in nf.git for the incomplete event notification
> > >    (you have three more patches pending for nf-next to complete this
> > >     for control plane notifications).
> > > #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> > 
> > Since Florian wondered whether I am wasting my time with a quick attempt
> > at #2, could you please confirm/deny whether this is a requirement for
> > the default to name-based interface hooks or does the 'list hooks'
> > extension satisfy the need for user space traceability?
> 
> For me, listing is just fine for debugging.
> 
> If there is a need to track hook updates via events, then
> nfnetlink_hook can be extended later.

OK, cool!

> So I am not asking for this, I thought you needed both listing and
> events, that is why I suggest to add events to nfnetlink_hook.

Just to be sure I wrote shell test case asserting correct device
reg/dereg using 'nft list hooks' tool, works just fine. So let's skip
notifications for now.

Thanks, Phil
