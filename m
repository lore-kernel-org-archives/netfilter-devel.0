Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDCA12BF01
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 03:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718248153; cv=none; b=hnByQoLyPMFbITPfq4vF8R1IgeU3YdS651DTQlDfrabklnfra4DhGA4SCtnqh5Fy3BKdPEU2w7X6hdA4b2zhzA6qg8gUwJQ7iC82Qa0DYLgNUS1ZASPYTcaCb9X6Lv05PuRAIxkJCdB/fbdx+nMRxSudRT1r1caFkD3EtG+wQ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718248153; c=relaxed/simple;
	bh=jfKM5K8ea0wBQUh/AqfFqFVBGmCFakSH6ddWgJmIrIA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZH6nqIp+2bPaFGWeeOX0D93wm98SaQ7mrs+Ig9YAazDXatlThwZPGwJfYGXtL68IAcpYGJorZHHpbVS5elEyFOJMCDMK1Vf4HjyiPzVMNhSNDNThPp+enYzHITkZ+TVG40LuBkK+uAvbl6fx2hxA4iCgapnF2tJt+EICs9dA/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1AOstZq; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1AOstZq"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2c313edc316so382095a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 20:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718248151; x=1718852951; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBLHo25Bm3YhqHF47Dr5dmoqJ509v4bI5Hmxnwjd72U=;
        b=j1AOstZqxFR0zUpCkh0qz/EykB2GayHpANirk1NZcw+0Up4yEb9/OQOYc5Ii+lM5ir
         I3bQO5iVz8jct6IvmlGEEKBQUUvRyZepm0Bb2OgCVQvqzJYY+EbGeXeVRGFWwPKADAGu
         8oFm5zQRBG1glbDcHA3JwlfYuVlyHK9giNxDtxcwDNMlxzUlPA2gJA2cU7H3c6qHUFiq
         N7bYg/Wy7BDeLEp2mqBf6gg6nCH/J9d/XlbtSdd9VKFB7U/eIvny05wsW02jqUYdBBvQ
         Bx2h0ZFIoJiKGxuMcMc8YfMBEUtNhZdxyElxJ4TSyTN627lwSXMJ68Jl17QbJUJQwVSI
         /7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718248151; x=1718852951;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBLHo25Bm3YhqHF47Dr5dmoqJ509v4bI5Hmxnwjd72U=;
        b=hJ7MK2SHO8+F9p8B75rB08A5XeTP0OLzk6vwHqppYzEZr/6BLeWmPVaL4UisldgiAb
         LBwjsF+VQxmJN2rGWE9TTwdb4rybP5ywmFWzMU0E/LjcwpTe/uIKH9ru5TlRHj7hXwgx
         iG8EMKU4rfguZ9OHFLvfbCFZ/wOYndz7q4jomCNVhZQR+IeyqMv0FkEEYZ957TLusQoZ
         DUIhpy/FlzwU7s6/mkyLYIzzf2nvRiwISsrIBkP6WFHFhHojDkumS5UK9O7vCEs3o4zz
         rkun6lDOVyoWNnS2+bGa9idGVrQw2vBfWL/iCO0quyhJM8Iyyguis/7iUKvfXV1FO9Z4
         dyQQ==
X-Gm-Message-State: AOJu0YwplCOIlyuEkM8hAQ5ert0OqkWX1mE+pGTG0ZmctY59f3TZ7NXw
	H/OLBancnRH+p4tBMZo0HbNjr+VSrOuMcV71nVv1MAtOGqFceMGQBAuUNQ==
X-Google-Smtp-Source: AGHT+IGKX0/6QYRXpqioH2QBOjRmStSElGFnHUVHtWwT0xlA/N7YsefB1qpcDUXvRwuePHtWhVhBEA==
X-Received: by 2002:a17:90a:986:b0:2c2:7bbe:d6ba with SMTP id 98e67ed59e1d1-2c4a7601665mr3805152a91.8.1718248151026;
        Wed, 12 Jun 2024 20:09:11 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c45af993sm391323a91.11.2024.06.12.20.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 20:09:10 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 13 Jun 2024 13:09:07 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] Stop a memory leak in nfq_close
Message-ID: <Zmpi04j4x1stEwxS@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20240506231719.9589-1-duncan_roe@optusnet.com.au>
 <ZmCB-walvbM9SnX7@calendula>
 <Zme6j5eOm8thplwY@slk15.local.net>
 <ZmjN9Z-C7r7vzakH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmjN9Z-C7r7vzakH@calendula>

On Wed, Jun 12, 2024 at 12:21:41AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 11, 2024 at 12:46:39PM +1000, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Wed, Jun 05, 2024 at 05:19:23PM +0200, Pablo Neira Ayuso wrote:
> > > Hi Duncan,
> > >
> > > On Tue, May 07, 2024 at 09:17:19AM +1000, Duncan Roe wrote:
> > > > 0c5e5fb introduced struct nfqnl_q_handle *qh_list which can point to
> > > > dynamically acquired memory. Without this patch, that memory is not freed.
> > >
> > > Indeed.
> > >
> > > Looking at the example available at utils, I can see this assumes
> > > that:
> > >
> > >         nfq_destroy_queue(qh);
> > >
> > > needs to be called.
> > >
> > > qh->data can be also set to heap structure, in that case this would leak too.
> > >
> > > It seems nfq_destroy_queue() needs to be called before nfq_close() by design.
> >
> > Oh sorry, I missed that. Anyone starting with the example available at utils as
> > a template will be OK then.
> > But someone carefully checking each line of code might do a
> > `man nfq_destroy_queue` and see:
> >        Removes the binding for the specified queue handle. This call also
> >        unbind from the nfqueue handler, so you don't have to call
> >        nfq_unbind_pf.
> > And on then doing `man nfq_unbind_pf` that person would see:
> >        Unbinds the given queue connection handle from processing packets
> >        belonging to the given protocol family.
> >
> >        This call is obsolete, Linux kernels from 3.8 onwards ignore it.
> > And might draw the conclusion that the call to nfq_destroy_queue is unnecessary,
> > especially if planning to call exit after calling nfq_close.
>
> Then, update documentation.
>
> > > Probably add:
> > >
> > >         assert(h->qh_list == NULL);
> >
> > I don't like that. It would be the first assert() in libnetfilter_queue.
> > libnfnetlink is peppered with asserts: I removed them in the replacement
> > libmnl-using code because libmnl doesn't have them. Have you looked at the v2
> > patches BTW? I'd really appreciate some feedback.
> >
> > >
> > > at the top of nfq_close() instead to give a chance to users of this to
> > > fix their code in case they are leaking qh?
> >
> > It's not as important to call nfq_destroy_queue as it used to be. Why not just
> > free the memory?
>
> It is not possible to know if qh->data is stored in the bss, onstack
> or the heap, it is up to the user to decide this.

qh->data is a pointer which is assigned in nfq_create_queue() at
libnetfilter_queue.c:584. I was never proposing to free what qh->data points to,
only to free any left-over qh structs.

The user cannot access qh->data directly because qh (struct nfq_q_handle) is
opaque.

nfq_destroy_queue(qh) will free qh at libnetfilter_queue.c:619. I'm just
proposing to free qh's for which nfq_destroy_queue was not called. In
nfq_close(h), h->qh_list can only have struct nfq_q_handles if it has anything.
>
> > I could send a v2 with the Fixes: tag removed and a commit
> > message that mentions the change is a backstop in case nfq_destroy_queue was not
> > called.

I can still do that. It's an enhancement now.
> >
> > Either way, `man nfq_destroy_queue` could be improved e.g.:
> >        Removes the binding for the specified queue handle. This call also
> >        releases associated internal memory.
> > While being about it, how about removing the obsolete code snippet at the
> > head of Library initialisation (that details calls to nfq_[un]bind_pf)?
> > Perhaps a separate doc: patch?
>
> I'd suggest to address this by updating documentation.

Yes it could do with updating. My first instinct would be to remove the
nfq_unbind_pf comments and code snippet as I mentioned originally. Kernel 3.8 is
way out of LTS.

But, there have been quite recent emails on the lists from folks who are stuck
with these old kernels owing to having proprietary closed-source binary blobs.

I could leave these old comments and doxygen lines in but with extra lines
highlighting they are for pre-3.8 only. Do you have a preferance?

Cheers ... Duncan.
>
> Thanks.
>
