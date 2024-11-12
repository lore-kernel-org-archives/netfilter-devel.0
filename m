Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68513214434
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436951; cv=none; b=hy8wHKyfolcKIXtq/JGIpUDBAck1wyukOgXeep4YnoNcGexBfruWC3upDC+XwfDmvnSWeUFzcTGA/5ap0fu1y5qhR9Kc2mHC2qVsYz5iWwx2Efi4UrVS3RIp6TdVIgVK7FfkDA1nfdT0FBjK0fxtkcVjRu9OiyNcoIFV4RqwHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436951; c=relaxed/simple;
	bh=RSOZuEV9d1PevUEiqKkONfvI5bMB/b8Y483qzoifPiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTOC7SN2GNu6NEbdXUpU/OpIE3s/uUMDnfdMWpGP4RtKT3FcRItH/EUoND7uN/66YxCxf/BZ7vDDwS+Ek56RfYB1cVhkE/sOUOVohzQogrzr5c6OjEHG74mB+LgOHiQKyOo6x/nA6xkR69m0Dt089vj5aXDPTpTUDKEPbBiwqaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=45520 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tAvqL-009Ooc-3Y; Tue, 12 Nov 2024 19:42:27 +0100
Date: Tue, 12 Nov 2024 19:42:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <ZzOhkNh58vkHW62c@calendula>
References: <20241107174415.4690-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241107174415.4690-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

This series looks good to me.

Regarding 3/5, I don't see any fix or anything silly in this.

>nftables audit log format unfortunately leaks an implementation detail, the
>transaction log size, to userspace:
>
>    table=t1 family=2 entries=4 op=nft_register_set
>                      ~~~~~~~~~
>
>This 'entries' key is the number of transactions that will be applied.

To my understanding, entries= is the number of entries that are either
added or updated in this transaction.

Before this patch, there was a 1:1 mapping between transaction and
elements, now this is not the case anymore.

If entries= exposes only the number of transactions, then this becomes
useless to userspace?

In iptables, it shows the number of entries in the table after the
update.
