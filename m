Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1160E18EAB
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 22:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144509; cv=none; b=W7o15xAOYq9g+Vwj+7emf5OG7yYruA++v0Fg+SIRZX/rtSUq077ztf7XVM/+cu7LU0/3vMbwxw/NDTtIy/GUZysPc787WbjdlLJfdGMJtpRKC5TJBwBRg6LDFxNLQbBjY5EUjYzRdTyEH+hDzVEyIftHLP8vCsNf05nmvvXEXCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144509; c=relaxed/simple;
	bh=aAV0Y0ULm+JfplEu68AOpPOqlET/SoB+/cUoEHCjkSE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzVebPu/n3nIMPHS1n9Ix1eybUVrQdJzseAGSvhkIERg7JeaYjfXhwHGJpQfttq2PX8UM8rbWrdqw+oZOMQvUGjsV+X3xskT60N0M0bPTpz7JyZWtOEarGDzIB3BVm5UtU6rE4pWOAda1SDkLXcDYbvdOBz9i0Nodh7ncfFDMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46404 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sH9s6-002vCz-Pd
	for netfilter-devel@vger.kernel.org; Wed, 12 Jun 2024 00:21:44 +0200
Date: Wed, 12 Jun 2024 00:21:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] Stop a memory leak in nfq_close
Message-ID: <ZmjN9Z-C7r7vzakH@calendula>
References: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
 <ZmCB-walvbM9SnX7@calendula>
 <Zme6j5eOm8thplwY@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zme6j5eOm8thplwY@slk15.local.net>
X-Spam-Score: -1.6 (-)

On Tue, Jun 11, 2024 at 12:46:39PM +1000, Duncan Roe wrote:
> Hi Pablo,
> 
> On Wed, Jun 05, 2024 at 05:19:23PM +0200, Pablo Neira Ayuso wrote:
> > Hi Duncan,
> >
> > On Tue, May 07, 2024 at 09:17:19AM +1000, Duncan Roe wrote:
> > > 0c5e5fb introduced struct nfqnl_q_handle *qh_list which can point to
> > > dynamically acquired memory. Without this patch, that memory is not freed.
> >
> > Indeed.
> >
> > Looking at the example available at utils, I can see this assumes
> > that:
> >
> >         nfq_destroy_queue(qh);
> >
> > needs to be called.
> >
> > qh->data can be also set to heap structure, in that case this would leak too.
> >
> > It seems nfq_destroy_queue() needs to be called before nfq_close() by design.
> 
> Oh sorry, I missed that. Anyone starting with the example available at utils as
> a template will be OK then.
> But someone carefully checking each line of code might do a
> `man nfq_destroy_queue` and see:
>        Removes the binding for the specified queue handle. This call also
>        unbind from the nfqueue handler, so you don't have to call
>        nfq_unbind_pf.
> And on then doing `man nfq_unbind_pf` that person would see:
>        Unbinds the given queue connection handle from processing packets
>        belonging to the given protocol family.
> 
>        This call is obsolete, Linux kernels from 3.8 onwards ignore it.
> And might draw the conclusion that the call to nfq_destroy_queue is unnecessary,
> especially if planning to call exit after calling nfq_close.

Then, update documentation.

> > Probably add:
> >
> >         assert(h->qh_list == NULL);
> 
> I don't like that. It would be the first assert() in libnetfilter_queue.
> libnfnetlink is peppered with asserts: I removed them in the replacement
> libmnl-using code because libmnl doesn't have them. Have you looked at the v2
> patches BTW? I'd really appreciate some feedback.
>
> >
> > at the top of nfq_close() instead to give a chance to users of this to
> > fix their code in case they are leaking qh?
> 
> It's not as important to call nfq_destroy_queue as it used to be. Why not just
> free the memory?

It is not possible to know if qh->data is stored in the bss, onstack
or the heap, it is up to the user to decide this.

> I could send a v2 with the Fixes: tag removed and a commit
> message that mentions the change is a backstop in case nfq_destroy_queue was not
> called.
> 
> Either way, `man nfq_destroy_queue` could be improved e.g.:
>        Removes the binding for the specified queue handle. This call also
>        releases associated internal memory.
> While being about it, how about removing the obsolete code snippet at the
> head of Library initialisation (that details calls to nfq_[un]bind_pf)?
> Perhaps a separate doc: patch?

I'd suggest to address this by updating documentation.

Thanks.
