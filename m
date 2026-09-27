Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE1241D65C;
	Sun, 27 Sep 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790530625; cv=none; b=F0WIRqtuyctqUHjMpbW8aEHB2DUDiK1qU/qIPE7gDAz1BttqtyXa+PfUxGIFWcZZwMb2HK4a9tiOUL0eHGlNlVICpJq+TuFrJLDGCWt6I8FXxVNfE8avdnwe2KpoUnoO2GWXcgerf38/5OQWuKcVvi2RabiXj0fhhylQ4aAMeGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790530625; c=relaxed/simple;
	bh=I37xeJizNVOxXq4vuFCOuQDoq9sBcegC1TST2EysRow=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KLicFJ2nvacbSlE67nmL326Qsr9cdP/psoBt9PIOiOrVdoKEGztEPHOCXN80yatvumeij20aXqfan6G5H0DRw8bwWetnE110IauCIg4v66kG1Ope5Do/W42QGMzFvFbaMhrFiWCyBbPS9gNoS/xxUaDe+Tjeiq7BdJbfTq2zNh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3DtJbUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3DtJbUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9181F00893;
	Sun, 27 Sep 2026 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790530623;
	bh=VXXRb+sL4j3+MN/0wjm8N6gNaqw0t3Q06vWHwnuDYZc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e3DtJbUqB3xboo4oGM0lEUiO6vAMlqO5A98QKbaYSA5UkCnGDUQ0VmbTGnHoEnL6A
	 xQgc582dP/OkjlaaK+cXRAXtk3vKmxSYqqFO0w6hs9e7BR7WxqP0/QsKK00yJVezV2
	 hd4xMM1/IrxZKqvM4Sf5S1zHN3V8aMpYRyeoRmgRMCMXJXmquuKzxGIPZSzY5UUKI2
	 8JVsgakQNfbHirQzdBCbrpb6XeqNV3qXjMbiUn45tEb39ib8l/Ed26wScwPhY4v7XX
	 RIWot55wigAfTi8mdc1H0LTXplY5o9MNyHBskfJEzTbQ5NdEmdmmucgcUSwZJxcEuf
	 HxrTXFt3ATvVw==
Subject: Re: [PATCH nf-next v4 2/4] netfilter: nf_conntrack_irc: use
 nf_ct_helper_parse_port()
From: netdev-bot+sashiko@kernel.org
To: rc@rexion.ai
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Date: Sun, 27 Sep 2026 17:37:02 +0000
Message-ID: <179053062273.2160803.6696795410529862010@kernel.org>
In-Reply-To: <20260923131501.2934482-1-rc@rexion.ai>
References: <20260923131501.2934482-1-rc@rexion.ai>
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

- [Low] After this patch, the `|| dcc_port == 0` test in help()
  (net/netfilter/nf_conntrack_irc.c) can never be true.
- [Low] Switching parse_dcc() to nf_ct_helper_parse_port() adds a digit-
  count limit to DCC port parsing that the kernel-doc does not describe.

--

netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()

This commit replaces simple_strtoul() in parse_dcc() with
nf_ct_helper_parse_port(). DCC ports above 65535 are no longer silently
truncated into the u16 port. The new helper parses a length-delimited
buffer and rejects port 0 and values above 65535.

> diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
> index 92360963757a9..268ce7c1f9b23 100644
> --- a/net/netfilter/nf_conntrack_irc.c
> +++ b/net/netfilter/nf_conntrack_irc.c
> @@ -88,7 +88,9 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  		data++;
>  	}
>  
> -	*port = simple_strtoul(data, &data, 10);
> +	if (nf_ct_helper_parse_port(data, data_end - data, port, &data))
> +		return -1;

[Severity: Low]

nf_ct_helper_parse_port() now returns -1 when val == 0. Can the
dcc_port == 0 test in help() still be true after that?

net/netfilter/nf_conntrack_irc.c:help() {
    ...
			if ((tuple->src.u3.ip != dcc_ip &&
			     ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) ||
			    dcc_port == 0) {
				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
    ...
}

Before this patch, each of these inputs left dcc_port at 0: a port of
"0", a non-numeric port, or a value that truncated to 0 such as 65536.
In those cases parse_dcc() succeeded, and help() printed the ratelimited
"Forged DCC command" warning before goto out.

Now those commands fail in parse_dcc(), and help() takes this path
instead:

			if (parse_dcc(data, data_limit, &dcc_ip,
				       &dcc_port, &addr_beg_p, &addr_end_p)) {
				pr_debug("unable to parse dcc command\n");
				goto out;
			}

The result is the same either way: no expectation is created and the
packet gets NF_ACCEPT. The only difference is that the warning is no
longer printed. The dcc_port == 0 clause is still in help() at the end
of the series.

Should that clause be removed, with the logging change mentioned in the
commit message? Reverse/passive DCC also uses port 0, so it may be fine
to drop the "Forged" warning.

[Severity: Low]

Does this also reject in-range ports written with leading zeros?
nf_ct_helper_parse_uint() clamps len to 11 and counts every digit it
consumes, including leading zeros:

net/netfilter/nf_conntrack_helper.c:nf_ct_helper_parse_uint() {
	const unsigned int max = sizeof("4294967295");
    ...
	if (len > max)
		len = max;

	while (olen > 0 && isdigit(*s)) {
		unsigned int value;

		if (len == 0)
			goto err;
    ...
}

A DCC port such as "000000000001" reaches goto err on the 12th digit,
so parse_dcc() returns -1. simple_strtoul() used to accept that string
as port 1. help() now does goto out without creating an expectation or
calling the NAT hook.

The kernel-doc for nf_ct_helper_parse_uint() lists only two failure
cases: "no digit is found or the value would exceed UINT_MAX". The
comment for nf_ct_helper_parse_port() says "no digit is found or the
value is out of range". Neither one mentions the digit limit.

This logic comes from sip_strtouint(), so SIP already behaves this way,
but IRC did not. Real DCC clients probably don't zero-pad ports like
this. Could the helper documentation, or this commit message, mention
the limit?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923091608.2617604-1-rc%40rexion.ai
