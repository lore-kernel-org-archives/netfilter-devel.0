Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3021D5142;
	Thu, 17 Oct 2024 22:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729205631; cv=none; b=P0KEhLBz6w8CBOgAEiM47yPJ3Wkqf2CV1N6c8VXWCw6istridd8YNsWthadDbT7EpQCAYZCpgYYRAhXYyVC0xFTQrew2dcMHu2cSjRCgG/wu817juHFLfUY4Qf6ukZ2NmC4SPxkLaAz/is4dKlv8K+YrdXfAboSiESZWID4gVOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729205631; c=relaxed/simple;
	bh=LhdvZpxNLLpfSmVtoOjyngMU5RMwJVe0sTtbH6Uxp1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6BTs1LJ8LnbjThdDhZDbIWLjlSVuJaHRuhDtHlUhQXm9qC0GV/Mmj0tor+KV7bGUbMFmwSk7eqc3vA7VV4ISaLo404mAeVkgtOvXnoSWR8RNKA8sXfg7YYTX+nI90WYFi7xqztrcuyK4QcvozoInnp9GId0ztFQET7tTGAy8hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44738 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t1ZNC-00GDho-S3; Fri, 18 Oct 2024 00:53:43 +0200
Date: Fri, 18 Oct 2024 00:53:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	rgb@redhat.com, audit@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <ZxGVch7AsOT5Ef_s@calendula>
References: <20241016131917.17193-1-fw@strlen.de>
 <Zw_PY7MXqNDOWE71@calendula>
 <20241016161044.GC6576@breakpoint.cc>
 <ZxE6H03jhdp3gONB@calendula>
 <CAHC9VhQxp4_qhuuKip7qP_Jz-ysv1RZ1o83iARCRP7Psh_dBNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHC9VhQxp4_qhuuKip7qP_Jz-ysv1RZ1o83iARCRP7Psh_dBNQ@mail.gmail.com>
X-Spam-Score: -1.9 (-)

On Thu, Oct 17, 2024 at 03:33:14PM -0400, Paul Moore wrote:
> > On Wed, Oct 16, 2024 at 06:10:44PM +0200, Florian Westphal wrote:
> For those of us joining the conversation late, can you provide a quick
> summary of what you want to change in audit and why?

Florian said:

"I failed to realize that nft_audit leaks one implementation detail
to userspace: the length of the transaction log."

        table=t1 family=2 entries=4 op=nft_register_set

He is referring to the 'entries' key.

So far, every object gets one transaction, but now batching several
objects in one transaction is possible.

We have been discussing what the expected semantics for this audit log
key is:

- If this is the transaction log length, then the internal update of the
  transaction logic results in a smaller number of 'entries' in the
  audit log.
- If 'entries' refers to the number of "affected" objects by this
  operation, then this means we have to carry a "workaround" in
  the kernel.

This is because:

1) Element updates are now supported, this currently handles it as a
   _REGISTER operation according to enum audit_nfcfgop. This changed
   the semantics of the add command, now it is "add if it does not exist,
   otherwise update what it already exists". Before, updates where simply
   elided (not counted by 'entries' key) because they were not supported.
   That is, 'entries' now tell how many set element has been added OR
   updated. I think this is fine, this is consistent with chain updates
   where 'entries' also report added OR updated chains. The difference
   is that old kernel do not count updates (because they are elided).

2) There is ongoing work to add more internal transaction batching, ie.
   use one single transaction for several elements. This requires a
   special case to bump the 'entries' key to add the elements that the
   transaction batch contains, see:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20241016131917.17193-4-fw@strlen.de/

   There is a nft_audit.sh selftest and Florian thinks this is a
   "workaround" patch only to make this test happy, because 'entries'
   refers to the transaction log length (which is now smaller given the
   internal transaction batching approach to accumulate several elements
   is used).
