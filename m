Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D498A223323
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892335; cv=none; b=TD9KGJAZU5+sQl8Exkxq0z5+YKRJusjqMXI82rlxwybol3Jh6TEJLRKIbb5V+rs7LC2FyOcooXbgFCj5K8LdlShaE3B4y5E8YRou930u/4sR90vTWyGi0b9C6vi9BaI1Lem9qe2N+Ag4IStIXpiS+2P/mPXef1dcTS1ehfNL2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892335; c=relaxed/simple;
	bh=G9TLnV63HPr7gyUAckxpvQQXdLiYwgEMJGATGI7zT1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRsA7uwazLAO1ffwFOUYaqXIyWMllVdp6RZQUHa+fNy/CI+u9abu+5s8n7QKMl77fYP4jzxYQw8arOEf05+27ZqeRokzH3KoG+Gwe4tWvAbeNk6iS48ZK9S6ueJeDF72d8PhJs2qoycxMvH6MKnoqc77BdBekA1JgO+49GCh5Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7836560218; Tue, 16 Dec 2025 14:38:44 +0100 (CET)
Date: Tue, 16 Dec 2025 14:38:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Message-ID: <aUFgyOkfh8e8vx_Z@strlen.de>
References: <20251216122449.30116-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216122449.30116-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> After the optimization to only perform one GC per jiffy, a new problem
> was introduced. If more than 8 new connections are tracked per jiffy the
> list won't be cleaned up fast enough possibly reaching the limit
> wrongly.
> 
> In order to prevent this issue, increase the clean up limit to 64
> connections so it is easier for conncount to keep up with the new
> connections tracked per jiffy rate.

But that doesn't solve the issue, no?
Now its the same as before, just with 64 instead of 8.

I think that more work is needed.

>  /* we will save the tuples of all connections we care about */
>  struct nf_conncount_tuple {
> @@ -187,7 +188,7 @@ static int __nf_conncount_add(struct net *net,
>  
>  	/* check the saved connections */
>  	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
> -		if (collect > CONNCOUNT_GC_MAX_NODES)
> +		if (collect > CONNCOUNT_GC_MAX_COLLECT)
>  			break;

I see several options.
One idea that comes to mind:

1. In nf_conncount_list, add "unsigned int scanned".
2. in __nf_conncount_add, move alive elements to the tail.
3. For each alive element, increment ->scanned.
4. break if scanned >= list->count.
5. only set last_gc if "->scanned >= list->count" (and set scanned to 0).

Before this only-one-gc-run-per-jiffy we always collected for each new
tracked entry, and hence we never had the "fills up" problem.

Maybe it would be possible to also apply this scheme to gc_list()
helper.
