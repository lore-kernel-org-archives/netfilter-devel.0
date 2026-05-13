Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1B1B87C9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 12:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778676361; cv=none; b=XH/nnS2hQtWuO24x+iC+R7lzU3rcFf7hxFByCX4IXESjfHQ18NGPeEx5msw+ttW/Obvxznm2QGbb6nBfQ10rWisRyAwdatP/hhfKspSJZdahd6Oui/uhgcvGOOFH2ETJCk8mXl43ypII5qVfyoyw7oY7KoKUocJljf9Z616HxDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778676361; c=relaxed/simple;
	bh=L8je4aMxwkkPIF72GdBYB2RCogqX6qa/XxyL3LH8B90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eC2h7jvpYXkGp3wpjkVLQZM0sYIrN/P/SH9z/QGZPx9mb3sgcanUgAJUeE2NqGx9upBKdmYLwT0nERS4jPlEAXBOw7hFBXtfdcuHnZD0HLdv+/qDwud8s2UGfYQ70BQU9Z7tReQt3Khi8PR9uFrfLEW1d7/gy8l2pn+tySnC2fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8D940609A6; Wed, 13 May 2026 14:45:57 +0200 (CEST)
Date: Wed, 13 May 2026 14:45:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	pablo@netfilter.org,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_conncount: prevent connlimit drops for
 early confirmed ct
Message-ID: <agRygM7hHtKs8jQB@strlen.de>
References: <20260513121547.6434-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513121547.6434-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>  	if (ct && nf_ct_is_confirmed(ct)) {
> -		/* local connections are confirmed in postrouting so confirmation
> -		 * might have happened before hitting connlimit
> -		 */
> -		if (skb->skb_iif != LOOPBACK_IFINDEX) {
> +		if (test_bit(IPS_ASSURED_BIT, &ct->status) || ctinfo == IP_CT_ESTABLISHED) {
>  			err = -EEXIST;
>  			goto out_put;
>  		}

IIRC IP_CT_ESTABLISHED requires we can observe traffic in both
directions.  I'm not sure it was a good idea to allow this new
usage case added in 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped"),
but I don't think we can revert it either :-(

No idea how to fix this mess.
