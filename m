Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18C13375B3
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756828720; cv=none; b=KoaXVfPmChLvK1UBdAlAGTdp57O9/PGizeAvciCNC45aimabWA2MzNHYvSK3MWBD2nSOESisjCzRaztlXS7yhkcWybJwj9FmVoyQUCPxs9HZTnHOn1qGzqN8GxRXZnnQBXm2M49F0A7wX4I+cLeGc6ugUgaA891Cf1h7Oh60uXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756828720; c=relaxed/simple;
	bh=maS8CqU+yRdeBB5YtQtkqJ+QWm+JTNQ7I8W7RnmEIC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjeku7E4OXJeTJlLP5NlYFPHeqLCme4+t+RJuppYjNRcBnURfT2BmJ1hAyxYn9iVkKQCQyPnYkHzSunbJ5H87VC1fwPf2xP3nFJYMOutjZSHIa64iNLEeAAga7EiPI1niiHldlXN+M5X8iM1nCxmB4SLp1saPKVToq/FtORMMy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Up4KkMbF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wt/xxrBm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Up4KkMbF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wt/xxrBm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EC70A608CF; Tue,  2 Sep 2025 17:58:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756828715;
	bh=oa6/b6ZBWUcIgkPkHmMaFsJmJCbPebWZCJq+IvdAJpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Up4KkMbFAm3HOz1WvqIaOxUGQuJnireERo9MWgPXk9buV2CxgeXOssO0i6whhut1n
	 xzIOv/YjjTzIsKul1uMeV814LsmWZd8tSKpQjZNXm9Jif3xJ5TmAIIjb/OiiT8xMa3
	 CvU9jK6d9ztAFMUfoYaJ7/2VX9mfPz3JO3BSo8lzjKlh+75ajwvrk+XEE+5fcDpmEv
	 W790p6f+3AP+woGgy4ppcZb8Z6XwIgH9fU+QbEkWaFN/Z0NKBOc1LauEi2TZ23KvYR
	 HHo1aw5X1GlyT5EbqJsvmc/UmH4Bmu5ctroG2glwZPG6kxVp2Xl/8DfzDAT/KdgncN
	 ZJT1pCV7D+3qg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 49953608C5;
	Tue,  2 Sep 2025 17:58:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756828714;
	bh=oa6/b6ZBWUcIgkPkHmMaFsJmJCbPebWZCJq+IvdAJpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wt/xxrBmMpk0m8BEDchaYgZNG+UzHGB12izYlLmXZ1BC4aHyOkjhh+rhqVJCWyW3r
	 E2sDKudeVC5B3U32JfmA5LanNKlcuEVFl3rH7wzk6LDeXM8zLCujX1bc2+np4HdYcH
	 h7iWDqwfOzsHezgLzsLrB/fknkxqhmEsDYVC/X56GOsxNyuLn/Z6SAYDEPfkdwL/YS
	 H3hc0/K8cJihPBl4eFkgs9UIzwJb/UV/5NWSeFHchVbAG7ephp2ViLvBBFKfplBFww
	 CMtT5sW4ze2QU1+IWI7Kp6KZnZP89R3OSek8DHMsmpP+JK/q22cgNBPVDo7KTmf1mx
	 NjqyNkDW0f+bg==
Date: Tue, 2 Sep 2025 17:58:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
Message-ID: <aLcUJ5U0LWW_-Vo8@calendula>
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de>
 <aLcBOhmSNhXrCLIh@calendula>
 <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de>

On Tue, Sep 02, 2025 at 05:34:02PM +0200, Fernando Fernandez Mancera wrote:
> 
> 
> On 9/2/25 4:37 PM, Pablo Neira Ayuso wrote:
> > On Tue, Sep 02, 2025 at 02:08:54PM +0200, Florian Westphal wrote:
> > > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > > > Expose the input bridge interface ethernet address so it can be used to
> > > > redirect the packet to the receiving physical device for processing.
> > > > 
> > > > Tested with nft command line tool.
> > > > 
> > > > table bridge nat {
> > > > 	chain PREROUTING {
> > > > 		type filter hook prerouting priority 0; policy accept;
> > > > 		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
> > > > 	}
> > > > }
> > > > 
> > > > Joint work with Pablo Neira.
> > > 
> > > Sorry for crashing the party.
> > > 
> > > Can you check if its enough to use the mac address of the port (rather
> > > than the bridge address)?
> > > 
> > > i.e. add veth0,1 to br0 like this:
> > > 
> > >          br0
> > > a -> [ veth0|veth1 ] -> b
> > > 
> > > Then check br0 address.
> > > If br0 has address of veth1, then try to redirect
> > > redirect by setting a rule like 'ether daddr set <*veth0 address*>
> > > 
> > > AFAICS the bridge FDB should treat this as local, just as if one would
> > > have used the bridges mac address.
> > 
> 
> You are right Florian, I have tested this on the following setup.
> 
> 1. ping from veth0_a on netns_a to veth1_b on netns_b
> 
>                      +----br0----+
>                      |           |
> veth0_a------------veth0      veth1--------veth1_b
> (192.168.10.10/24)                     (192.168.10.20/24)
> 
> Using the MAC of the port, the packet is consumed by the bridge too and not
> forwarded. So, no need for it to be the MAC address of the bridge itself..

Thanks for confirming.

But this is going to be a bit strange from usability point of view?

It is easier to explain to users that by setting the br0 mac address
(as we do now) packets are passed up to the local stack.

Maybe both can be added? But I don't have a use-case for iifhwdr apart
from this scenario.
