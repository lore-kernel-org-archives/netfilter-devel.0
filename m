Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821E2DEA71
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 11:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257299; cv=none; b=L0WdLrIUr3oE6Y984id9eYaXwdq4ZvL9rspUqHwU5j/P1djLulBh6nKCqU8XadsdF0neKO0ljjQACoDbdtjymlA9K7iQDu8ZAJcjNmAC3MiruvuzlynSgiEfH8fclSB+hOVT6rkfh7XFBkcbg3/RdBV8oot55Ps2v6tQ1SG+Rx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257299; c=relaxed/simple;
	bh=uxs7c/cD5pPoR/1scneHbyq2NNb8+wr5/dMWpV0e86I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuAJu48Lca0VjBXE7pZiqFmg3/Xi2uzfHAWWqb17uRMVsi3eZSf2Qq8qqlcRzGu1WQsTj8koDUwYMjaanIk6XOIsf6rkoK9krFqVUenAJnFJVKoFFVFPhksvgM/vLojMLwhk7HEY1ld8aONImkc3APHZVtWDc5GNe+l1qXI8T7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 23407603B8; Tue,  4 Nov 2025 12:54:55 +0100 (CET)
Date: Tue, 4 Nov 2025 12:54:55 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org
Subject: Re: [PATCH nf v3] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
Message-ID: <aQnpj-3ZfZUVpIj0@strlen.de>
References: <20251031130837.8806-1-fmancera@suse.de>
 <aQng8WtxoVMaABLs@strlen.de>
 <08bd5858-9a07-4da8-9d31-d685cbf0eea4@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08bd5858-9a07-4da8-9d31-d685cbf0eea4@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > The net, tuple_ptr, and zone argument would be obsoleted and
> > replaced with nf_conn *ct arg.
> > 
> > This allows the nf_conncount internals to always skip the
> > insertion for !confirmed case, and the existing suppression
> > for same-jiffy collect could remain in place as well.
> > 
> > Its more work but since this has been broken forever I don't
> > think we need a urgent/small fix for this.
> 
> Fair enough, I will handle this in a bigger patch aimed for nf-next 
> then. I do not think we should touch the API on 6.18 given we are at rc4 
> already.

Makes sense to me.  Thanks Fernando.
