Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9731CA5F
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830800; cv=none; b=TcK6IQYXLnz5cXoiHMN+PXRKAn+7C4/utGhqAXqohWKq9iGTiiBL/Kv7z23t/ATLPJEX9X60L1DNVlBZh1b0CXKgVPdL105DMPmx176k0Hn+nB0Cd1rrCA1onRd9HkHyN/484YWXUiPeYLiTpaxlkIQNFHt47/D891DQ8qnkgH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830800; c=relaxed/simple;
	bh=Gelz3f1Q7ifBWEz+SA1x97ucZqDkdi6LGoMYhtjT5/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO2aJKZRtaJ4la/4L0U4e61m7Zr0TWgc+KGyKNp/Aqv8h/vnoR/Fff89TWhDgVbjQIVePofPacUyisE7y+4sTiFXJyrxFoGVr3j/AbS/NgwdMVmcmFr6c1J8b/k2FOzTYy+0tifzlSbbyZi4v3e38upS7NDlNLWQSsA/Zj1h4Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 291C460288; Tue,  2 Sep 2025 18:33:15 +0200 (CEST)
Date: Tue, 2 Sep 2025 18:33:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
Message-ID: <aLccQ9MN20VExE-4@strlen.de>
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de>
 <aLcBOhmSNhXrCLIh@calendula>
 <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de>
 <aLcUJ5U0LWW_-Vo8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLcUJ5U0LWW_-Vo8@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >                      +----br0----+
> >                      |           |
> > veth0_a------------veth0      veth1--------veth1_b
> > (192.168.10.10/24)                     (192.168.10.20/24)
> > 
> > Using the MAC of the port, the packet is consumed by the bridge too and not
> > forwarded. So, no need for it to be the MAC address of the bridge itself..
> 
> Thanks for confirming.
> 
> But this is going to be a bit strange from usability point of view?
> 
> It is easier to explain to users that by setting the br0 mac address
> (as we do now) packets are passed up to the local stack.

Fair point.
So lets just go with this patch set, forget I said anything :-)

Fernando, if you have some cycles, would you make a packetpath shell test
for this to exercise the datapath?

Thanks!
