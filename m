Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D7C3054E6
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 12:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756814939; cv=none; b=qxl1G1ZaYVdjkDrkBuNXk+H+yYWeAxoyy3yEcZug3TZPDdaArbvCniAJLARHZrFe2KW4UK8qVcMISavBVlKB/hUoTADuyrQCxdH96i4CfP0KNMLtflVM58d/twCwGJeaKOcc/Kt5Qjp1jvdrYy4iDWNGGKSpzXjD3mxix4ZE/MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756814939; c=relaxed/simple;
	bh=sQELTW10CahVWQTN/AjIk8GF5XTUPSGqNxINTdbSBBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9cwkki1ZIlqFNYl9OtPFGAycaaP/GZu9/Nt7IOjxezxj71n1bYstuRs/CTWbO3ddqsE+LlQQhz7q7beOF5KMG1KssqRCwvehi9SHqw+Uk934BwlYjryErTqk/7ouVbLNXhA5mCfoFG857uTWaU35msZ1/SGouVhg1IZZi7wkbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3230C606DC; Tue,  2 Sep 2025 14:08:55 +0200 (CEST)
Date: Tue, 2 Sep 2025 14:08:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
Message-ID: <aLbeVpmjrPCPUiYH@strlen.de>
References: <20250902112808.5139-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902112808.5139-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Expose the input bridge interface ethernet address so it can be used to
> redirect the packet to the receiving physical device for processing.
> 
> Tested with nft command line tool.
> 
> table bridge nat {
> 	chain PREROUTING {
> 		type filter hook prerouting priority 0; policy accept;
> 		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
> 	}
> }
> 
> Joint work with Pablo Neira.

Sorry for crashing the party.

Can you check if its enough to use the mac address of the port (rather
than the bridge address)?

i.e. add veth0,1 to br0 like this:

        br0
a -> [ veth0|veth1 ] -> b

Then check br0 address.
If br0 has address of veth1, then try to redirect
redirect by setting a rule like 'ether daddr set <*veth0 address*>

AFAICS the bridge FDB should treat this as local, just as if one would
have used the bridges mac address.

If it works i think it would be better to place a 'fetch device mac
address' in nft_meta rather than this ibrhwdr in bridge meta, because
the former is more generic, even though I don't have a use case other
than bridge-to-local redirects.

That said, if it doesn't work or the ibrhwdr has another advantage
I'm missing then I'm fine with this patch.
