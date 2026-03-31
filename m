Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549928DC4
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774969682; cv=none; b=ap707px+SKeeqimAbwBSeYiRG/Zn1aYkryh9SLtVFpSPvpTdNkvmVPTfeI7gxE1CxnSzXV1gLuzfEloJ89jLMMkClFgsiSA0qYqRWd90y55MlYtCuFcmnS6WgLwSBXiA6C4EAIPh0EuLQXrQOy7LQ6yxvzCC9iIQljlhuYkHYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774969682; c=relaxed/simple;
	bh=FKsBhQ2P0mA7dpIe7sv4/C6l7Ao/a09V0QX08fBK7+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omklKmmSqNKTZLTSAqE9ehMvR/xINpDheGeZme8QoBv1crDPezjQXjeNamXccJskN67G7VMrFlskawkfs4fNpVCzNpzNXzG5lSN0ENejQ5ptTDPtxiKrOyJPk8KY0A7Q8oiKy4lkH3vWpZp58DcAhZxtkQlru7YkxyqeUPO4vEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BEC3D6078E; Tue, 31 Mar 2026 17:07:51 +0200 (CEST)
Date: Tue, 31 Mar 2026 17:07:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH nf] netfilter: x_tables: restrict
 xt_check_match/xt_check_target extensions for NFPROTO_ARP
Message-ID: <acvjSICL-a6LJK74@strlen.de>
References: <20260331150146.958012-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331150146.958012-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +	/* NFPROTO_UNSPEC implies NF_INET_* hooks which do not overlap with
> +	 * NF_ARP_IN,OUT,FORWARD, allow explicit extensions with NFPROTO_ARP
> +	 * support.
> +	 */
> +	if (par->family == NFPROTO_ARP &&
> +	    par->match->family != NFPROTO_ARP) {
> +		pr_info_ratelimited("%s_tables: %s match: not valid for this family\n",
> +				    xt_prefix[par->family], par->match->name);
> +		return -EINVAL;
> +	}
>  	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
>  		char used[64], allow[64];

Thanks Pablo, this looks fine.
