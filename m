Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC514A60C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732053821; cv=none; b=cjApQtjTQU9pi9NdVYHEQpfVmr4vJsMkHdQSymUUG2ampgOL1+UrMUF3T1elUE2VFoBYZBM+0vOcd7Z7j+TVIzmYTZVnHfcE3HQDQp4mkY6yKiWNhqUYNeApTWVIQJQoPlAoF0Mb/KHTTlZG48WTXqA+XoArHWMagsjiRSrwokQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732053821; c=relaxed/simple;
	bh=M3ZzGYfKaRa8Ct+FhZXSmIP8nN4biqE0/3ae+VWPsRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcMejMqzHi4klaSjUSxxeC6kOmjM+gcifBX9oi5EEzKRRSIjw+9grirm52Qv0Ge66rl1TN96LrqJ+EiXVlSb9wWmDYhRmoroT5L3uXGoCdsdO5VXbCthLRgDDId4WhJuonVrbbQPRSngG1T3ohNnwWLJmu3nmnZy2mi2IVNusNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KqZAjfMP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KqZAjfMP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qHEp6rxGo8E2zlBFJ+wNZNSb13Mlhh6W30/rEptzPLo=; b=KqZAjfMP7wgVBxvOqi37JRuQMc
	7ComEMUOSCeXG822yDmpZU+RMVK0CqQfEmNS0ZjOyeA7Kt07FdBK8CRK5fPfn0ADevBfec9v0p4UZ
	xorhvyTwjncIQfLoTx8+Hk7Lq+fKO/QluKNCID79ODEkFVsteRWIMJMUEjhi/z1q6Zs++w2IeUU85
	Tr5xwh3oVXb/RX8q5X1RfljMDxKLDidG7GuUeQMNk/qF+1OnHbCh7fWyhSF2HqrXu9yzUkJ9iDnjQ
	HLZvgPFMTMTqdgXRHvMIruyBtPhIDogighwwxHZmy3+7LCKZwYjb23uTZ52zF9CcdFG3MQrCTolXu
	d0zN///Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDWJt-000000001Dz-0BeR;
	Tue, 19 Nov 2024 23:03:37 +0100
Date: Tue, 19 Nov 2024 23:03:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Eric Garver <eric@garver.life>
Subject: Re: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Message-ID: <Zz0LOMLVD7hVEiBs@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Eric Garver <eric@garver.life>
References: <20241118135650.510715-1-jeremy@azazel.net>
 <ZzyQn9E0cPi7t98b@orbyte.nwl.cc>
 <20241119200700.GA3017153@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119200700.GA3017153@celephais.dreamlands>

On Tue, Nov 19, 2024 at 08:07:00PM +0000, Jeremy Sowden wrote:
> On 2024-11-19, at 14:20:31 +0100, Phil Sutter wrote:
> > On Mon, Nov 18, 2024 at 01:56:50PM +0000, Jeremy Sowden wrote:
> > > Remove the mask parameters from `is_same_interfaces`.  Add a test-case.
> > 
> > Thanks for the fix and test-case!
> > 
> > Some remarks below:
> > 
> > [...]
> > >  bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
> > > -			unsigned const char *a_iniface_mask,
> > > -			unsigned const char *a_outiface_mask,
> > > -			const char *b_iniface, const char *b_outiface,
> > > -			unsigned const char *b_iniface_mask,
> > > -			unsigned const char *b_outiface_mask)
> > > +			const char *b_iniface, const char *b_outiface)
> > >  {
> > >  	int i;
> > >  
> > >  	for (i = 0; i < IFNAMSIZ; i++) {
> > > -		if (a_iniface_mask[i] != b_iniface_mask[i]) {
> > > -			DEBUGP("different iniface mask %x, %x (%d)\n",
> > > -			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
> > > -			return false;
> > > -		}
> > > -		if ((a_iniface[i] & a_iniface_mask[i])
> > > -		    != (b_iniface[i] & b_iniface_mask[i])) {
> > > +		if (a_iniface[i] != b_iniface[i]) {
> > >  			DEBUGP("different iniface\n");
> > >  			return false;
> > >  		}
> > > -		if (a_outiface_mask[i] != b_outiface_mask[i]) {
> > > -			DEBUGP("different outiface mask\n");
> > > -			return false;
> > > -		}
> > > -		if ((a_outiface[i] & a_outiface_mask[i])
> > > -		    != (b_outiface[i] & b_outiface_mask[i])) {
> > > +		if (a_outiface[i] != b_outiface[i]) {
> > >  			DEBUGP("different outiface\n");
> > >  			return false;
> > >  		}
> > 
> > My draft fix converts this to strncmp() calls, I don't think we should
> > inspect bytes past the NUL-char. Usually we parse into a zeroed
> > iptables_command_state, but if_indextoname(3P) does not define output
> > buffer contents apart from "shall place in this buffer the name of the
> > interface", so it may put garbage in there (although unlikely).
> 
> Seems reasonable.  I was so focussed on the masks and bit-twiddling that
> I lost sight of the fact that the code is looping to compare strings. :)
> 
> > Another thing is a potential follow-up: There are remains in
> > nft_arp_post_parse() and ipv6_post_parse(), needless filling of the mask
> > buffers. They may be dropped along with the now unused mask fields in
> > struct xtables_args.
> 
> Yes, I spotted those.  I couldn't see how they were used, but I was
> reasonably sure that they weren't related to this bug, so I stopped
> looking.
> 
> > WDYT?
> 
> Agreed on both counts.  Shall I incorporate your suggestions and send a
> v2 or do you have something already prepared?

Sent a v2, please review.

Thanks, Phil
