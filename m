Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C17B149DE8
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 21:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742763862; cv=none; b=iL7p9i/t6JOSVXFtmNSGyArRJ0hyqVPYWU4vtuV1WoUzuFge+NpOMStkoJ3faldb+8LFWbzhsVhNER6i98i4qZciFoWz3FG9mi6KJf15IZTNySAHL2j28hTDDX35u6m5sm34hLmmtINQzQ+xMhWxCVhHFY8moP+hRGPH6TWiakI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742763862; c=relaxed/simple;
	bh=piNPWOksgCwONXg9udXmmoZrhenEPQlJF5mqYloCSts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GouO888PP5HowK5y60HUvmdY8qO9Do7BlrO2q6/3zhZdhzW49DcQTEpYIFfsA8Zdw51ESWgw/qJ45AtibfhVNeRalrtDlWjn+7zrKokH8RUKkiEDZZhQaQVhwpWykqbkjuoV9SX6yZyJElYB6fIePflzC6A0AsnH03PioXDrJm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QwT+H9q4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QwT+H9q4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G+jG/VPNlornxQkH0/Iv4ZAuIN2WnTKjama/3j7ibM0=; b=QwT+H9q4KsOFDVupewI7X8/xLr
	3fm4S3N+op5ZntwUCfg90zqXZHR/5MrvdPTdLc4hm32jeO4Bm9YCLdmk5wWKh6JVvI2EPA2qX9gJT
	BFtVS+oi8UxMJc5YvA1eqE9jalHYqONAn5A4c9gBbwDRtWc1fQZ/bHtzjPVoU0pYkm/2v8tfCiBlb
	ku+cJ5PiAN9tBCgRMPYNfkHJfb16nr3fnEGGbHjflqzoja+Y46PozHDnNerqH26snnThoj8aMhe4G
	rK9FXHRj6UXqq/AF8PoSqyjJ0ON4GDyAlitLhtXWOw64YU2WiZNT2XHKj70wol60RGOsAthTVgSEo
	o6QuA9NA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1twSUK-000000006JS-14Jt;
	Sun, 23 Mar 2025 22:04:08 +0100
Date: Sun, 23 Mar 2025 22:04:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <ej@inai.de>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	Duncan Roe <duncan_roe@optusnet.com.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, matthias.gerstner@suse.com, eric@garver.life
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
Message-ID: <Z-B3SLFZMoZmZObv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Jan Engelhardt <ej@inai.de>,
	Arturo Borrero Gonzalez <arturo@debian.org>,
	Duncan Roe <duncan_roe@optusnet.com.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	fw@strlen.de, matthias.gerstner@suse.com, eric@garver.life
References: <20250228205935.59659-1-jengelh@inai.de>
 <Z8jDjlJcehMB_Z9F@calendula>
 <dfaada92-44ca-44c1-83e4-5844191ff57b@debian.org>
 <Z94XLnSQRfMh9THs@slk15.local.net>
 <22n4s4s4-8155-708o-4091-q6o3nq313641@vanv.qr>
 <5bf4cd03-ddb3-4cc4-b07e-e25e475395f8@debian.org>
 <s44sopr8-7n17-1979-4qrr-4p5ps9s4s1rn@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s44sopr8-7n17-1979-4qrr-4p5ps9s4s1rn@vanv.qr>

On Sun, Mar 23, 2025 at 02:34:01PM +0100, Jan Engelhardt wrote:
> 
> On Sunday 2025-03-23 11:00, Arturo Borrero Gonzalez wrote:
> >> On Saturday 2025-03-22 02:49, Duncan Roe wrote:
> >>>>
> >>>> I have mixed feelings about having this systemd service file in this
> >>>> repository.
> >>>> Will this file be maintained wrt. systemd ecosystem updates? Or will it be
> >>>> outdated and neglected after a few years?
> >> 
> >> There are no changes expected to be necessary.
> >
> > How so? Is the systemd ecosystem not evolving?
> 
> I do not have a crystal ball that shows me what will (or will not)
> happen in the future, so as far as I can tell, it is perfect as it is.
> And I have no indication that unit files are planned to be ditched
> anytime soon.

Even if things will change and this thing gets outdated, who cares? The
bottom line is what we do currently, namely maintain nftables.service
ourselves downstream.

Apart from having to deal with heated debates over its content on the ML
there is no real burden for upstream to maintain it, either.

To me, this is an opportunity to share knowledge (e.g. others performing
a needed unit file update before I find time reading up on systemd's
latest "invention") and it may even encourage downstream maintainers in
collecting/discussing sample config best practices.

Cheers, Phil
