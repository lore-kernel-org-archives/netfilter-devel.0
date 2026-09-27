Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F44E420496;
	Sun, 27 Sep 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790530626; cv=none; b=Hqcv8rVrQTjpHcFWaoLOO2defdhsa+rYSQOc/ROA1QjKYV4u6DpN2k4lkcvberLI24by2XSzeAPt4elE6v7zlC55z0lhKi6IMBFCGyU79S2VxHRDfQeUqftKeiUFSxmBkn1oPmMID0wOGpRiymTnUuvgrWq+xc4mufpZgS0Slis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790530626; c=relaxed/simple;
	bh=5EzslHkCQ+Ff7A8HdgxmwyWkRt7ZnEKxV8b826vnOqo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YKtj0A19J6PJm5z6uHRizmIUddwDy6csbil6DCLOZiwlvyD4xMgA/kC/eWTxjRDX/ym+Sp1lLhoguFPo02YKOvn1c2OB70aX52AmbZBxu8b4kDpHR9cKWvtlNbLOts5P/27LrPum4PXsWLd01om47BxeEVFeeNhLL5S21T0X/Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVSLo50J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVSLo50J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F081F000FF;
	Sun, 27 Sep 2026 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790530625;
	bh=E2vlPqFFmltpsu0OcQ2TYmItDyHwo154CK4rv1/BEA4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SVSLo50JcjHO8AXGPOXhScfiHTx1wrxuibxnjeCc+yXNo5tNRUroB5laKun0SYdw+
	 rXT8PKakRwjs+6VBy1zgA1C72vY+kmzZxzXDLankRyEcPgnHhw+xXLvsaSLf5J2B2n
	 dcW7tubeBWkQAEdP4zhLGF3A3rV5A+ZkZE3hvBTIts6a7wIywpvpcuYIT/5i0EoD1R
	 m0yw4OWu54LlZZgOw2fwT2nimRYz10GZqkH7M1e9c8KWf2TyLspG18idZjXjt7sqdo
	 D65T9cjQZl4ZUfDD9/NvQF5eIg0Rw6ajKTFrSvjb1oSp+bG0G9Nl/+tiIjRstdzQxT
	 oV+lrvRZfJF7A==
Subject: Re: [PATCH nf-next v4 3/4] netfilter: nf_conntrack_amanda: use
 nf_ct_helper_parse_port()
From: netdev-bot+sashiko@kernel.org
To: rc@rexion.ai
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Date: Sun, 27 Sep 2026 17:37:03 +0000
Message-ID: <179053062399.2160803.9591526412956900613@kernel.org>
In-Reply-To: <20260923151501.3093863-1-rc@rexion.ai>
References: <20260923151501.3093863-1-rc@rexion.ai>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] amanda_help() in net/netfilter/nf_conntrack_amanda.c still
  silently cuts a port field of six or more digits down to a different,…

--

netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()

This patch replaces the simple_strtoul() + htons() port parsing in
amanda_help() with nf_ct_helper_parse_port(). The goal is to reject port 0
and values above 65535 instead of silently truncating them to a u16. The
NAT mangle length is still taken from the parser's end pointer.

> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
> index 14ae660491f36..f157c96b7d223 100644
> --- a/net/netfilter/nf_conntrack_amanda.c
> +++ b/net/netfilter/nf_conntrack_amanda.c
> @@ -89,7 +89,7 @@ static int amanda_help(struct sk_buff *skb,
>  	struct nf_conntrack_tuple *tuple;
>  	unsigned int dataoff, start, stop, off, i;
>  	char pbuf[sizeof("65535")], *tmp;
> -	u16 len;
> +	u16 len, parsed_port;
>  	__be16 port;
>  	int ret = NF_ACCEPT;
>  	nf_nat_amanda_hook_fn *nf_nat_amanda;
> @@ -132,10 +132,10 @@ static int amanda_help(struct sk_buff *skb,
>  			break;
>  		pbuf[len] = '\0';
>  
> -		port = htons(simple_strtoul(pbuf, &tmp, 10));
> -		len = tmp - pbuf;
> -		if (port == 0 || len > 5)
> +		if (nf_ct_helper_parse_port(pbuf, len, &parsed_port, &tmp))
>  			break;
> +		port = htons(parsed_port);
> +		len = tmp - pbuf;

[Severity: High]
Can a port field with six or more digits still be truncated into a
different valid port here?

pbuf is only 6 bytes, and just before this hunk amanda_help() caps the
copy at 5 bytes:

	len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
	if (skb_copy_bits(skb, off, pbuf, len))
		break;
	pbuf[len] = '\0';

So nf_ct_helper_parse_port(pbuf, 5, ...) only ever sees the first five
digits. The range check there only covers the len bytes it is given:

net/netfilter/nf_conntrack_helper.c:nf_ct_helper_parse_port() {
	val = nf_ct_helper_parse_uint(cp, len, &e);
	if (e == cp || val == 0 || val > 65535)
		return -1;
}

Nothing checks whether skb byte off + len is another digit. So a reply
such as "CONNECT ... DATA 123456\n" would be accepted as port 12345. In
the same way, 100000 would become 10000 and 655350 would become 65535.
nf_ct_expect_init() would then install a TCP expectation for a port that
never appeared on the wire.

On the NAT path, len = tmp - pbuf is 5 and is passed as matchlen.
help() in net/netfilter/nf_nat_amanda.c then does:

	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
				      protoff, matchoff, matchlen,
				      buffer, strlen(buffer))) {

Only the first 5 bytes get replaced, so the extra digit stays in the
payload. For example, a NAT-chosen port of 40000 would come out as
"400006", which no longer matches the expectation.

The commit message says:

    The digit string is copied into a 6-byte buffer,
    so at most five digits are parsed, but values 65536-99999 still truncated

and:

    Use nf_ct_helper_parse_port(), which rejects port 0 and values above
    65535 in one call.

With the 5-byte window, is that accurate? Values above 99999 are also
above 65535, and they still truncate through the window instead of being
rejected. The later commit "netfilter: nf_conntrack_sip: use shared
helper parsers" in this series does not touch amanda, so this code is
unchanged at the end of the series.

Would it work to copy one extra byte into pbuf, or to check that skb
byte off + len is not a digit, and reject the field when the digit run
is longer than five characters?

>  
>  		exp = nf_ct_expect_alloc(ct);
>  		if (exp == NULL) {

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923091608.2617604-1-rc%40rexion.ai
