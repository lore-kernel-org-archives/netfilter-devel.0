Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AB432A3D7;
	Tue, 30 Jun 2026 05:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796612; cv=none; b=p0sxlKXDwqkhHYlx8y0w9rDqJJ/b+X9uzKdtwpK8fPC5qLyzCrrnRVOGFQzaW6BEeCOmtfqUE+ZGq5X7OP/PI7Su6XDZ7ErQSyse1qjNop/MetO+mCHUTAZEVVqGELVVC9OdSzxBm2wd6cWFQZEXyKDnJ0DASuX//PvOsvSOjXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796612; c=relaxed/simple;
	bh=wrI2NdcJ5fFbuVZ1pzUuda1VQkh21nFSHNZ8FCUTZCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyQo44iO0u73+7Tq5iP+aaWvicIyvmXRWF30KmNA2+AKZDaT1HKgPfiADHWT1ajFKABCOOoiodQW6cFiqLeOHW56W00lw/lF9CERbeeSCX9QqCWvDqgnuFcAw8uhzZYX2HjW0CkPewfBhiGsKOSNo41QSNivviJyS7w9av51MVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8D3E960D0F; Tue, 30 Jun 2026 07:16:48 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:16:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhixing Chen <running910@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ip6t_ah: validate AH header length
Message-ID: <akNRQFx9fmi2DK0w@strlen.de>
References: <20260618125848.93550-1-running910@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125848.93550-1-running910@gmail.com>

Zhixing Chen <running910@gmail.com> wrote:
> ip6t_ah checks that the fixed AH header is present, then uses hdrlen to
> derive the advertised AH header length for matching.
> 
> Return false if the skb does not contain the advertised AH header length.
> This avoids matching AH headers whose advertised length is not present in
> the skb.
> 
> Signed-off-by: Zhixing Chen <running910@gmail.com>
> ---
> 
> I noticed ip6t_hbh and ip6t_rt already do this advertised-length check
> for their IPv6 extension headers, so this keeps ip6t_ah in line with
> those matches.

Could you make a v2 that addresses

https://sashiko.dev/#/patchset/20260618125848.93550-1-running910%40gmail.com
?

We should not return false in matches for malformed packets without
also setting ->hotdrop = true.
