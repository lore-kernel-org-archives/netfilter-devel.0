Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1A213A3F7
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768783189; cv=none; b=mbIqXV/9iCXdMaUFzpR6ivt/eTJA6ASZGOiL11SQhWiulzEGQWpQuB0NgxxSrcZXmLw+wORbcpO5W2viM5Kac+rsn8zfIB9QeVgGpdlY2GfOdnGHVeNnxF6Ilxd57sKM3MGpWAP/uI9P+bpTjVcOe5mS635KB3gPsIqWAtBNaKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768783189; c=relaxed/simple;
	bh=y0oIs7r1gsZ2G+lwqZ1qfpdeonuDbgXsSanIFAvSAG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngSbtCopRh3fNQbteLJ0JbPT/NzYUqcSGPzRLG/Hyz+ctmltCcCNCiHBQm4pZxWB4n8a2DKJqAQnMCHEugJQuuFyTsdh5BfMJ/prTdeEnxTjJkVJ7n3kH3N/hv9mwObdXDlQKzcuQrMdsSJe9PhxFFGNJHDjpDE6jhjhx4jypDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC25F6061E; Mon, 19 Jan 2026 01:39:44 +0100 (CET)
Date: Mon, 19 Jan 2026 01:39:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v6 1/2] netfilter: nfnetlink_queue: nfqnl_instance
 GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Message-ID: <aW19UIm96f43DyB-@strlen.de>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-2-scott.k.mitch1@gmail.com>
 <aWwRCM4YZZ3gUP85@strlen.de>
 <CAFn2buCeCb1ZiS0fK9=1RZS3WOSLcdwV1c06JEFbgXTQCTVW1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFn2buCeCb1ZiS0fK9=1RZS3WOSLcdwV1c06JEFbgXTQCTVW1A@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> On Sat, Jan 17, 2026 at 2:45 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > scott.k.mitch1@gmail.com <scott.k.mitch1@gmail.com> wrote:
> > > +     /* Lookup queue under RCU. After peer_portid check (or for new queue
> > > +      * in BIND case), the queue is owned by the socket sending this message.
> > > +      * A socket cannot simultaneously send a message and close, so while
> > > +      * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
> > > +      * socket close) cannot destroy this queue. Safe to use without RCU.
> > > +      */
> >
> > Could you add a
> >
> > WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));
> >
> > somewhere in this function?
> >
> > Just to assert that this is serialized vs. other config messages.
> >
> > Thanks.
> 
> Will do! Does the overall approach make sense?

I don't see any problem with this patch. nfqnl_rcv_nl_event()
cannot run at same time for this socket; it would already be a
problem for the existing code, parallel event+queue unbind
would result in double-free.

So the comment makes sense to me.
