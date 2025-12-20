Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFF71E4AB;
	Sat, 20 Dec 2025 20:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766261170; cv=none; b=rcVVrvCXkZDv1U48eT1Lu+LRRwVeVqpW/04O/ij5IQB7IvXDaxjEVLU74pKd1c5wvS6wfT+4Bid8WeJC0z5/1SazE/O+pTSLDXPF+CLSYNA5pQWHSB6rc1PsW+Er7P751uxykfcYTi6SabbMzF6nCTEsS12xRjR666JU6bcvo8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766261170; c=relaxed/simple;
	bh=E6StCNtlHToNzEn+XM3yJAUF63HEDsCHcYH9Xf3tfy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiMOQAv2Y+mS4CzKM8dDnQ2uhR3mYSv3rzxjg+/rqC0Ia+vffi4WzQlnOu/xbW1j0RpHjkn9pQHNZ3eo2h+WohePlv413fsbBsZNvKITwMlxryx6GRIYIDiEw6/qhlFIH3pwkYJYw2E/zgf/nXdqaNsElJ0u6UJHSjJsLS23J6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4DF1560351; Sat, 20 Dec 2025 21:06:03 +0100 (CET)
Date: Sat, 20 Dec 2025 21:05:59 +0100
From: Florian Westphal <fw@strlen.de>
To: Yuto Hamaguchi <Hamaguchi.Yuto@da.mitsubishielectric.co.jp>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack: Add allow_clash to generic
 protocol handler
Message-ID: <aUcBp4VuHTPqCdEt@strlen.de>
References: <20251219115351.5662-1-Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219115351.5662-1-Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>

Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp> wrote:
> The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
>  ("netfilter: conntrack: introduce clash resolution on insertion race"),
> sets allow_clash=true in the UDP/UDPLITE protocol handler
> but does not set it in the generic protocol handler.
> 
> As a result, packets composed of connectionless protocols at each layer,
> such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.
> 
> To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.

Makes sense to me, thanks.
I'll apply this for the next batch.
