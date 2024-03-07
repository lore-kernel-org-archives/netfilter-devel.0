Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8C31E878
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709826778; cv=none; b=Fv8bhOuTt+CkPZdMNf0rUD+yiUBQziLbDeMsW7pL0T8aMWhVKxXv9D5ANm+pd8eOa9njksjums7aSBIWDDxbrtZV51Sc8Kb3v36FH8571OJryVwjhGMN48x7481t64+7Cge6NqEuK9rrBNQ7QEf/v9Wu+k3WAx1sJPrsuTfCHDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709826778; c=relaxed/simple;
	bh=cfTXgJtQFy0uYz9FUG6mbIWrosW13Loq3QD2zt7Xqok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/NBUHZ1D4By4B2Ht6ZdJiPN2Uk5EdrDuoe3SXOz5RHjm5+xIGIUKqUnwZJSrH1JGrzxlr2KrzexCS3kqs26/h1fOgiJR7q2MUtkBhZCfE0f+ENuIHpCY9tFpfsVjLBRqce3UXz88TxRrrAcZBhoXskdhQ10eCn7CnGwMyOwCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WHDT6EuD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WHDT6EuD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+FR+Kim/LuolH/lUaSA0HKHvXziOYUNH3V1v4YFjRik=; b=WHDT6EuDNuKcrzErHAcexBhG4z
	zZkn6Sj8morK4D4CxlU9Cu1AS8r5KaoEl7DKG6N1d7St+Nc/OVBvfoRK0sUQEKRGxwnPaXIWUm6H5
	TlWWiUwKAGYEPgHgzMTsGpweTRh/bC1RjYu0Z53z9aKdNdnRXxcWnheyCYyUYkkh2+sYiut3lpAcZ
	xI/g06/wkVlzcmKw1xh8m12HFAO30+MRBJ8s/U94+X38p7SRnx3O11LNp/pUGCBWBFJvkE80d4duY
	FwwTuagYR8SdFsAFpjWLL8EGivkPi1pGE4twITF2A/vQHbR1i4lR3V41tb6KvwcsMC/fpPa0RZwh3
	Qa1ut/TA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riG3B-0000000073S-3IGS;
	Thu, 07 Mar 2024 16:52:53 +0100
Date: Thu, 7 Mar 2024 16:52:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Message-ID: <Zeni1X75HHJYpu_l@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240307122640.29507-1-fw@strlen.de>
 <20240307122640.29507-3-fw@strlen.de>
 <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
 <20240307151005.GM4420@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307151005.GM4420@breakpoint.cc>

On Thu, Mar 07, 2024 at 04:10:05PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Problem is that the json input parser does cmd_add at the earliest opportunity.
> > > 
> > > For a simple input file defining a table, set, set element and chain, we get
> > > following transaction:
> > >  * add table
> > >  * add set
> > >  * add setelem
> > >  * add chain
> > > 
> > > This is rejected by the kernel, because the set element references a chain
> > > that does (not yet) exist.
> > > 
> > > Normal input parser only allocates a CMD_ADD request for the table.
> > > 
> > > Rest of the transactional commands are created much later, via nft_cmd_expand(),
> > > which walks "struct table" and then creates the needed CMD_ADD for the objects
> > > owned by that table.
> > 
> > JSON parser simply does not support nested syntax, like, for instance:
> 
> You mean, WONTFIX? Fine with me.

Not quite, I see the problem you're trying to solve in patch 5. Sorting
elements in the JSON "nftables" array properly for later insertion may
become a non-trivial task given how maps and rules may refer to chains.

So IIUC, JSON parser will now collapse all new ruleset items into a tree
and use the existing nft_cmd_expand() to split things up again. This may
impose significant overhead depending on input data (bogus/OpenShift use
cases involving many chains maybe) on one hand, on the other might allow
for overhead elimination in other cases (e.g. long lists of 'add
element' commands for different sets in alternating fashion).

We may want to do this for standard syntax as well if the benefits
outweigh the downsides. Thus generalize the JSON-specific helpers you
wrote for use within bison parser, too?

An alternative might be to reorder code in table_print_json_full(),
copying what nft_cmd_expand() does for CMD_OBJ_TABLE. AIUI, it should
solve the current issue of failing 'nft -j list ruleset | nft -j -f -'
for special cases.

Cheers, Phil
