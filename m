Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD5A31813A
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 22:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774563495; cv=none; b=eJEic3qCwUxPo9156CxHd8fkHrlE7NSVTrgQJU2GOb0CHsqJHEW+yNtdoYvPYsKjc0g6hR6tMJPZRmbgxgVJBkX4rbLYd3+6RkfnUDuj8RqlGACh2ENM32zpgFvgDkUg6Guh0gndv2KjEVd+sFuo4026eEnszq3yV3Ya3kvJ7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774563495; c=relaxed/simple;
	bh=qpFX/JTbGIwdSC3Z3k4i+PdijUgT1IlDDER/t+YpzgY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fFi/d573ctUOSlsPxm1fLoce2K6lv6c74vkR8ZjnfCAyxh6ZTVBfhH1Rjx9P0Y7f5an9drPz0GFVbCYejQV00CuJ4Q8B/GOK6L7VAQtKAOpPa0Y9xKc4BfdHI3ICvx0lwWOI9ZMhdhuNlvNJqoU+5XIqCswso2Ra5PCWD6NHUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMesgFlz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMesgFlz"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so15132395e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 15:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774563492; x=1775168292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Nacxvr2ELo/XQwaZt97OI3oFNXHowVhMcBzyb+a0KA=;
        b=eMesgFlzRFNrh6qF8YWhQ9hkDLYv7gWgyBWEhVLiWJOLGGpYuTOVUlDzR4NXzywIMp
         0AfARdlbT1RHFfMu2b88Bm0GUjshZKnCXz1rJ1uh+IRFsdCu31Wrl5CpWHCmGkU4SoBn
         E4frD3LZCFcUqs6mhCFQKekBvZEyTy4vMNFT/SdTc3zM6Joh0L4DUoC3y4TpvTXuUO1X
         j334/otE8uA+lXgk9iwgYy0l7Yd7nU4pUZbAUSoBeCw+7eV2sjftR+48YHmYPMKbhMI5
         IgQWAuzZUGgB3A+tVb0R7hqkljRPk8I87I0XyVgZFkj++jHNb4LSy5rLZi5GDNkTcILy
         Tn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563492; x=1775168292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Nacxvr2ELo/XQwaZt97OI3oFNXHowVhMcBzyb+a0KA=;
        b=H+lCmiGeLT1RU0OK/nBAZTQ2+gMgloEzMNMcV9oOX5AY9wqdq2Q/1DDFl01sVtFka2
         1wE2Eamh7Pcae6+IbcS28cMns5ArXuatXBd7Ay4Dl96DaNuriqIEOBlbZuyjMjfNCmhd
         5rd441X5DnTsp1K6UFLQywbQZtp6di8uJ5HEGR96a2l1yw5neX2O11zlKwNVItgnQXK6
         wYRNgLtokiIQLEbTzooTWpCs0aBPyPZrnWVg7FDaw+LEEQNFgJSFGpJWpu1ZUs8RJEbB
         AvF1cOLBIiB9QqwZiFp55H49gwzlXsaiti3f/vrZGh7rHlbMkCVmGuijx9AhSZMRyyW3
         ap2A==
X-Forwarded-Encrypted: i=1; AJvYcCU72pGPjo7XX6HJmZ7/LKPRSRhN+9FIEZYE4pVfU7Lde1M/LeyIYP16bLyiQazetgISMJagu/SPl31wQc4B/ss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBZeG1YFhmhKYQAc9NZXG+napCZAcVitx7J38lIfteYxuDzMoQ
	fJeJAtBHcIM+6eM/cC46cGtJnU4CuUQjosuunxH8WLhYdN2jpmYj/FGs
X-Gm-Gg: ATEYQzzWUErtOLo5KEArnQng8IfcVtfCAr5VzX6oyCufutBaLpbBWF29Lm8TwCyvOth
	1q0DY1yk/XSq/R8ULcdhjatvica0ngzPwnYz3W6csmcLJm8n0XItK7McHCSbFUuxUrvppSGXyNA
	zjtQiArjwiJoq4/hdqiwyfbsfYX6FSGKWtZJli9XM+oo3eA9c54Qr1znSVlr+DIA/WjPE+eEfe5
	29ZAPACVTlDeGdOS6qcarwtNYfGePiTiMQiIVXO9l1/gbBg8z5T49e7vEKIdnI81uhFK0KCxSYP
	8T4lg6SAhYTSeK7JqGv8hhqxr3YxZzEYrb2Q1hWF+fAjFxH0Ww+Tg9CEI31gfDAd40iSIQEyrZV
	G/ZGohhELTtlkuE1quAAm+LgYQXUGEEsCwMs7/zN2dPeXRpgggy3tD7SLE2jXMEAcy9LMb463QS
	/bnJ5RF8MBXFflzNZlw6JJz91QB9sH4HMKH2b4aAKx0mi9DfCyCT/LdKZVKKwRSU7T
X-Received: by 2002:a05:600c:5290:b0:486:fcdf:c065 with SMTP id 5b1f17b1804b1-4872808d317mr4858335e9.27.1774563492316;
        Thu, 26 Mar 2026 15:18:12 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c78bc2sm55136515e9.5.2026.03.26.15.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 15:18:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 22:18:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Steven Rostedt
 <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <20260326221809.0b99df3f@pumpkin>
In-Reply-To: <acWWBxmPd_BNqUHF@chamomile>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
	<acWWBxmPd_BNqUHF@chamomile>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Mar 2026 21:24:39 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi David,
> 
> On Thu, Mar 26, 2026 at 08:18:19PM +0000, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > The trace lines are indented using PRINT("%*.s", xx, " ").
> > Userspace will treat this as "%*.0s" and will output no characters
> > when 'xx' is zero, the kernel treats it as "%*s" and will output
> > a single ' ' - which is probably what is intended.
> > 
> > Change all the formats to "%*s" removing the default precision.
> > This gives a single space indent when level is zero.  
> 
> Do you have a setup using this helper? Or you just found this via
> visual inspection?

Found with grep looking for places which might be affected by 'fixing'
the kernel printf code to be POSIX compliant.

	David

> 
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >  net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> > index 7b1497ed97d2..287402428975 100644
> > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > @@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
> >  static int decode_nul(struct bitstr *bs, const struct field_t *f,
> >                        char *base, int level)
> >  {
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	return H323_ERROR_NONE;
> >  }
> > @@ -284,7 +284,7 @@ static int decode_nul(struct bitstr *bs, const struct field_t *f,
> >  static int decode_bool(struct bitstr *bs, const struct field_t *f,
> >                         char *base, int level)
> >  {
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	INC_BIT(bs);
> >  	if (nf_h323_error_boundary(bs, 0, 0))
> > @@ -297,7 +297,7 @@ static int decode_oid(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	int len;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	BYTE_ALIGN(bs);
> >  	if (nf_h323_error_boundary(bs, 1, 0))
> > @@ -316,7 +316,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	unsigned int len;
> >  
> > -	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
> >  
> >  	switch (f->sz) {
> >  	case BYTE:		/* Range == 256 */
> > @@ -363,7 +363,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
> >  static int decode_enum(struct bitstr *bs, const struct field_t *f,
> >                         char *base, int level)
> >  {
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	if ((f->attr & EXT) && get_bit(bs)) {
> >  		INC_BITS(bs, 7);
> > @@ -381,7 +381,7 @@ static int decode_bitstr(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	unsigned int len;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	BYTE_ALIGN(bs);
> >  	switch (f->sz) {
> > @@ -417,7 +417,7 @@ static int decode_numstr(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	unsigned int len;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	/* 2 <= Range <= 255 */
> >  	if (nf_h323_error_boundary(bs, 0, f->sz))
> > @@ -437,7 +437,7 @@ static int decode_octstr(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	unsigned int len;
> >  
> > -	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
> >  
> >  	switch (f->sz) {
> >  	case FIXD:		/* Range == 1 */
> > @@ -490,7 +490,7 @@ static int decode_bmpstr(struct bitstr *bs, const struct field_t *f,
> >  {
> >  	unsigned int len;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	switch (f->sz) {
> >  	case BYTE:		/* Range == 256 */
> > @@ -522,7 +522,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
> >  	const struct field_t *son;
> >  	unsigned char *beg = NULL;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	/* Decode? */
> >  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> > @@ -544,7 +544,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
> >  	/* Decode the root components */
> >  	for (i = opt = 0, son = f->fields; i < f->lb; i++, son++) {
> >  		if (son->attr & STOP) {
> > -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> > +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
> >  			      son->name);
> >  			return H323_ERROR_STOP;
> >  		}
> > @@ -562,7 +562,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
> >  			if (nf_h323_error_boundary(bs, len, 0))
> >  				return H323_ERROR_BOUND;
> >  			if (!base || !(son->attr & DECODE)) {
> > -				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
> > +				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
> >  				      " ", son->name);
> >  				bs->cur += len;
> >  				continue;
> > @@ -615,7 +615,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
> >  		}
> >  
> >  		if (son->attr & STOP) {
> > -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> > +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
> >  			      son->name);
> >  			return H323_ERROR_STOP;
> >  		}
> > @@ -629,7 +629,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
> >  		if (nf_h323_error_boundary(bs, len, 0))
> >  			return H323_ERROR_BOUND;
> >  		if (!base || !(son->attr & DECODE)) {
> > -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> > +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
> >  			      son->name);
> >  			bs->cur += len;
> >  			continue;
> > @@ -655,7 +655,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
> >  	const struct field_t *son;
> >  	unsigned char *beg = NULL;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	/* Decode? */
> >  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> > @@ -710,7 +710,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
> >  			if (nf_h323_error_boundary(bs, len, 0))
> >  				return H323_ERROR_BOUND;
> >  			if (!base || !(son->attr & DECODE)) {
> > -				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
> > +				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
> >  				      " ", son->name);
> >  				bs->cur += len;
> >  				continue;
> > @@ -751,7 +751,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
> >  	const struct field_t *son;
> >  	unsigned char *beg = NULL;
> >  
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	/* Decode? */
> >  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> > @@ -792,7 +792,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
> >  	/* Transfer to son level */
> >  	son = &f->fields[type];
> >  	if (son->attr & STOP) {
> > -		PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
> > +		PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
> >  		return H323_ERROR_STOP;
> >  	}
> >  
> > @@ -804,7 +804,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
> >  		if (nf_h323_error_boundary(bs, len, 0))
> >  			return H323_ERROR_BOUND;
> >  		if (!base || !(son->attr & DECODE)) {
> > -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> > +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
> >  			      son->name);
> >  			bs->cur += len;
> >  			return H323_ERROR_NONE;
> > -- 
> > 2.39.5
> >   

