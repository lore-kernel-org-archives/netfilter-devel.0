Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C988F3BFAE0;
	Sun, 18 Oct 2026 04:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792299349; cv=none; b=i+BYjgQ9CxM+kU15lH7j8wm/xTo88QE0puZ2sExQYcFD3OaGET1B/qD1FuvUtqkxtbHGWhOG/cKesfeUMqrpT/Txk83HvkZBz38baHbYZPH5D4dsUeUju/W85PnfNabWCjwSsBiRMyllDu5Qv3PcmubbrEDOFSY4Hqh5ZSF7ZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792299349; c=relaxed/simple;
	bh=ld+l0Dj113tke4UYftsIXx5vftDmKj8FzjYaFWmfJ9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8vjjZoOfBybctJ52zehZQipJEYi7ar6QzibQTmnBGF/r8yD2T0v85i1L4NsU+EDSYsCBoNLNMuiuA1bY/1kmXlX7YASs1rX2gKpo4DlsN20P6rGxLIqvUlDUqmie8v+YaRzbx9yuKDIvEJoJtLnkYjLX2ksYBcFxUqtw9IGevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C89DB60327; Sun, 18 Oct 2026 06:55:39 +0200 (CEST)
Date: Sun, 18 Oct 2026 06:55:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Tamaki Yanagawa <ty@000ty.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: restore element before rescanning
 cidrs on seqcount retry
Message-ID: <atRROQfgdeGSIU5s@strlen.de>
References: <20261018035205.1008-1-ty@000ty.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018035205.1008-1-ty@000ty.net>

Tamaki Yanagawa <ty@000ty.net> wrote:
> mtype_test_cidrs() masks the element under test in place with
> mtype_data_netmask() while walking the cidr array from the most to the
> least specific prefix. Since the walk is restarted on concurrent cidr
> array updates, the IPSET_NET_COUNT == 1 types (hash:net, hash:net,port,
> hash:ip,port,net, hash:net,iface) rescan with an element already masked
> to the widest prefix tried, so a lookup can wrongly match a more specific
> entry at the network base address (e.g. 10.200.3.4 matching 10.0.0.0/29).
> Restore the element before rescanning.

Is this a real world encountered bug or an LLM finding?

> +	/* mtype_data_netmask() masks @d in place, undo it before rescanning */
> +	*d = orig;
> +	goto retry;

Why do we need to do this instead of not masking @d in place to begin
with?

-mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
+mtype_test_cidrs(struct ip_set *set, const struct mtype_elem *orig,

+       struct mtype_elem *data, d;
        struct hbucket *n;
-       struct mtype_elem *data;

 retry:
+       d = *orig;


... and fix up all reset calls:

 static void
 hash_netportnet6_data_reset_elem(struct hash_netportnet6_elem *elem,
-                                struct hash_netportnet6_elem *orig)
+                                const struct hash_netportnet6_elem *orig)

... much cleaner and less error prone, I think.
