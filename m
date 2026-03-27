Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEBC3DBD41
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617089; cv=none; b=D9HCs+sdWQWSu6holIhYJuNvK7pz5wmw4GpvrYzg6tADTEzJLtTmMzYQUD/R5CrmmdqIml8a1uFIW1e/amZAAiVG3huOwcGBMa4DHuCGAGBnL+9Hni2Q7VJuF+p1LZnR347hDsgURG7jdWFjs83GDA0sAA3WW4C4f9oyGipDVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617089; c=relaxed/simple;
	bh=nzoQaay+raQjhTgYBaF5aWNmIVaEh6xyvzO/+HCw13g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hvy2tS5FApsiTTBfzWNPhxlEwe9MIKIovKKFkyJUxHfMvSkZsUcEUPpyZRtS409ScMVtFLVrwDPvcU59QkraJ/KT5MCllcHPEgE5ODUUYMZ70zYxEb3rfFIE+KbsuWBwieD5RvJskxt+D292X3TdY5qc86E+EGtGst96iyu+2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aElAa59X; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aElAa59X"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-486ff201041so19091985e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 06:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774617086; x=1775221886; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ccf0sTgtLqz3zlYVLqeO3X4QYfoZ2D16OMDmsuZJ+v4=;
        b=aElAa59XdQxBmlRKGy/6PHKqf3dejpCsQk1ZTdlDe0EaDoJKHf7iaTaIojgE/SyWa/
         T4vfxQDjQCPB/19OkOaOEQywUrv3RInGgLW2Dh9r2wW2bZ0WYMVaBFpr21HmlswMx3NV
         RpbDuaJy0eM4U7CW0b2PG/FfcsorEJDvRrtx4gW/sLl67rfV1Vp+tarO5FlArhyawTln
         KoRmUlMctIa6w1RgM60R/KN5lPSXnC1KEIGly+BzQxj63jNFyjkvBSUVgOGIhx+2Nlid
         pgcnmLOw05cEXzaC/C0VkeD6MaNfUjRiBXzCGaSmtyXoPR5GE54jlixLkdPTLJJtu2e0
         Vn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774617086; x=1775221886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ccf0sTgtLqz3zlYVLqeO3X4QYfoZ2D16OMDmsuZJ+v4=;
        b=mgpYYirZP/kV7s89C/z2wXRqQu1HcS1i6KQcbTyHvBKq7DNMwOssSf2OPvsUcOuH5L
         4d/UJylPL7vOrATOzix4sW2l+usXX/CVeqtqDbei+68qsq14M//9jFzeSbuGYKdaEATh
         y8zHJYB1gzMg8o7be7Du8alaCZql2lLOeEqDSvyLbAkUqE8Pa2GE3X6reVFH97v8Y7YU
         wCAHCuIm4N6dzR9VxeoWhIxGKeJGjd1XA2Ay5XTX7FGMcgKtIX/8iaAi1/cGb61WhBY/
         3dgf1ALjx01U8hNDmaPehGqUsEeASnlctYWTXUixZN7w7dVgkaoUPipuxJCuHeHgcVu0
         zDag==
X-Forwarded-Encrypted: i=1; AJvYcCWyksP8+l6J5IJDFwSjfbwKDBPNQB4u1exs8twub68r+YQ6lp+zlVSqj1pKqexiiK2GX/TKUafRBOwRTEcUG74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjh6i0MzwkGv4w+kRq1aLth2SkcftfeXKovAuVSw5mZKvood4V
	VNQy8lfZAAwP/nLh0glzRbYj0xMfq+v4RcLoFeO6H5kx9alJvTrOb2sOVRdw9rItw1TQa3KRUlI
	IKeUtgR0=
X-Gm-Gg: ATEYQzw+eRdrxZNr4WPApGcgZMjNIo4JDy7oidMCJ7fTML+k6/nbBCl2dQa5rsQoBez
	9z4po2tEk7rax++hLg0b0g8W+WOrFvhCOQ4ObHCbc5JCpAXA8saYIWV8aCHiedpdIsdp1UqXniq
	YBcwCzXM1odsXeqcLiXt8+QmzNITQKBTuuNqGNWoqwQZ7hxswGyIzhdNhxyMM1GqTR4mzmg8KP1
	3lxB5LFELLHB7OHU65zjZungtx55N/xoVbv/u0CKpMzxN4pGZsKQWn6IHsdiXcS+Q3LoUj+/9oo
	mZ156L/SejWmm2PIypczwHH0Ewl/pSg1pM3YARrO3PSJmrrmkqC8kTGsRAzd1Bhd0lFJr4Vavon
	MTN/KnZogWBHkUaHvH+o7QVcjnhjciPt3LP4CZU0HR07zhY5rvem3E7q8r7XciJ5Gj+p49YfZt0
	hZsr2O72FfIAFGf4VCVwD3eMQ7Hw==
X-Received: by 2002:a05:600c:a108:b0:485:17a7:b9c7 with SMTP id 5b1f17b1804b1-48727d6f6d8mr35069435e9.10.1774617085665;
        Fri, 27 Mar 2026 06:11:25 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b9192e3e8sm17747282f8f.5.2026.03.27.06.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:11:25 -0700 (PDT)
Date: Fri, 27 Mar 2026 14:11:23 +0100
From: Petr Mladek <pmladek@suse.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <acaB-0VR1sAXPsed@pathway.suse.cz>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
 <acZSPeowuYC7ivgA@pathway.suse.cz>
 <20260327125527.13aaf590@pumpkin>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327125527.13aaf590@pumpkin>

On Fri 2026-03-27 12:55:27, David Laight wrote:
> On Fri, 27 Mar 2026 10:47:41 +0100
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > On Thu 2026-03-26 20:18:19, david.laight.linux@gmail.com wrote:
> > > From: David Laight <david.laight.linux@gmail.com>
> > > 
> > > The trace lines are indented using PRINT("%*.s", xx, " ").
> > > Userspace will treat this as "%*.0s" and will output no characters
> > > when 'xx' is zero, the kernel treats it as "%*s" and will output
> > > a single ' ' - which is probably what is intended.
> > > 
> > > Change all the formats to "%*s" removing the default precision.
> > > This gives a single space indent when level is zero.
> > > 
> > > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > > ---
> > >  net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
> > >  1 file changed, 19 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> > > index 7b1497ed97d2..287402428975 100644
> > > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > > @@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
> > >  static int decode_nul(struct bitstr *bs, const struct field_t *f,
> > >                        char *base, int level)
> > >  {
> > > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> > >  
> > >  	return H323_ERROR_NONE;
> > >  }  
> > 
> > The change is important for making the kernel %*.s handling POSIX
> > compliant. The dot '.' without any following number is handled
> > a zero precision by POSIX. It would print no space "" when
> > also the field width was zero, aka when level == 0.
> > 
> > It has no efect if the field width (@level) is always > 0 because
> > vsprintf() would add the required emptry spaces ' ' anyway.
> 
> That looks like C&P AI output...

I believe that these days AI would be able to formulate it a much better
way than me.

Best Regards,
Petr
