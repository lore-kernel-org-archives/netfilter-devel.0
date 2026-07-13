Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D23932CE
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783931056; cv=none; b=WwICmK8fc0drb5abaHN2PYSNunlR+o+5bV09zTcLCNM/OLbHgujmprGPdSAHh/Bb8SvlSfkRYG+sSE90N+cDqxjUz3+dRZuMEslZq5CCbkzYW9htAuWm51ppNzdAqGCw79RSc9OqRtX7D0Id4QrX3g2bQo4DxlwJzQ5lVvWasK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783931056; c=relaxed/simple;
	bh=yPMfS+hTtc/QyjxRPmG02j1xZX1C77vrMPBOn3WgMos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3xDRMm6IW6u0HSEqLSoc188oBxPEMaZ7jgO8WGg2iC8s06qaVFD3Ueuso5OSdB8tgHaIbavoKJIXSUAKklSCr/TkzQ+u2ZuutiJrFotDho6dPbzaC70If9kyekLuytjhud28f6+CvortPe152k3k7m19rcAb1BCPVk0xKh1Wb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EXzKMZna; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EXzKMZna"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id F12326017D;
	Mon, 13 Jul 2026 10:24:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783931050;
	bh=OEUBunrlkXT738nzXy77hWBAdQmGn4ek1ZNVVT+zcFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EXzKMZnaObXjDYLMqCp/zdZV5zwJ3BPHyQc7PcxtT15aQdyqBG4VzfFmfBbteFrWA
	 wtuh2+yAoxvQDhm+x58KgRYp691Pu/lnEYpKQqaNGyx651SQdc7A1YeC0Cwvs3n4Fn
	 v+SD+0AC3ty4mE7AHInLCj+DyFZnACLLsGcLrClTgjQVWHLbGgqEk9tSGHgxNo/YJO
	 n6VYTquNqImtkH/2qRLuz0/kMlwIejaWCQAnLdh5aqFFILpkrFqbd6Cyx7t4YgL1fn
	 pC7wfM5uISqfB7TDhNhjwtJYGTZttPLvExc8qCn9PLwvwpbjRPVt47pGTMmW4Bpa4z
	 DZWrydTDZHGeg==
Date: Mon, 13 Jul 2026 10:24:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org, razor@blackwall.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 3/3] netfilter: flowtable: initial bridge
 support
Message-ID: <alSgp8fee8DNzdrG@chamomile>
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-4-pablo@netfilter.org>
 <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>

On Sun, Jul 12, 2026 at 11:27:50AM +0200, Eric Woudstra wrote:
> On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
[...]
> > +	this_tuple->iifidx = info.indev->ifindex;
> > +	for (i = info.num_encaps - 1; i >= 0; i--) {
> > +		this_tuple->encap[j].id = info.encap[i].id;
> > +		this_tuple->encap[j].proto = info.encap[i].proto;
> > +		j++;
> > +	}
> > +	this_tuple->encap_num = info.num_encaps;

nft_dev_fill_bridge_path() is called with indev for dir, but
dev_fill_forward() obtains the list of devices from indev.  This reverse
iteration gives us the expected encapsulation before such list of
devices for this direction in the ingress path.

> Until here, this_tuple needs to be the other_tuple.
> dev_fill_forward_path() does not traverse the bridge.
> See other comment in other patch. Also, need to copy
> the in_vlan_ingress bit.
> 
> So it becomes:
> 
> other_tuple->iifidx = info.indev->ifindex;
> for (i = info.num_encaps - 1; i >= 0; i--) {
> 	other_tuple->encap[j].id = info.encap[i].id;
> 	other_tuple->encap[j].proto = info.encap[i].proto;
> 	if (info.ingress_vlans & BIT(i))
> 		other_tuple->in_vlan_ingress |= BIT(j);
> 	j++;
> }
> other_tuple->encap_num = info.num_encaps;

I don't see how it can be this way.
