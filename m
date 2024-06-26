Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED7148FE3
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719401341; cv=none; b=h+dh4xQ8qoVYP9P75oFIeDlcWCwHjcMPbxdAhCecNyI+QWDXSNQvbdeII9puAl5kiH+Z8W9zLTQw3qYReYoWIPHJm0u5lRb69v2pFQ56iaid0M7fVFjE5P8+7ysFJ5cK5StQ55+VBibI0IDiemOWO5YG4W01MI13U4ck8PO7Tvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719401341; c=relaxed/simple;
	bh=BPgWUvQ3HvIh4xQKkozf7AwRSo4gPu5P2+hms5kRiJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU9KCpWel6b58wc48vJ0j0qQ8bM2U3SiKpRA5JqZhWqrzVCkwc0sb2SJ0p3nSi6SeOvdwX+G5p866Uh3PrBVbgickZRZWoBTqu1mPQbTD7QV4syvPEXJ68BD7J5woaObOfuzWbNZQG8cJbTGBz02ew1WVN8yAuPLgjNNaigF4Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=49734 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMQpY-007rwg-Rj; Wed, 26 Jun 2024 13:28:55 +0200
Date: Wed, 26 Jun 2024 13:28:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <Znv7cxwEACteC1iG@calendula>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-3-fw@strlen.de>
 <ZnnGFCF_BTe4YN-V@calendula>
 <20240624211852.GA14597@breakpoint.cc>
 <ZnsRRV4QRl_aUohR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnsRRV4QRl_aUohR@calendula>
X-Spam-Score: -1.9 (-)

On Tue, Jun 25, 2024 at 08:49:45PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 24, 2024 at 11:18:52PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> > > I can add BUILD_BUG_ON for all nft_trans_* objects to check that
> > > nft_trans always comes first (ie. this comes at offset 0 in this
> > > structure).
> > 
> > Sounds good, thanks!
> 
> OK, I have pushed out the patches with the manglings I reported here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/log/?h=under-review
> 
> I am going to collect remaining pending patches for nf-next and
> prepare for PR.

For the record, this is now in the netfilter/nf-next tree. Thanks.
