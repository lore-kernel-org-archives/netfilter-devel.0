Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BCF219E36
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731444282; cv=none; b=B6Dwy6oGAcow4CizMfHoGYcVewoCGGzww+2YnKchMrUtOaeWUxPSF9WuO+VjI2S0wTTYkplRYRPQ7rfGC/qqIbTaGR3Km2PA177pbsa7TNEXqFwUPQ/MrxkHZYl/r9RZekg7r3ZdtIDl5Ugzm+3SPsIB2u2RSuduxR6fmAyA1OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731444282; c=relaxed/simple;
	bh=LQUCs00ULI/5sc7uNAZkOkHvM3q31tvpP3DWGYkWTxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPh7chQJe9f0pyDKmEkyrO5gnqz/dq1hZ1xdwWJHKK9yKPuV28DAjS3fIgobVUGweH2xdCSu0AT6OByjpBSrgon39YazMD5b9krSoaiygS/xcXbozhJ2nOpAfb31c85w4dEasE6WDtnHaPymGfPxLBh5Q/nV/niQ8FkfonJNz/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tAxka-000067-3W; Tue, 12 Nov 2024 21:44:36 +0100
Date: Tue, 12 Nov 2024 21:44:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <20241112204436.GA32766@breakpoint.cc>
References: <20241107174415.4690-1-fw@strlen.de>
 <ZzOhkNh58vkHW62c@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzOhkNh58vkHW62c@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >nftables audit log format unfortunately leaks an implementation detail, the
> >transaction log size, to userspace:
> >
> >    table=t1 family=2 entries=4 op=nft_register_set
> >                      ~~~~~~~~~
> >
> >This 'entries' key is the number of transactions that will be applied.
> 
> To my understanding, entries= is the number of entries that are either
> added or updated in this transaction.
> 
> Before this patch, there was a 1:1 mapping between transaction and
> elements, now this is not the case anymore.
> 
> If entries= exposes only the number of transactions, then this becomes
> useless to userspace?

Hmm, I would need to know what this is supposed to be.
Its not going to be the same in either case,
iptables-legacy -A ... vs iptables-nft -A won't result in same
entries due to the whole-table-replace paradigm and introduction
of "update" mechanism also changes entries count.

I think its fine now, but please feel free to rewrite the commit
message if you think its needed.
