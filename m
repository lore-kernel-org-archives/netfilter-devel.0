Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F1B3093D2
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 20:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756328154; cv=none; b=BQfa+h5SrhDfPH23S21ZkAFaP7qrwsSkqiMnNOsUYcvETo8Y+3ilnXgJ+9+Y7sNBSi2dIoI92eBtVcm6ZmC8lqoJaORqSDgfCJ0tnehw1MTjtyLQH3J8fnqxV7zWys+RTaS2Y8isADSBNjWU0KFSAmCtIorAHkwmnWzbGtMCRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756328154; c=relaxed/simple;
	bh=1crjKCSiNKtnQ6D88kcY6PlM6dYL1cFlnBBpr8f/rcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtlF3cgP+p03hbd8HaGwiCx3REVCHkuGxcGMKXwFOiPXI5769uF7y41qjhDvIT9gRX3mq+MKg15ufTq/0t76hU3VvY4joOiash46ba6+RHpLpQYLkVpm26idJ/74p0mJ5NdFN79NKhDNJuMhswwFZGPEuNd8VqXhwHIGLVxTKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cyAtEfLK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cyAtEfLK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Th6JW/NBvLlr4vba+Is5LxtBD2GQii6Tf352lL3szsE=; b=cyAtEfLK4M+dHDhPd1gZ8FOBjD
	tJ1fvpUzLIlR54p+2pFVxO3MuJL3pxCU+PIxLwKV9cKnHfk5Bie0vUSlVx+OQRJ3/b2TS58e2A8p7
	jGPGs2798N81O+AH2tfPGiaEjDTA2tTrXEkAg4ShjyB1zvsy+YRPmcy2pmlOoWjornDX/W0M+eGtk
	s8amuim8NSDYl49SBNoHiKuhFll4DRFYu8qA/YIIFL2UVEbjR5AhCEMcvQ4ql2OeVZPGg33dS0T7V
	E3nZRIxIFlj/kblssfSI2eJIQ+lp40duL3ajVEK+T+qs/+M8CFmYDwrAFmbbHHlyhDOvjL30RV3Du
	tXmNPjow==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urNBN-000000004NH-2X6J;
	Wed, 27 Aug 2025 22:55:49 +0200
Date: Wed, 27 Aug 2025 22:55:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables monitor json mode is broken
Message-ID: <aK9w1Zqmxa9evI4C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aK88hFryFONk4a6P@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK88hFryFONk4a6P@strlen.de>

Hi,

On Wed, Aug 27, 2025 at 07:12:36PM +0200, Florian Westphal wrote:
> as subject says, 'nft monitor -j' is broken.
> Example:
> 
> ./run-tests.sh -j testcases/object.t
> monitor: running tests from file object.t
> monitor output differs!
> --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:08.039619097 +0200
> +++ /tmp/tmp.emU4zIN8UT/tmp.jBOL3aIrp5  2025-08-27 19:05:09.062551248 +0200
> @@ -1 +1 @@
> -{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
> +{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 0, "used": 0, "inv": false}}}
> monitor output differs!
> --- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:10.095619097 +0200
> +++ /tmp/tmp.emU4zIN8UT/tmp.Guz55knY19  2025-08-27 19:05:11.117393075 +0200
> @@ -1 +1 @@
> -{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
> +{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 0, "per": "error"}}}
> 
> I did notice this weeks ago but thought it was a problem on my end
> and then didn't have time to investigate closer.
> 
> But its in fact broken on kernel side, since
> 
> netfilter: nf_tables: Reintroduce shortened deletion notifications
> 
> In short, unlike the normal output, json output wants to dump
> everything, but the notifications no longer include the extra data, just
> the bare minimum to identify the object being deleted.

Oh crap, I missed this entirely.

> As noone has complained so far I am inclinded to delete the
> tests and rip out json support from monitor mode, it seems noone
> uses it or even runs the tests for it.
> 
> Alternatives i see are:
> 1. implement a cache and query it
> 2. rework the json mode to be forgiving as to what is set
>    and what isn't in the object.

My suggestion:
- Add special casing for NFT_MSG_DEL* with NFTNL_OUTPUT_JSON as well in
  monitor.c
- Pass 'bool delete' to monitor_print_*_json()
- And on to *_print_json() (or implement *_print_json_bare() to
  conditionally call from the above

> Object here also means any object reported in any delete kind,
> not just NFT_MSG_DELOBJ.  This applies to set elements etc. too,
> json expects the full info, but the kernel notifications no longer
> provide this.

Yes, and there is no proper way to detect these incomplete objects. So
the only way to fix it is to pass the message type into print routines.

Funny detail: JSON echo mode is unaffected because it ignores anything
that's not an add command. %)

> Alternative options?

Ignore the problem for now, I'll implement the proposed solution above
tomorrow. I hope with the patch at hand, we can decide whether this goes
into the release or not.

Sorry for the mess!
