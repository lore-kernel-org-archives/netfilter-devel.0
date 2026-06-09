Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8FB30DED0
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781042482; cv=none; b=QhMWqMhIlRqILmBBb8MWtJx9RWj0q3yWc2PeXDF6woyk5adexeW6Ev5kmytCOCFrRO+hxVtkFZsFCa3AApRBWxeoYQ5KhnQajbLb397UAfUTsTqgd014QD8Gcp6jP+mURUNCQRtVYHS/QCCAaM/zqF1j/AO4AsmGaA8CuQ3LyDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781042482; c=relaxed/simple;
	bh=d/CCHrKjxU57muNoAvihf+56cTgEtzpWTDrBw6qscIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3Vc00ASfpU0o6iJ43GPV9olY7Fw7j+Fvf2k4B1GWoTyF8Sz/LeXYrfs13PvoGhbtIuS8n/p9iE4UQeT9y6AHFQ4KQ6q1vWA1tdk07Y553K9zMBLGC0lGZwIsFEvaVJwkS3FyYZhid8MLxu8tBKyHdqYYj/qYdFVtiKSrdMEsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=lzrfmfhC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="lzrfmfhC"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8423f626a65so2620727b3a.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 15:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781042480; x=1781647280; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eoD8BH/Hr/jWaBiFW6bawhy0i5xpJ3yl9SXADgS+DQw=;
        b=lzrfmfhCpFdoReztcTJYIMYF/kiv3Qj6Jb+hmCGfsf0cNqTyQJtby+tCwtGfj7c50R
         ijsoeiNKrjjhdL/yuDTP2S4CL5l3TCRdxvm+WX/6J8sAmVUCW+I2uwlYVIotoDNtutRl
         zh+f+SO1vdlqZcgcN+gxqcfsxjrvFZruKZbYwoUOBV+3MBJEfPbIG3rv6W0uhBuHXXJR
         Zoky8hrFCKdb4dOyVCbfq+V/fKjsGG5cSvjqvtAm6CGc17a0CuBmPDoRlAzBIVPoHEFP
         9bJ9bpW8/8zyPutsg25wxnCxZ+y34aRWG+BYNtZvVDF8RjYBgFHYa97tfXMd7oZOsSL2
         f7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781042480; x=1781647280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoD8BH/Hr/jWaBiFW6bawhy0i5xpJ3yl9SXADgS+DQw=;
        b=RFbASUtiFTNzK//tRfIapBe7QlqXqeCDne4F65YakfPb1Fop3+x8OrAHc6MGxbkN9z
         Y89sfL5Q81lzeRHa/hwE3gOaPQQAmKjmLfIhLD07jFjyG9c2/fxyUHfid9BWN8dpiuc3
         5tllfTVPRvOs8FrCM690IM7itE8oy+KRt3vDFnNS6oEmUDrKoqbtMkZOF0jbms26fPQT
         e8p9Spis+xi4wo/tK7sHtkIJ3LSwoU5KwYjWw1st97uKheuz0FgWZuWE0mj037jGj2OM
         rxosLVwmwPbUg3AQvXmqrhqMkwf3ysG3B4jv6XiHiVscQYxGd4j8Cfwn+gCqxC0M/jHX
         qywA==
X-Gm-Message-State: AOJu0YwYZlMp8Vj1f8/CgzH6zrdr9fThwTjgNGMvxxl1I3C1WSZT57KB
	GdQ1v9jeNrPBfVPqj4jEIPIWx/JhScvEiEy2Rx5cNHgxAfCPpWPCHxerZ+A8EYcyig==
X-Gm-Gg: Acq92OHsElwsu5cK3DLuWgvcFHtm10kLgoc6uciCt9xKBkUynOh2M2VLKhCqFqE9bPf
	s9ISbOWUW4VB+HX2nUZI8PRdeg4Hw+itPgY3cnbceeVjd4SJ0i8hmLwp/735+Rc8BvESF1KAxhk
	p/S9iQDv/r0AP2f0Xnf5TIvzP4tiFrpV4Qv+84FJKerUjDJqHnkMParYwcFmAykdbMa9DCuLJ34
	/pcaH0rC/2emnQPFlP+YUIYYTC0McW2zw0Yj/qrbEYM3MCmDadl3mIG13sZhpQcp0foQQWTCLux
	SDGtY68KvtMFvjTox3QEGBLKzHhQYqIajg69QlubkeuELYKl27Oxjra50f+1q0FXbHCXEjCGqKJ
	eRJY8jExL5WgYlCjbyZLE3ef9TCIDo3OwLFWTePRsz6azDl7mF1auCOmXD9kqzHu0RlDtw9v2Yz
	YHByMa+vGt1YlP7+c=
X-Received: by 2002:a05:6a00:139c:b0:838:29b3:9ed1 with SMTP id d2e1a72fcca58-842b0fbc0e8mr23774626b3a.41.1781042477366;
        Tue, 09 Jun 2026 15:01:17 -0700 (PDT)
Received: from p1 ([2607:fb90:ec8e:a6b9:327:74a0:cc50:6c43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm22135675b3a.28.2026.06.09.15.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 15:01:16 -0700 (PDT)
Date: Tue, 9 Jun 2026 15:01:14 -0700
From: Xiang Mei <xmei5@asu.edu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, davem@davemloft.net, edumazet@google.com, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_log: validate MAC header was set before
 dumping it
Message-ID: <uirq3v4lihhyfwg5x46xfupncevwzo4lgncit2ftsbq3jse67k@yavzv6oocv4d>
References: <20260608001124.309352-1-xmei5@asu.edu>
 <aih9kXLYQKsWbUmP@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aih9kXLYQKsWbUmP@chamomile>

On Tue, Jun 09, 2026 at 10:54:41PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 07, 2026 at 05:11:24PM -0700, Xiang Mei wrote:
> > The fallback path of dump_mac_header() guards the MAC header access
> > only with "skb->mac_header != skb->network_header", without checking
> > skb_mac_header_was_set().  When the MAC header is unset, mac_header is
> > 0xffff, so the test passes and skb_mac_header(skb) returns
> > skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> > dev->hard_header_len bytes out of bounds into the kernel log.
> > 
> > This is reachable via the netdev logger: nf_log_unknown_packet() calls
> > dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> > with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> > unset (__dev_queue_xmit(), which would reset it, is bypassed).
> > 
> > Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> > uses.  Only skbs with an unset MAC header are affected; valid ones are
> > dumped as before.
> > 
> >  BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> >  Read of size 1 at addr ffff88800ea49d3f by task exploit/148
> >  Call Trace:
> >   kasan_report (mm/kasan/report.c:595)
> >   dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> >   nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
> >   nf_log_packet (net/netfilter/nf_log.c:260)
> >   nft_log_eval (net/netfilter/nft_log.c:60)
> >   nft_do_chain (net/netfilter/nf_tables_core.c:285)
> >   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
> >   nf_hook_slow (net/netfilter/core.c:619)
> >   nf_hook_direct_egress (net/packet/af_packet.c:257)
> >   packet_xmit (net/packet/af_packet.c:280)
> >   packet_sendmsg (net/packet/af_packet.c:3114)
> >   __sys_sendto (net/socket.c:2265)
> > 
> > Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> >  net/netfilter/nf_log_syslog.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> > index 7a8952b049d1..ed5283fb6b67 100644
> > --- a/net/netfilter/nf_log_syslog.c
> > +++ b/net/netfilter/nf_log_syslog.c
> > @@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *m,
> >  
> >  fallback:
> >  	nf_log_buf_add(m, "MAC=");
> > -	if (dev->hard_header_len &&
> > +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> >  	    skb->mac_header != skb->network_header) {
> 
> Maybe this instead?
> 
> +           skb_mac_header_was_set(skb) &&
> +           skb_mac_header_len(skb) != 0) {

Thanks for the quick reply to this patch.

The skb_mac_header_len is a combination of
1) `skb_mac_header_was_set(skb)` and
2) `skb->network_header - skb->mac_header`

However, we have skb_mac_header_was_set added in the
original patch, and we have `skb->network_header - skb->mac_header`
at the start of the fallback code block:

```
fallback:
	nf_log_buf_add(m, "MAC=");
	if (dev->hard_header_len &&
	    skb->mac_header != skb->network_header) {
	    ...
```

So I think the original patch should be enough.

Xiang
> 
> >  		const unsigned char *p = skb_mac_header(skb);
> >  		unsigned int i;
> > -- 
> > 2.43.0
> > 
