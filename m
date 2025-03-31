Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4011DF75A
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437416; cv=none; b=bs5HlYfBNAg9RW82jGDQxPa5qLR5HQ41Mwo9r33OY3YxOgyGtqF7ZMuPSEQGbi7b7SlL/J/rlZqcZsDiHo6PU/iNHp/JagLRVGPeXrZ0lI/jbQdOkBNmMQ7NeeaxGHWLTXtld9WyXN6prESk6reD/Esrr9UAHvbcPpumXDygzm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437416; c=relaxed/simple;
	bh=Ry9Ab//knwOfnHawIUTYl2x/uECyVQ0MR1e0Bv2n8FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zknd3I7jLUgQRuqrx1VSlRliQRzf0RnvcGF6Y6FxE6GXnzz3lPLux0Dsu23aG+bTE+IIafkLi29OLpUBgcyyJcggHvZdSsm/0J8SlTUpN3pVtnND2BulNb8Uy5g4ygjo+U2bAFCryfpibk9boURhY6mkCHP7fTmviwDolujb3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DHDHUEx9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uXwuNrIp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DHDHUEx9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uXwuNrIp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5EB61603C0; Mon, 31 Mar 2025 18:10:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743437411;
	bh=lIYlacDvlkJkjy26ozh0Rlc29EMaBiLb3+NXQ287OMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHDHUEx9Silbh5/Ycvv9MKx12GDRAC8nn+vQubOFxFD8v6qD1Yu3zESXjxC2hoaS/
	 8KPllkJINiD50FxCqdOy1zpr6Wo1C0db9qiVuIo38D0/TAegzVtaW2mfRtiSmmzuxC
	 N4P3EYOoTmBy4OXFuoX99YiE6TF699OopVI51GMUKWcmzSzJHwJ7IVRY0QH9ncvUu/
	 qhs1waogPYLqBdf/NkLiSsoRzoghw/fiZ1ToN6oPYasEawMaQdkYRwjoetVa3HIK10
	 fm605bSn3f+hxLtSl8C7NoGbNCic+s4w+M/jS/aPGL889e3/obELRDRhSdiAktoxjC
	 cFA1eveSAN5dg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A7521603C0;
	Mon, 31 Mar 2025 18:10:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743437410;
	bh=lIYlacDvlkJkjy26ozh0Rlc29EMaBiLb3+NXQ287OMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uXwuNrIpVZ66xyrh+7N/3an6qcuiijaSueawzrK61p8CQ1vEiyhlwStz2F6wSAawL
	 /1CWAAQCy3S2knOTpV1U6zKm4q0eHENyoqG5bprkttUGxqNMeCml5hsiLqeeEI0hFQ
	 4Aqcxv25nPZpoolyHwDPBkzroN89v8/JGhMD87uFZl6uTjbKLNrQ7WC1PhUYlLzBbi
	 aFXXS56b4DBaSmYGQPFuZ5+lJTB1nWEOJWZG4iMPteksMP6DKRSzd+sNmSgXxWH9F+
	 6PBgcSvXCA/joQ+riAtftyQiF/X38NCjEel1F/we/v9y2rp7Wp6oTXT/GcC+lWSoyi
	 I/NeFoFKrXqNw==
Date: Mon, 31 Mar 2025 18:10:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] expression: don't try to import empty string
Message-ID: <Z-q-X4Yhkn3vXD3p@calendula>
References: <20250327151720.17204-1-fw@strlen.de>
 <Z-p7BmD6RqC9-IN4@calendula>
 <20250331123715.GA12883@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250331123715.GA12883@breakpoint.cc>

On Mon, Mar 31, 2025 at 02:37:15PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Florian,
> >
> > On Thu, Mar 27, 2025 at 04:17:11PM +0100, Florian Westphal wrote:
> > > The bogon will trigger the assertion in mpz_import_data:
> > > src/expression.c:418: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
> >
> > I took a quick look searching for {s:s} in src/parser_json.c
> >
> > The common idiom is json_parse_err() then a helper parser function to
> > validate the string.
> >
> > It seems it is missing in this case. Maybe tigthen json parser instead?
> >
> > Caller invoking constant_expr_alloc() with data != NULL but no len
> > looks broken to me.
>
>         return constant_expr_alloc(int_loc, &string_type, BYTEORDER_HOST_ENDIAN,
>                                    strlen(chain) * BITS_PER_BYTE, chain);
>
> chain name is '""'.
>
> There are other spots where we possibly call into constant_expr_alloc()
> with a 0 argument.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> I think it would be a lot more work and bloat to add all the checks on
> the json side while its a one-liner in constant_expr_alloc().

I don't think this is needed, the idiom in src/parser_json.c is to:

1) fetch string
2) validate it

For example:

        if (!json_unpack(root, "{s:s}", "ttl", &ttl)) {
                if (!strcmp(ttl, "loose")) {
                        ttlval = 1;
                } else if (!strcmp(ttl, "skip")) {
                        ttlval = 2;
                } else {
                        json_error(ctx, "Invalid osf ttl option '%s'.", ttl);
                        return NULL;
                }
        }

> I could also add json_constant_expr_alloc() but it seems kinda silly to me.

I agree, I don't think json_constant_expr_alloc is needed.
