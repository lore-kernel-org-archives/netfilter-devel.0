Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED1227B353
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 22:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781388066; cv=none; b=gOW2hjMbPerDFbJFvB2dQ7TB5xyXya3NovM/XdUfaSPMz2NWOuCL75jRl2bVF0YlzY6Uzg3uIEUVqSIZk3HTbPOPzl1NXAXmwQ3PFAp6N2GF1s1pmxhPpfNFyzQfsspuEtIQ4EJpG3VZdq4athd6LpxNtsbZwA4dovOjL4VOFjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781388066; c=relaxed/simple;
	bh=I8yH4Vwj2reYsPGW4+WlmlkO2qepiEjMeCI7q/AVrkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpYVmVuUWjDfpTEBTK/Yg3ru5Uks+uvMIcIZ0sPEUb25szAyCQOQp1MDvonbQqwdmY4d+hUoJ3hZwAkbsdWDtevKox7MsXLFdImTMpowgUrXRS0uW3wdCg8tU+YoWF4pdY16k7j6FI8ZJDKBQ8a3QlpuRiBLrgKMSvt86olBVpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96E76605A2; Sun, 14 Jun 2026 00:01:01 +0200 (CEST)
Date: Sun, 14 Jun 2026 00:00:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	zcliangcn@gmail.com, bird@lzu.edu.cn, bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai3TGFyMlkS1m8O3@strlen.de>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai3MJ2P2MnXLxcmb@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
> > xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
> > is present and can dereference a NULL pointer when instantiated from an
> > unsupported family through nft_compat. A bridge-family compat rule can
> > therefore trigger a NULL-dereference in nf_nat_setup_info().
> 
> Are you sure this is related to nft_compat?  What prevents attaching
> -j D|SNAT to classic ebtables?
> 
> > Reject non-IP families in xt_nat_checkentry() so unsupported targets
> > cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
> > compat users and leave the runtime fast path unchanged.
> 
> Not so sure, I don't think there is harm in allowing NFPROTO_INET but
> such users should not exist.
> 
> Patch is fine. There are already many different targets here,
> I don't think we should do a NFPROTO_IPV4 / IPV6 split in this case.

I take that back.  This problem goes beyond xt_nat.c;  see
11ff7288beb2 ("netfilter: ebtables: reject non-bridge targets")

Can you make a patch like this one for nft_compat?
We can only use NFPROTO_BRIDGE targets, never UNSPEC, for NF_BRIDGE
caller.
