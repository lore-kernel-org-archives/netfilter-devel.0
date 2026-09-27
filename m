Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C746C3290B7;
	Sun, 27 Sep 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790530630; cv=none; b=l12evZ0uGVz0jUDONvq2pupHQjWKb1wAkfjRMZBo3Qpbzz3J3nhvLQjWx9cAzpTWgNI6mSnj2YRi6dl5MmJMKpAMWbhoW70bh0mPexlVzC7umG+ejvkvkXO/odIwiuaorBJoB4mb2NjymaJiqn+D24ejLYwDWNsybHxc6z9S+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790530630; c=relaxed/simple;
	bh=NPH1JMV8CSWl+ZXSUjg5HmyTtc+DZ39hCmWb5Lw5gWU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h4hDDlSN3xf83ODCdHke0lwqGQWe/Js5lyhOR7Hxu1eU3pdeYzv8gzD0Sa+86T+YfYeFPK+UN+MQ+mbQr0H4TDAFJoLfdE/Z9OJGgwwX436ECn7aOWFTwPYCLQk/rlE5LL3ntuVStMS4lGo66+VTlnhz1rZNBfwxVren0uD++ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQsIXA4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQsIXA4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C536A1F00893;
	Sun, 27 Sep 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790530626;
	bh=+ESq2+ZtM3KyCClSZigX4CznLK6C+Qxn12joyNbMmiE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fQsIXA4snPiqwkIkXs0E9u0YvCFfSRrWkF5ujv5YdqNvpbuW3Be1q0FjBkwc8W9uq
	 E04VIp9vrVHgdrgpMlAqoQyrsz/8m3GJmwFMo4i7VdtjUSrmOlyQ4/P+xTPFOsnuk7
	 vX3PlGmu4RVtyaX3DyA9evmr/nhLdHlju3RG8MWXV/IEi5TSAJgaOzjB7Gt/B867gH
	 jTUMoY2puEDfiOCClrfRsVYKTQK9mkKioOnrziB/a4LfAJA/KzZC4wBD0nkjinDgiA
	 ERhNXh+mnA8448NG78SfpWpD7b2zW0c7ELbppZWy6tSPKeFZj8qw5ErsTgcaIutOs9
	 wJkuriiFvEx0g==
Subject: Re: [PATCH nf-next v4 4/4] netfilter: nf_conntrack_sip: use shared
 helper parsers
From: netdev-bot+sashiko@kernel.org
To: rc@rexion.ai
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Date: Sun, 27 Sep 2026 17:37:05 +0000
Message-ID: <179053062534.2160803.18214039590923264255@kernel.org>
In-Reply-To: <20260923171501.3254823-1-rc@rexion.ai>
References: <20260923171501.3254823-1-rc@rexion.ai>
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says "No functional change intended", but
  the patch changes how sip_parse_port() in…

--

netfilter: nf_conntrack_sip: use shared helper parsers

This patch removes the SIP helper's private sip_strtouint() and switches
its callers to nf_ct_helper_parse_uint(). The digit loop in
sip_parse_port() is replaced with nf_ct_helper_parse_port(), while the
SIP-specific handling of ':', the SIP_PORT default and the 1024 minimum
stay in place. The commit message says no functional change is intended.

> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 64bc440b1181f..0e12426227a80 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c

[ ... ]

> @@ -199,29 +199,22 @@ static bool sip_parse_port(const char *dptr, const char **endp,
>  
>  	dptr++; /* skip ':' */
>  
> -	while (dptr < limit && isdigit(*dptr)) {
> -		p = p * 10 + (*dptr - '0');
> -		dptr++;
> -		len++;
> -		if (len > 5) /* max "65535" */
> -			return false;
> -	}
> -
> -	if (len == 0)
> +	if (nf_ct_helper_parse_port(dptr, limit - dptr, &p, &end))
>  		return false;

[Severity: Medium]
Does this change which ports sip_parse_port() accepts?

The old loop counted digits and returned false once there were more than
five, whatever the value. That rejected zero-padded ports such as
"sip:1.2.3.4:0005060".

The shared helper only checks the value:

net/netfilter/nf_conntrack_helper.c:nf_ct_helper_parse_port() {
    ...
	val = nf_ct_helper_parse_uint(cp, len, &e);
	if (e == cp || val == 0 || val > 65535)
		return -1;
    ...
}

nf_ct_helper_parse_uint() caps the digit count only at
sizeof("4294967295"), which is 11. As a result, ports of 6 to 11 digits
with leading zeros, such as ":0005060" or ":00000065535", now parse.

That appears to change the outcome for the same packet in several
callers:

  - ct_sip_parse_header_uri() used to return -1 for these strings, and
    process_register_request() and process_register_response() then
    returned NF_DROP with "cannot parse contact". It now returns 1, so a
    REGISTER request creates a signalling expectation:

    sip_help_udp/tcp()->process_sip_msg()->process_sip_request()->
      process_register_request()->ct_sip_parse_header_uri()->
        sip_parse_port()

  - ct_sip_parse_request() used to return -1 and now succeeds.

  - epaddr_len() and skp_epaddr_len(), the match_len callbacks used by
    ct_sip_get_header() and ct_sip_walk_headers(), used to return 0,
    which made the lookup return -1. Now the header matches with a
    longer matchlen, and nf_nat_sip mangles that range.

  - process_sip_request() may now set ct_sip_info->forced_dport from a
    zero-padded Via header that it used to ignore.

The sip_strtouint() to nf_ct_helper_parse_uint() swap looks identical.
The sip_parse_port() conversion is not, and the commit message quoted
below does not mention it:

  "No functional change intended."

Should the old limit be kept, for example by rejecting end - dptr > 5?
Otherwise, could the commit message document that leading zeros are now
accepted?

>  
>  	/* reached limit while parsing port */
> -	if (dptr >= limit)
> +	if (end >= limit)
>  		return false;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923091608.2617604-1-rc%40rexion.ai
