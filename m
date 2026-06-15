Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832CB1FC7FB
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547372; cv=none; b=LgA4YHjFOvM7byjD8MVTjyuiBbzf5273rmrA02W1z7m4hDYJUaYWZPN8HfugnxTlU12fY4UbG15Wbgvb9zqEvvt/7vzR3ebf6tvzMd5fLj3B8TH0nyJM7pIEBBrQc9vf2Km9Wn18t0QLKyjs2vYqMGiiMpBc790Vy195eJRj7e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547372; c=relaxed/simple;
	bh=5lBKgr6TW/+lPPw90hNjUFrF7a0fg+b1/ApnPudX5Js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqMW8pWZeAHr7zx5uY1BEHBhkIM9Jb+vsu0ozdAeaSi32i2Rh7ZKDj/YQpHKfnQzWj7qWc7dQSxmKlyna0DN9gChJC18R2Jg0/hZ6wptM+tGuMfRBTM7orVFM2vp8h1eFocuB0c/m5vVthztqHvZdZCgPD28sMdtM5bnykhWyJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 39DEB602C8; Mon, 15 Jun 2026 20:16:08 +0200 (CEST)
Date: Mon, 15 Jun 2026 20:16:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ajBBZgEBh64u0m-G@strlen.de>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
 <ai3WcsS00Rbjy61u@chamomile>
 <ai3Y68Fqd-V3cpOS@strlen.de>
 <ai533miYJF9-J3yB@chamomile>
 <ai6Ncagz3tfhFTAS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai6Ncagz3tfhFTAS@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > > This is wnat ebtables.c already does which is why this poc would
> > > not work for classic xtables.
> > 
> > Do you refer to targets specifically, correct?
> > 
> >         /* Reject UNSPEC, xtables verdicts/return values are incompatible */
> >         if (target->family != NFPROTO_BRIDGE) {
> >                 module_put(target->me);
> >                 ret = -ENOENT;
> >                 goto cleanup_watchers;
> >         }
> 
> yes.

I just submittted:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260615181044.4049-1-fw@strlen.de/

which extends the original ebtables fix to nft_compat.

I consider this an additional fix, it does not replace/supersede this
patch.
