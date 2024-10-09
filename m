Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5A417A583
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509101; cv=none; b=fOqVBO/Z2lZhxKcp7EgJdv/wutIPAY3kK+bASScEYHeo1lMWygU3cyQbPBd/wH/3DI6TJ/ikiXba7jDcJ6nKsMDDFkdRnpHKYF4oDN98TCxRdW138bWnHIuq2CEaSaKcmqw+hvY3BcmHFX3NsrdkOUDC1T22g1szrgwh+Dr4/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509101; c=relaxed/simple;
	bh=GDa2WFcAH2/6deYggu9GU3azvMs+b5FTmlvqztsQUV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/UIB62jD3dQfoRCcH03Z2rw3PitoieoncnR5yrY3rmOs9Qmd2raU3/5t2ia6t1fgc6nCPy+tQocSUucjXMD23ZLVEJyCHwr5VLij0c7lvh2LZGenZbJ6+S5RMnXNgg+ey5vJR5vTFsSchvRTmiA+Jgn64vNzqjHLh8klMgiO3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56586 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1syeAp-00Bx7d-0d; Wed, 09 Oct 2024 23:24:49 +0200
Date: Wed, 9 Oct 2024 23:24:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: Re: [PATCH nf v3] netfilter: xtables: avoid NFPROTO_UNSPEC where
 needed
Message-ID: <Zwb0ngWN7XSPs6lj@calendula>
References: <20241007092819.4489-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241007092819.4489-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

On Mon, Oct 07, 2024 at 11:28:16AM +0200, Florian Westphal wrote:
> syzbot managed to call xt_cluster match via ebtables:
> 
>  WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780
>  [..]
>  ebt_do_table+0x174b/0x2a40
> 
> Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
> processing.  As this is only useful to restrict locally terminating
> TCP/UDP traffic, register this for ipv4 and ipv6 family only.
> 
> Pablo points out that this is a general issue, direct users of the
> set/getsockopt interface can call into targets/matches that were only
> intended for use with ip(6)tables.
> 
> Check all UNSPEC matches and targets for similar issues:
> 
> - matches and targets are fine except if they assume skb_network_header()
>   is valid -- this is only true when called from inet layer: ip(6) stack
>   pulls the ip/ipv6 header into linear data area.
> - targets that return XT_CONTINUE or other xtables verdicts must be
>   restricted too, they are incompatbile with the ebtables traverser, e.g.
>   EBT_CONTINUE is a completely different value than XT_CONTINUE.
> 
> Most matches/targets are changed to register for NFPROTO_IPV4/IPV6, as
> they are provided for use by ip(6)tables.
> 
> The MARK target is also used by arptables, so register for NFPROTO_ARP too.
> 
> This change passes the selftests in iptables.git.

Applied. I editted and appended this for the connbyte chunk:

"While at it, bail out if connbytes fails to enable the corresponding
conntrack family."
