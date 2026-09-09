Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890423E7BB4;
	Wed,  9 Sep 2026 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788946773; cv=none; b=lSoA1AigVz/SwydhPmiT2CQBKENrfyukifqIR0H+LCFojVeIteHLK9LWMa0SzXzFpNak+pQ/Z/CS73ESrFADQUvD129YeApNaG1EwQYFRhh8LWjbE0atrolCvrgFE+3W7ZwzfqkUUH+CXpeprFIIoHL2qFLmYh1uwfvu5s4Zr2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788946773; c=relaxed/simple;
	bh=fjKhVmcr/EyK4vU6sArnT209Vzr1k4r+UlW7jCrishk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MZY2QTKttm0Lcj72otXDkzn2KuWKFvt4BbFG2k3d0XOuzv/hcV9v1QjmR2V1qOfhqtaHgumWWxTZSLLIl6HaRr4XRu3Ngt5j4VrR1NU25uzbUdMn0KELeehbmcT/gnXAqciKRSGXkij/+/ORC2IedCaIId0tMQgeJeRW8MC3asE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiZItjS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiZItjS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506081F00A3F;
	Wed,  9 Sep 2026 09:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788946763;
	bh=N3lXI2lCWgiKvFN9Nv+hgXcmmvBtqm5fZVQQwl0WoDM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WiZItjS6ZXCBi++sMU+hy7N9lVH9ifMOX5REnYAb91AF2Cn1jrQjNUOhykxucZnFP
	 WMU9ijSCWyGbhtO0SNMmFscgqYkBr+XDo4T/s7T134wIkXiFJK/M6rZvuUinSm27ms
	 LEprg2QDdAnYV678w90vUt1T/xNxeG4kzxz92K11oRPBiZin4icdz6u4e9Txmqie39
	 kYPeqNqm1zLGxPgtYnQ18LMNmSltVyIHxOcv3+1zq6s8DvxsEl0vsrb3eMwnxTul+2
	 ahRBKWzdOkkUjWjv0q8YI0MvB/zCroVNlxepPZ19RdksBcqdvFduLzUFy2O/zs6yT0
	 77vtOfHDwosig==
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
From: netdev-bot+sashiko@kernel.org
To: elb12345@hotmail.co.uk
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kuba@kernel.org
Date: Wed, 09 Sep 2026 09:39:22 +0000
Message-ID: <178894676277.219967.1844924383954861310@kernel.org>
In-Reply-To: =?utf-8?q?=3CAS8P251MB0001CCFE2A0F40637E5A366CC8B32=40AS8P251MB?=
 =?utf-8?q?0001=2EEURP251=2EPROD=2EOUTLOOK=2ECOM=3E?=
References: =?utf-8?q?=3CAS8P251MB0001CCFE2A0F40637E5A366CC8B32=40AS8P251MB0?=
 =?utf-8?q?001=2EEURP251=2EPROD=2EOUTLOOK=2ECOM=3E?=
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
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] net/netfilter/nf_conntrack_amanda.c:amanda_help() — the new
  range check closes only the htons() truncation window for numbers that…

--

netfilter: conntrack_amanda: fix port value truncation

The patch parses the Amanda CONNECT port into an unsigned long and rejects
values above 65535 before the htons() conversion, instead of relying on the
old "port == 0 || len > 5" test.  A new tmp_port variable holds the
simple_strtoul() result.

> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
> index 14ae660491f36..057cef7e2a7ed 100644
> --- a/net/netfilter/nf_conntrack_amanda.c
> +++ b/net/netfilter/nf_conntrack_amanda.c
> @@ -91,6 +91,7 @@ static int amanda_help(struct sk_buff *skb,
>  	char pbuf[sizeof("65535")], *tmp;
>  	u16 len;
>  	__be16 port;
> +	unsigned long tmp_port;
>  	int ret = NF_ACCEPT;
>  	nf_nat_amanda_hook_fn *nf_nat_amanda;
>  
> @@ -132,10 +133,11 @@ static int amanda_help(struct sk_buff *skb,
>  			break;
>  		pbuf[len] = '\0';
>  
> -		port = htons(simple_strtoul(pbuf, &tmp, 10));
> +		tmp_port = simple_strtoul(pbuf, &tmp, 10);
>  		len = tmp - pbuf;
> -		if (port == 0 || len > 5)
> +		if (tmp_port == 0 || tmp_port > 65535 || len > 5)
>  			break;
> +		port = htons(tmp_port);

[Severity: High]
Can the new tmp_port > 65535 test ever fire, and does it close the case
described in the changelog?

In amanda_help(), the digit string is copied into a 6-byte buffer and the
copy length is clamped before parsing:

net/netfilter/nf_conntrack_amanda.c:amanda_help() {
	char pbuf[sizeof("65535")], *tmp;
	...
		len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
		if (skb_copy_bits(skb, off, pbuf, len))
			break;
		pbuf[len] = '\0';
}

So simple_strtoul() sees at most 5 characters, which bounds tmp_port at
99999 and bounds len = tmp - pbuf at 5.

For a reply payload of "CONNECT DATA 123456\n", pbuf becomes "12345",
tmp_port becomes 12345 and len becomes 5, so all three clauses of

		if (tmp_port == 0 || tmp_port > 65535 || len > 5)

pass and an expectation is installed for TCP port 12345 even though the
advertised value was 123456.  Isn't that the same "conntrack expectation
for an unintended port" the changelog is trying to eliminate, just via the
fixed-size copy rather than the u16 narrowing?

Would it make sense to also reject the token when the digit run is not
terminated inside the examined region, for example bailing out when
stop - off > sizeof(pbuf) - 1, or when the character following the parsed
digits is still a digit, the way the FTP helper's parsers require an
explicit terminator?

There is also a NAT-side effect of the clamp.  amanda_help() hands len to
the NAT hook as matchlen:

			ret = nf_nat_amanda(skb, ct, ctinfo, protoff,
					    off - dataoff, len, exp);

and net/netfilter/nf_nat_amanda.c:help() replaces exactly matchlen bytes:

	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
				      protoff, matchoff, matchlen,
				      buffer, strlen(buffer))) {

With a 6-digit advertisement, matchlen is 5, so only 5 of the 6 digit bytes
are rewritten and a trailing digit stays in the forwarded payload.  Should
the over-long digit run be rejected before reaching the NAT hook?

> +
>  		exp = nf_ct_expect_alloc(ct);
>  		if (exp == NULL) {

Separately, the changelog states:

  "The existing check "port == 0 || len > 5" is insufficient: it
   catches values that truncate to zero (e.g. 65536) and strings longer
   than 5 digits"

Given the min_t() clamp above, len can never exceed 5, so the len > 5
clause looks like it was already unreachable and cannot catch strings
longer than 5 digits.  Could that sentence be reworded, and should the
now-dead len > 5 clause be dropped or replaced by a real over-long check?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/AS8P251MB0001CCFE2A0F40637E5A366CC8B32%40AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
