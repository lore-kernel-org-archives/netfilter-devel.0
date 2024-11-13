Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193401FB3D4
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731493150; cv=none; b=lc21EbNDEGNfJ6ndUsBTV2KvTXkaxWgFPIEjEZcs6Th+WTBZzwX3aB3Hw9kOnILvGimGCJDDF/S/TKpwDFLgsIE/6Qz5Ru+NzDYchxyACJ/hwbwHmZ3+/A+ky7y92J1sF6P8U2chjenFWMn1z3rAGkE92Q1Rdct11wsyL/TCTBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731493150; c=relaxed/simple;
	bh=EjoMYsMwYCQBKD7CxrdLoCzg9pI13tWyWORpkmA+/hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HetnSb+zFVO2H19ujC2pFEFawFwpyqwqdFIfKufVJU/ZGYd7vVkzhmWh5qtnsdA7GZWOkgcO37lXIuT6Q8v8bc6hLU/9Iunl+n6yHoL15L4okHYFdlUciORwX709Bq5eDsQmYFw0VcI7CdXUwWd2VzniDhi5Hd9i/JFMaCotono=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36830 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBASk-00DfGe-Gq; Wed, 13 Nov 2024 11:19:04 +0100
Date: Wed, 13 Nov 2024 11:19:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <ZzR9FTrhjt08QoKG@calendula>
References: <20241107174415.4690-1-fw@strlen.de>
 <ZzOhkNh58vkHW62c@calendula>
 <20241112204436.GA32766@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241112204436.GA32766@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Nov 12, 2024 at 09:44:36PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >nftables audit log format unfortunately leaks an implementation detail, the
> > >transaction log size, to userspace:
> > >
> > >    table=t1 family=2 entries=4 op=nft_register_set
> > >                      ~~~~~~~~~
> > >
> > >This 'entries' key is the number of transactions that will be applied.
> > 
> > To my understanding, entries= is the number of entries that are either
> > added or updated in this transaction.
> > 
> > Before this patch, there was a 1:1 mapping between transaction and
> > elements, now this is not the case anymore.
> > 
> > If entries= exposes only the number of transactions, then this becomes
> > useless to userspace?
> 
> Hmm, I would need to know what this is supposed to be.
> Its not going to be the same in either case,
> iptables-legacy -A ... vs iptables-nft -A won't result in same
> entries due to the whole-table-replace paradigm and introduction
> of "update" mechanism also changes entries count.

Right, there is a change between -legacy and -nft regarding audit.

> I think its fine now, but please feel free to rewrite the commit
> message if you think its needed.

Thanks, I will make an edit.
