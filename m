Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C79A2A
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 02:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718074006; cv=none; b=Q1p3frGUNdZ14oGt9Ch/+UKe7OvUBX0Mao5v7PvIWeKaba8Yu/n9uqZ5o6GH/TKJG8eaV809hFp2aQFcZYHhQ3LAzwSz+XWsD8p3c8cQmHwFaKgj8npCU08bDLkAcW658w3DuQ0QYMgqOrr41+WZBwl+Y01uugRc2ZVbuZk3hVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718074006; c=relaxed/simple;
	bh=lEPCmjScgxCVlG+jzvifm1Ea6XgV4jZRIH3Pukn1Oc0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaB7VnSL9tmHUaFD7XhYo6RVIis4xRRJwjYZuVczJQRFgftSqkbTTYfhSVC7M5HppEgu7Qi0e/F1ITDPiZ47Tm56bujyBS5mtBLyjDtzfB+CGTCMMbg0us118mmo+Y6FKgfEzDUU4dmotzHaoBhLrHKSqZpj2S9U0VNHhFxDS5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+vfQvtx; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+vfQvtx"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7042882e741so1989821b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2024 19:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718074004; x=1718678804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P3sbM3lsiUmoQJvULXr4ERDjGKl0DsipD0F/BYlJ1qE=;
        b=T+vfQvtxtj7Vqjy8rOnLzH0mN0G6lDgfsPM1Sb72mHAwZjzmC82vVGrHQmD1K/uIRJ
         OvUJcR0VYZ/2tuzELFsi6MitKgqJmVgnrFoUpB2eEuYfNZKl/2ljHIBijadnwTe/0+nr
         +5YBnswk9rLFgeWNuoS48QCixZ9KbFKM/V5KtQprSSLEl5TckcxfRNzPqQuHBDIBT+zy
         NQYvQqnQON9XKZ0Krc85lFckDu0gQsucX9IYvmiGmBHVVryOtzkawwUpYgGAz/XOY5ur
         jBtfxUgjE5tcuHVzDkr+jRrfi/kkgOhCOKFkTkN2v3ZniHotSMoGKTb+n5Vdw+0ZfpyF
         QZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718074004; x=1718678804;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P3sbM3lsiUmoQJvULXr4ERDjGKl0DsipD0F/BYlJ1qE=;
        b=fUXe1qTBd3+6mKWIoJKNXsEj53ayY8dJUOgCEi9BvybuxYWXcHioS9OJfGkkEtHwnY
         kgf92D1sgbagdSe8Z7quifeMrwHsO1HB6EoWcZg5e6pKi736SuG9BKpqRWjkkS5uazC2
         cSXJBWPU73MrERdK/QTDrC77BudsujkHOYNf9oOrJ8j9ybEW+HGKntFG5w/W3UKms9He
         1QLsVqtmWKh9wXgZC9Q/KSObe+cj8B8TWgYS/VIKVlBjdmYX81CAgJZ7/99mr0UfA0eR
         kusbrWDhCEyFjrqnN2Ypi3jqVCqXdN8+qAnDOkXSnvgN8BBNZvBPvrXutyE9/fl30pcF
         4asg==
X-Gm-Message-State: AOJu0Yw4NBz6vWSB0WjWmHYxweSsS5PohNCmxYoA6V60D6cXiZJZSwly
	84YI8eizAoKNTUUpTRIfnzo0/NAHKpHo+92G04dSXxofNiKYRI6+Z31FPg==
X-Google-Smtp-Source: AGHT+IGI+g0iwNNANiyJ5W2P+d+MobFjPkzaRyiWadi7a1ytGbtrKlKTrs6iSUOYGvs3maAnfcsgnA==
X-Received: by 2002:a05:6a00:3cc2:b0:6f3:8990:665c with SMTP id d2e1a72fcca58-7040c680a48mr11284156b3a.18.1718074003869;
        Mon, 10 Jun 2024 19:46:43 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70599bcac14sm2117676b3a.1.2024.06.10.19.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 19:46:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 11 Jun 2024 12:46:39 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] Stop a memory leak in nfq_close
Message-ID: <Zme6j5eOm8thplwY@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
 <ZmCB-walvbM9SnX7@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCB-walvbM9SnX7@calendula>

Hi Pablo,

On Wed, Jun 05, 2024 at 05:19:23PM +0200, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> On Tue, May 07, 2024 at 09:17:19AM +1000, Duncan Roe wrote:
> > 0c5e5fb introduced struct nfqnl_q_handle *qh_list which can point to
> > dynamically acquired memory. Without this patch, that memory is not freed.
>
> Indeed.
>
> Looking at the example available at utils, I can see this assumes
> that:
>
>         nfq_destroy_queue(qh);
>
> needs to be called.
>
> qh->data can be also set to heap structure, in that case this would leak too.
>
> It seems nfq_destroy_queue() needs to be called before nfq_close() by design.

Oh sorry, I missed that. Anyone starting with the example available at utils as
a template will be OK then.
But someone carefully checking each line of code might do a
`man nfq_destroy_queue` and see:
       Removes the binding for the specified queue handle. This call also
       unbind from the nfqueue handler, so you don't have to call
       nfq_unbind_pf.
And on then doing `man nfq_unbind_pf` that person would see:
       Unbinds the given queue connection handle from processing packets
       belonging to the given protocol family.

       This call is obsolete, Linux kernels from 3.8 onwards ignore it.
And might draw the conclusion that the call to nfq_destroy_queue is unnecessary,
especially if planning to call exit after calling nfq_close.
>
> Probably add:
>
>         assert(h->qh_list == NULL);

I don't like that. It would be the first assert() in libnetfilter_queue.
libnfnetlink is peppered with asserts: I removed them in the replacement
libmnl-using code because libmnl doesn't have them. Have you looked at the v2
patches BTW? I'd really appreciate some feedback.
>
> at the top of nfq_close() instead to give a chance to users of this to
> fix their code in case they are leaking qh?

It's not as important to call nfq_destroy_queue as it used to be. Why not just
free the memory? I could send a v2 with the Fixes: tag removed and a commit
message that mentions the change is a backstop in case nfq_destroy_queue was not
called.

Either way, `man nfq_destroy_queue` could be improved e.g.:
       Removes the binding for the specified queue handle. This call also
       releases associated internal memory.
While being about it, how about removing the obsolete code snippet at the
head of Library initialisation (that details calls to nfq_[un]bind_pf)?
Perhaps a separate doc: patch?

Cheers ... Duncan.
>
> Thanks
>
> > Fixes: 0c5e5fb15205 ("sync with all 'upstream' changes in libnfnetlink_log")
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  src/libnetfilter_queue.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> > index bf67a19..f152efb 100644
> > --- a/src/libnetfilter_queue.c
> > +++ b/src/libnetfilter_queue.c
> > @@ -481,7 +481,13 @@ EXPORT_SYMBOL
> >  int nfq_close(struct nfq_handle *h)
> >  {
> >  	int ret;
> > +	struct nfq_q_handle *qh;
> >
> > +	while (h->qh_list) {
> > +		qh = h->qh_list;
> > +		h->qh_list = qh->next;
> > +		free(qh);
> > +	}
> >  	ret = nfnl_close(h->nfnlh);
> >  	if (ret == 0)
> >  		free(h);
> > --
> > 2.35.8
> >
> >
