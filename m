Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E283D3A1684;
	Sun, 27 Sep 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790530624; cv=none; b=d1s/qRL0QMB0dRvMXunhUz4fv1RG2c+xhewLF4KZj20qzE588koVp7VDSOwyPbzd7aInJc6cA2Y8+KPCj3Ze31nAy+KJ0bW2C+ylhI6kgAZLFccHKDk/YhE1ysQuLXyi53x5kNOdrbxo7+/fQOrMXG+S75BMTAaURGIiiOq8Qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790530624; c=relaxed/simple;
	bh=FRV3kOC5ng4xx1VVIdyMZFIT1aGrZ1JEW7T/M4jaoeg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qlQfM0gIzt85iiaNlD1b/q20CrRZ93tvPMr1oT85AQ9pPhb7HoKA2NHaQWHlUw7W3vxMMdFRosRUkBqASVZtaVvPS5CFJBfLVMz/R6PrpVS3+XInGqQtnAj8TdiwylFuUPR28npPLa7jOeFhXyxdTd1w1VL6BfKjbhYlu44kNZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgQFAoPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgQFAoPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17D81F000FF;
	Sun, 27 Sep 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790530622;
	bh=kXa5Wemf2rr6lVNbX1SR73AsnwkD06yw2lH7iF1TrnI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dgQFAoPsfcWTaRVcCva92YF0I49eODUHvt0AXQXoHCOKZU/rV5JXl46Uwe7UcWblq
	 6TgFnP8cIVAu5v6/CbCqRME/fgWBllarLXK0sr5DKSNyO/4+LnNDqCSveUIAApeaBJ
	 nX9LZEMAcibfu4/ElzDWUKqU47nqVneo7+GWnTxUOb6SwEa4NbkQL2ZCcqeBBt3uIS
	 xx4AaTzlqDtMu2TQsljlz7/L3ImgYzPg2O0YBtNWN7OeBiXPPkPC7noIHc5PNzGzsk
	 xgDHg10WlNx2avrJIBpKSi9IvfCjZ0VzRr2+RaVFD8AsrpYgm6mdojhwjT025R5j5G
	 RBrO87U+pg+Hw==
Subject: Re: [PATCH nf-next v4 1/4] netfilter: conntrack: add shared uint and
 port parsers for helpers
From: netdev-bot+sashiko@kernel.org
To: rc@rexion.ai
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Date: Sun, 27 Sep 2026 17:37:01 +0000
Message-ID: <179053062118.2160803.7576370507948039473@kernel.org>
In-Reply-To: <20260923120738.2844168-1-rc@rexion.ai>
References: <20260923120738.2844168-1-rc@rexion.ai>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] nf_ct_helper_parse_uint() rejects any run of 12 or more digits,
  even when the value fits in UINT_MAX, and neither comment mentions…

--

netfilter: conntrack: add shared uint and port parsers for helpers

This commit adds nf_ct_helper_parse_uint() and nf_ct_helper_parse_port()
to the conntrack helper core. Both parse decimal numbers from a buffer of
a given length. The uint parser body is taken from sip_strtouint(), and
both functions are exported for the IRC, Amanda and SIP helpers.

> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index c30ae3f203bee..99b90a54d8a9f 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c

[ ... ]

> @@ -569,6 +570,73 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
>  
> +/* Parse a decimal unsigned integer from a length-delimited buffer that is not
> + * necessarily NUL-terminated.  At most @len bytes are examined.  On success
> + * the parsed value is returned and, if @endp is non-NULL, *@endp points just
> + * past the last digit consumed.  If no digit is found or the value would
> + * exceed UINT_MAX, 0 is returned and *@endp is set to @cp.
> + */
> +unsigned int nf_ct_helper_parse_uint(const char *cp, unsigned int len,
> +				     char **endp)
> +{
> +	const unsigned int max = sizeof("4294967295");
> +	unsigned int olen = len;
> +	const char *s = cp;
> +	u64 result = 0;
> +
> +	if (len > max)
> +		len = max;
> +
> +	while (olen > 0 && isdigit(*s)) {
> +		unsigned int value;
> +
> +		if (len == 0)
> +			goto err;

[Severity: Low]
Should a run of 12 or more digits be rejected here when the value still
fits in UINT_MAX?

max is sizeof("4294967295"), which is 11 because sizeof counts the NUL.
For longer inputs, len is clamped to 11 while olen keeps the real length.

The loop condition only checks olen and isdigit(). So a 12th digit enters
the loop and finds len == 0. It then takes the err path, which returns 0
and sets *endp to cp.

With leading zeros, result stays small, so this failure comes only from
the digit count. The count limit does not seem to add overflow
protection. result is a u64 and is compared against UINT_MAX after every
digit.

The comment above lists only "no digit is found" and "exceed UINT_MAX" as
failure cases. The nf_ct_helper_parse_port() comment lists only "no digit
is found" and "out of range".

nf_ct_helper_parse_port() treats e == cp as a failure:

	val = nf_ct_helper_parse_uint(cp, len, &e);
	if (e == cp || val == 0 || val > 65535)
		return -1;

So an input like "000000000080" returns -1 there.

This logic came from sip_strtouint(), but it is now a general exported
API. Later in the series, "netfilter: nf_conntrack_irc: use
nf_ct_helper_parse_port()" replaces simple_strtoul() in parse_dcc().
simple_strtoul() accepted any number of leading zeros.

Would a DCC command such as "DCC SEND f <ip> 0000000000006667" then fail
to parse, so that no expectation is created for it?

Amanda does not look affected, because pbuf limits its input to 5
characters.

Could the digit-count limit be dropped, or else documented in both
comments?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923091608.2617604-1-rc%40rexion.ai
