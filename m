Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F92C236B
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782771704; cv=none; b=dRcOt3N5DkwhT2LyLUOt8v43GDq2hwCF9ugBy27kF0+G7fHbRMYrnUOM1Tl+eA2qDFH792MVeRt+DZEldg9ofPzxXr0gpxHnwBCnpA2FUDkiquiyAF4I0aXtt9FRmWep4fxBCa7q3vQ10OAZwOlbOwwHWeHDsBCFJu4myBHTbtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782771704; c=relaxed/simple;
	bh=Ut8PtEHXcAS4k1PY/dR1wKZTzdVe7HHzu+IWuVjq3Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIUhdksf3FOxD3CeBy4ZYcAWZmiUUKKqwvmsimN9vzFpafPG/tNB4sHkMAbR0Q2iRl2ySAbiC3Q9gJ6TzmDrIYoXVuly3pCYpylEIourXdt0/rW+FnOvV9hqZ7hkcwarVD8DNrTj5qqAth1R1iO0C2ghz6JRZun2eeOU6+n/1cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TTJrwIKc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TTJrwIKc"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 983F560575;
	Tue, 30 Jun 2026 00:21:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782771699;
	bh=VZA5e3xGgcNekzcICXJLSTgR/NX3BEf5N01GDsj0C/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTJrwIKcWxvXBMFJFUl8dJ2SeZ0qCTiKVyu1LOoihMiZ72HH0DeIJld1jhjf7Qi1z
	 px1QdJC3d2mjF2djz+ZJYhrhGq8dwz/DU6H8zpXwezQ8j3GCwHtUdpKo8koevHoadv
	 rndInsRldhLSefF+WQaeAqzZgtq4UFY25LlcnFaUVuHRhBRr3mmt/kTKyQqK6V71es
	 TFtVM28V8d9YRdMKcG3afISjKwafJKWBWjuK3aYthVu9pHzvhjjRYc/kRHxPws+ima
	 8y5Dj+my6Y+54topkr7hEcSVp5HrsT9OVzsc45ZGNmLjYs11NmCN4tJezqR6N4FZ8J
	 PX4hiV6sdua/g==
Date: Tue, 30 Jun 2026 00:21:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_expect: zero at allocation
 time
Message-ID: <akLv8CI5rUwa5krL@chamomile>
References: <20260625001356.16478-1-fw@strlen.de>
 <aj5h9eFJE1glpYfz@chamomile>
 <aj5pc-9CKwnuG5iE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aj5pc-9CKwnuG5iE@strlen.de>

Hi Florian,

On Fri, Jun 26, 2026 at 01:58:43PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Jun 25, 2026 at 02:13:53AM +0200, Florian Westphal wrote:
> > > There are occasional LLM hints wrt. leaking uninitialized data to
> > > userspace via ctnetlink.  Just zero at allocation time, expectations are
> > > not frequently used these days.
> > 
> > Fine with me. IIRC hints came because of real issue, ie. paths where
> > I was missing to initial something.
> 
> 
> > > @@ -389,6 +389,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
> > >  #if IS_ENABLED(CONFIG_NF_NAT)
> > >  	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
> > >  	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
> > > +	exp->dir = 0;
> > 
> > Hm. But now area is expect is zeroed, right?
> > 
> > Maybe nf_ct_expect_init() needs to be updated to remove needless
> > zeroing too?
> 
> See:
> > > Intentionally keeps _init as-is because we could theoretically support
> > > re-init, so add the missing exp->dir there.
> 
> If you say we are guaranteed to always have:
> 
> exp = nf_ct_expect_alloc(ct);
> nf_ct_expect_init(exp)

IIRC, this API was already around when I came here...

> then we could remove it.  But then I'd question why we even have this
> alloc / init split and not:
> 
> exp = nf_ct_expect_new(rtp_exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
>                        &ct->tuplehash[!dir].tuple.src.u3,
>                        &ct->tuplehash[!dir].tuple.dst.u3,
>                        IPPROTO_UDP, NULL, &rtp_port);

... so yes, that's possible.

IIRC, there are only two spots that opencode the expectation
initilization:

- ctnetlink_alloc_expect()
- nf_conntrack_broadcast.c

Let me complete my series to turn exp->master into a cookie. I started
a series for nf-next to achieve this, I am ready to post the initial
preparation patches that reduce the number of exp->master references
in the tree.
