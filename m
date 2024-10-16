Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BF920C49A
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729095049; cv=none; b=lG694vMnbFThnNM8j/huSSBK7sanpL9/zNBVo4FNKciM1NfuJNm8PW+ACgXXX0Sh1hrj04goL0LZ3KY85P4tSVlxCohIT5u7fZeuo559WU3eWaxCfDmCMuwFBVlcPcsvdTdFNy/9yLV2G+I4roHBU3gMUm52aNrLv8DJC8tExVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729095049; c=relaxed/simple;
	bh=+WVIMriXJ8v9NyY3X9w3C3slOdHWD7N8gAUD4YW5ajw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fF8xv0PtBIaOTFqNVT6NjXhTp+G+6PcejnIS7UQKnlTi4Kks9KBUs1KDp4zXySpK44c/TI6LcpkASA9FAFjcotNfKXs9fCNEKRGepliFiCy+YX1+4bGgrgRMYjnDJUcHyoJ7t+NEetNeKQ7+Bxhv2X1s9Zg9KBEIo9xdOD5I3Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t16bk-0002vT-3Y; Wed, 16 Oct 2024 18:10:44 +0200
Date: Wed, 16 Oct 2024 18:10:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <20241016161044.GC6576@breakpoint.cc>
References: <20241016131917.17193-1-fw@strlen.de>
 <Zw_PY7MXqNDOWE71@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw_PY7MXqNDOWE71@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This is bad, but I do not know if we can change things to make
> > nft_audit NOT do that.  Hence add a new workaround patch that
> > inflates the length based on the number of set elements in the
> > container structure.
> 
> It actually shows the number of entries that have been updated, right?
> 
> Before this series, there was a 1:1 mapping between transaction and
> objects so it was easier to infer it from the number of transaction
> objects.

Yes, but... for element add (but not create), we used to not do anything
(no-op), so we did not allocate a new transaction and pretend request
did not exist.

Now we can enter update path, so we do allocate a transaction, hence,
audit record changes.

What if we add an internal special-case 'flush' op in the future?
It will break, and the workaround added in this series needs to be
extended.

Same for an other change that could elide a transaction request, or,
add expand something to multiple ones (as flush currently does).

Its doesn't *break* audit, but it changes the output.
