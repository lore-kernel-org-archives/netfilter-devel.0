Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CABC3A874B
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 21:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954000; cv=none; b=oYLj8J7ewJcbQbmb0cbYxm84LNX8Tn5YiqhLsuJqN/GBd1ugJ4LHTYYFfRfTRqQlJJTrC6egOln5P+cfQgqmjJmJLUivAju5UoBWuBJBIIjyJ/DebKMnSUCTBnZ97w1r8/SOVH8RshmDBODE/QCUp1decUi7Qj66XXkVHoAJUSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954000; c=relaxed/simple;
	bh=9jXVmbTKI0DeepACbzER2I3tWzHht9uHkxlOZtOentY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pX11UbJYcPUNaBGZNq1ZLhh8091qcn8N4GT3n7oQjB4IDojy2M5CJR2igHVvcmVU/Twy012dZC7/sj/F0EjiakmzWp34cciAoAe383disQ7Hw45ztSFew00fJMOjJ+2+74Y4wUiWQOZPxKEU5r+irjWgl/GjZmbzONA0rsgrXb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B67CF6047A; Mon, 08 Jun 2026 23:26:35 +0200 (CEST)
Date: Mon, 8 Jun 2026 23:26:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: check NULL when calling
 nf_ct_ext_find()
Message-ID: <aiczgrv5J-m-7jo8@strlen.de>
References: <20260608212120.68828-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608212120.68828-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> nf_ct_ext_find() might return NULL since ct extensions may be declared
> stale because of object dependencies or modules that are going away.
> 
> When helper is removed, nf_ct_iterate_destroy() unhelps the conntrack
> entries. Then, the nf_ct_ext_find() might return NULL if the extension
> is stale for unconfirmed conntracks if the genid validation fails.
> 
> Add the null check to:
> 
> - nfct_help()
> - nfct_help_data()
> - nfct_seqadj()
> 
> that call this function since packet path could be walking over helper
> while it is being removed.
> 
> While at it, fetch ct helper area in nf_ct_expect_related_report() only
> once and pass it on to other ancilliary functions. Replace WARN_ON()
> by WARN_ON_ONCE() in nf_ct_unlink_expect_report().
> 
> Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")

I'm not sure this tag is correct.

The genid checks are only for unconfirmed entries, not in hash.

nfct_help() and nfct_help_data() can return NULL as you say, but
I don't see how this relates to the above commit either.

That said, I agree with the patch.
