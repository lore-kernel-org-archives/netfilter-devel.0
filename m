Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A179D26D4DA
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 19:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755630646; cv=none; b=DE4ygqWCtrpcOhcookax07vCurhJUKazLgeFybgoTMOmTxDOctrTZBksD6vSrJN3JlPszqZ95WGJSX5GyxpQ6DM89twU8a4WxTYELFqqmXtNXlDH31ggPYQVMgwQXUbhaftBmVFccCIqshofu9FTzYwiHWTNjrZs5+yWtlweLJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755630646; c=relaxed/simple;
	bh=P+rNgaM6W0ecl6zMj5Ekxvfh1Ir1jSElGXHvXtZAC+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lR/r4AyHZ7MIYmhj0tgoS7xjFkR5aZYO4A9kALH93rseo4Jx8gPM0eXSiDokGuKt3ItoRdqneZCeeA70PLuApJ1hlnkrEPcBCFmx+GW4llq2SuY0xtHYRhuJ0EYYFc40mROxPwNIRzQ7wwiK6chJ2S28ZhxvIMMI8r1lONgtfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADD8B602AA; Tue, 19 Aug 2025 21:10:42 +0200 (CEST)
Date: Tue, 19 Aug 2025 21:10:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aKTMMmGdaURKNLou@strlen.de>
References: <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <aIikwxU686KFto35@calendula>
 <aIiyVnDlbDTMRqB-@strlen.de>
 <aIpFWePr6BfCuKgo@calendula>
 <aIpJur3wIzswyaAe@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIpJur3wIzswyaAe@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > For the commit phase, I suggest to add a list of dying elements to the
> > transaction object. After unlinking the element from the (internal)
> > set data structure, add it to this transaction dying list so it
> > remains reachable to be released after the rcu grace period.
> 
> Thats what I meant by 'stick a pointer into struct nft_set_ext'.
> Its awkward but I should be able to get the priv pointer back
> by doing the inverse of nft_set_elem_ext().
> 
> The cleaner solution would be to turn nft_elem_priv into a
> 'nft_elem_common', place a hlist_node into that and then
> use container_of().  But its too much code churn for my
> liking.
> 
> So I'll extend each set element with a pointer and
> add a removed_elements hlist_head to struct nft_trans_elem.
> 
> The transacion id isn't needed I think once that list exist:
> it provides the needed info to undo previous operations
> without the need to walk the set again.
> 
> We can probably even rework struct nft_trans_elem to always use
> this pointer, even for inserts, and only use the 
> 
> struct nft_trans_one_elem       elems[]
> 
> member for elements that we update (no add or removal).
> But thats something for a later time.

This doesn't work.
NEWSETELEM cannot (re)use the same list node as DELSETELEM.

Reason is that a set flush will also flush elements
added in the same batch.

But if NEWSETELEM uses a list (instead of priv pointer
as we do now), then at the time of the set flush, the
encountered element is already on a NEWSETELEM trans_elem list.

I'll try doing:

 struct nft_set_ext {
        u8      genmask;
        u8      offset[NFT_SET_EXT_NUM];
+       struct llist_node trans_list_new;
+       struct llist_node trans_list_del;
        char    data[];

to avoid this problem.
