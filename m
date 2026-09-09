Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641F93914FF;
	Wed,  9 Sep 2026 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978766; cv=none; b=XiyJ/TywOJpeaGto2aWt5I6JZNq6rhJa0juax9xWpKfZiD2oJ5yuJHeBGAQUabWV6Kt/VNsCgbXoXxEYi0f6x76tWOgWE8xPqU8MYuIZxuUDrv1bmCJznGTjBBkIs/R3chdMyna895MD6k7JDbyCYfdrFa7XSGs4HHOhUPzioTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978766; c=relaxed/simple;
	bh=UyA4gwJfNBtYA72mFz5c1xNj6vmnsqYQs1s1F0ZHQvo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TCgizkLaP58X1nQC6yy/h1WyJdm9v/dEEogGEIR8CPTJwSwRw5lZrx0gp+omhEexmOC40ub517ZNhyZbEmMBh9LIBOdeMQ4RSEQz+l0n9B2O7MZmxfIfTwC7kLXaFEAilED3Hsf5QHtDcgtvH5W2Es89tHUAS0q9YoHLKbKIHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3FYq64m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3FYq64m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863091F000FF;
	Wed,  9 Sep 2026 18:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788978765;
	bh=HiSTiY4oBPBZl2QbXfv+J4fnrrSwcXXY5KIB8y912DA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=K3FYq64mJdHOqsEEAK8pnGGzjfSFc5jNwDL02w4hp1WQVwJpNqukKoA5YsFCmKpAE
	 HY9d71MKnz0XIvZdBe3R10joRit5JCommqzvi986cIwrGLW/1J+e7K6OrRMbUNuJtr
	 440Wl1ol8pQ7YgbiTz8CGMk2w8A/xzgKh6yvXd0bCgTX0zLrzS891rhAMIeJW/n6C4
	 38azY53pe+v1bmXHJ+TQZIWCyX1Foa6aapZYOs0PU5LRBO0vsEe6ul1ES83ExYUZqZ
	 eC70jqY4/HoB/QVVewHrfB+1kssNdn5TU581ibvTa5wCjAIy2i96SvIoDCABTnl473
	 Z1R3DWgO936TA==
Subject:
 Re: [PATCH] netfilter: nf_conntrack_h323: fix OOB read in decode_enum()
From: netdev-bot+sashiko@kernel.org
To: elb12345@hotmail.co.uk
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Wed, 09 Sep 2026 18:32:44 +0000
Message-ID: <178897876404.219967.5503826011910199741@kernel.org>
In-Reply-To: =?utf-8?q?=3CAS8P251MB00011EEAA381DC17852BA37CC8B22=40AS8P251MB?=
 =?utf-8?q?0001=2EEURP251=2EPROD=2EOUTLOOK=2ECOM=3E?=
References: =?utf-8?q?=3CAS8P251MB00011EEAA381DC17852BA37CC8B22=40AS8P251MB0?=
 =?utf-8?q?001=2EEURP251=2EPROD=2EOUTLOOK=2ECOM=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] get_bitmap() dereferences one byte more than
  nf_h323_error_boundary() validates whenever l = bs->bit + b is an…

--

netfilter: nf_conntrack_h323: fix OOB read in decode_enum()

This adds a nf_h323_error_boundary(bs, 0, 1) check in decode_enum() before
the extension marker bit is read with get_bit(), matching what decode_seq()
and decode_choice() already do.  Without it, a truncated H.323 message can
cause a one-byte read past bs->end.

> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3507c..ba6ce1f04e1ed 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -363,6 +363,8 @@ static int decode_enum(struct bitstr *bs, const struct field_t *f,
>  {
>  	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
> +	if (nf_h323_error_boundary(bs, 0, 1))
> +		return H323_ERROR_BOUND;
>  	if ((f->attr & EXT) && get_bit(bs)) {
>  		INC_BITS(bs, 7);
>  	} else {

[Severity: Medium]
The check added here closes the decode_enum() case, but does the same
one-byte over-read remain reachable through get_bitmap()?

nf_h323_error_boundary() only rounds up when there is a partial byte:

	bits += bs->bit;
	bytes += bits / BITS_PER_BYTE;
	if (bits % BITS_PER_BYTE > 0)
		bytes++;

	if (bs->cur + bytes > bs->end)
		return 1;

So for bits + bs->bit == 16 it only requires bs->cur + 2 <= bs->end.

get_bitmap() with l == bs->bit + b == 16 consumes two bytes in the loop and
then dereferences a third:

	for (bytes = l >> 3, shift = 24, v = 0; bytes;
	     bytes--, shift -= 8)
		v |= (unsigned int)(*bs->cur++) << shift;

	if (l < 32) {
		v |= (unsigned int)(*bs->cur) << shift;
		v <<= bs->bit;
	}

The third byte is at bs->end.  The same holds for l == 24, where the loop
reads three bytes and the l < 32 branch reads a fourth.

The width is attacker controlled at the extension bitmap in decode_seq():

	bmp2_len = get_bits(bs, 7) + 1;
	if (nf_h323_error_boundary(bs, 0, bmp2_len))
		return H323_ERROR_BOUND;
	if (bmp2_len > 32)
		return H323_ERROR_RANGE;
	bmp2 = get_bitmap(bs, bmp2_len);

Picking bmp2_len = 16 - bs->bit keeps bmp2_len within 1..32 while making l
exactly 16, so the boundary check asks for two remaining bytes and
get_bitmap() touches a third.  The earlier bmp = get_bitmap(bs, f->sz) call
in decode_seq() has the same property whenever bs->bit + f->sz is 16 or 24,
with the width coming from the static field table.

The stray byte is masked off afterwards by:

	v &= 0xffffffff << (32 - b);

and bs->end stays inside h323_buffer or inside the skb linear area, so
nothing is corrupted or leaked, but it is the same class of read past the
intended end of the bitstream that the subject line describes.

Would it make sense to respin this covering the
nf_h323_error_boundary()/get_bitmap() accounting as well, so that the
decoder family is consistent?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/AS8P251MB00011EEAA381DC17852BA37CC8B22%40AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
