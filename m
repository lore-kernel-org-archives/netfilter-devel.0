Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD2C428470;
	Wed,  9 Sep 2026 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788990030; cv=none; b=mXtwFeWM2+/R1eXPQR62cFB+/xMi72xpnrtx7Atw1Z5gNzzd3L91HaxFwCNq1VrbASoUQvIRonGcwxzeBqC5qRiejQBnVbHLrY8rl+nXGXJjz/E+e5bd9n3LPV37JWKkMB3Hrmh9eCwZCfbIc2IloZ/aX+oQlqMZdXELsflr3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788990030; c=relaxed/simple;
	bh=iLRTGvcbRVPxvDEotXdqrfpEIK0u7OW44TSaNXoVxvM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G2QyT18iAkUwSXPwKN94J6QXr1ns9ZRJcJRFPlj+grspyrBzOzwEz8wOLXPh+y+BHLI+BFi8vIowQgD4ZvekQHYEK4qoyNGwl1xnfxdIhuOkyf7NiX6JY3MNplTuvlPAvsX4Qx8y5FrVkgqgJtDHvDZEGs/D5Wl2AmtwWI4o3U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOL/sBtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOL/sBtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210C31F00893;
	Wed,  9 Sep 2026 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788990014;
	bh=x7KwwqJ4/lIetO8pwNsdhdaL/gdEblfES9CSS1fXvE8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iOL/sBttvbEthp8aUQchU8wxkfojODO/8wQt7PsSZdcqcoUSfDtJ85qLBzkR8MVFE
	 +D94qAO/aIjdM18s8Z3sqr/WjCDUKQzguZM2+5Ku3CzNDFGAPt6IXlfzubGLe723Gp
	 hqSo4NKTyyl7fa43KS4s4C+uL3r4+MmjEx75ToqGJSpAxIWGI/mIaWcqjpJxY7uiYc
	 9jQQrlC/hibLZvNcLYcKErvVf1zZKpdp3js8sZds4FxOzU/2K523tYHepMqAAkw3Lb
	 f5euBxlC7PgACwohtu9a5fEa4OR37sHCPxS6EWd93aq+LqK3f43MQTIOOF6BALy2I4
	 mXWK7owvzLSPQ==
Subject: Re: [PATCH] netfilter: conntrack_irc: fix port value truncation in
 parse_dcc()
From: netdev-bot+sashiko@kernel.org
To: elb12345@hotmail.co.uk
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kuba@kernel.org
Date: Wed, 09 Sep 2026 21:40:13 +0000
Message-ID: <178899001368.219967.734841882054887472@kernel.org>
In-Reply-To: =?utf-8?q?=3CAS8P251MB0001B81958B28F762352EF3DC8B32=40AS8P251MB?=
 =?utf-8?q?0001=2EEURP251=2EPROD=2EOUTLOOK=2ECOM=3E?=
References: =?utf-8?q?=3CAS8P251MB0001B81958B28F762352EF3DC8B32=40AS8P251MB0?=
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

- [High] Incomplete fix: in parse_dcc()
  (net/netfilter/nf_conntrack_irc.c:92-95) the new bound check is…

--

netfilter: conntrack_irc: fix port value truncation in parse_dcc()

This adds a bound check to the DCC port parsing in parse_dcc() so that
values above 65535 are rejected instead of being silently truncated into
the u16 output.  The stated goal is to prevent a conntrack expectation
being created for a port that never appeared in the DCC command.

> diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
> index 92360963757a9..8321f12dbf155 100644
> --- a/net/netfilter/nf_conntrack_irc.c
> +++ b/net/netfilter/nf_conntrack_irc.c
> @@ -64,6 +64,7 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
>  {
>  	char *tmp;
> +	unsigned long tmp_port;

[Severity: High]
Is unsigned long wide enough here on 32-bit builds?

> @@ -88,7 +89,10 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  		data++;
>  	}
>  
> -	*port = simple_strtoul(data, &data, 10);
> +	tmp_port = simple_strtoul(data, &data, 10);
> +	if (tmp_port > 65535)
> +		return -1;
> +	*port = tmp_port;

Does the truncation still happen before the new check runs on ILP32
(i386, ARM32, MIPS32), where unsigned long is 32 bits?

simple_strtoul() itself narrows:

lib/vsprintf.c:
unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
{
	return simple_strtoull(cp, endp, base);
}

And _parse_integer_limit() in lib/kstrtox.c only saturates to ULLONG_MAX
when check_mul_overflow()/check_add_overflow() fire, so a value in the
2^32 range is returned exactly as a 64-bit result:

		if (unlikely(res & (~0ull << 60))) {
			if (check_mul_overflow(res, base, &res) ||
			    check_add_overflow(res, val, &res)) {
				res = ULLONG_MAX;
				overflow = KSTRTOX_OVERFLOW;

So for a DCC field of "4294967297", would the 64-bit 0x1_00000001 be
narrowed to 1 by the assignment into tmp_port, making tmp_port > 65535
false and leaving *port == 1?

If so, the path in help() would still be reached with a port that was
never in the command, since the only remaining guard is dcc_port == 0:

net/netfilter/nf_conntrack_irc.c:help() {
	...
			    dcc_port == 0) {
	...
			port = htons(dcc_port);
			nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
					  tuple->src.l3num,
					  NULL, &tuple->dst.u3,
					  IPPROTO_TCP, NULL, &port);
	...
}

The input here is remote IRC payload copied into irc_buffer by help(),
and parse_dcc() only requires a '\n' inside the buffer, so a payload of
the form "PRIVMSG x :\1DCC SEND t <ip> 4294967297\1\n" reaches this
parse.

The commit message says this follows nf_conntrack_ftp:

  "The nf_conntrack_ftp helper had the same class of defect and was fixed
  by using a wider accumulator with a range check (get_port checks
  tmp_port > 65535).  Apply the same pattern here"

Is that equivalent, though?  get_port() uses a fixed-width u32 and
re-tests after every digit, so it cannot be affected by the width of
unsigned long:

net/netfilter/nf_conntrack_ftp.c:get_port() {
	u32 tmp_port = 0;
	...
		} else if (data[i] >= '0' && data[i] <= '9') {
			tmp_port = tmp_port*10 + data[i] - '0';
			if (tmp_port > 65535)
				break;
	...
}

Would a width-independent form work better here, for example parsing
with simple_strtoull() into an unsigned long long, using kstrtou16() and
checking for -ERANGE, or the ftp-style per-digit bound?

>  	*ad_end_p = data;
>  
>  	return 0;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/AS8P251MB0001B81958B28F762352EF3DC8B32%40AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
