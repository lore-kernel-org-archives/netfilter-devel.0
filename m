Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C2938D3E5
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764152; cv=none; b=dylH91jeItX39mFgaELt4nFvdWQ51dJXGd6APfTYGuDhKpPRB3+cjIqTHoIjfu22258zaKl5iNj0MLH3m3FuyeeQ2ODkYRbogXJrBiWIdIy/efaK26H9R+BORqMnjI1On5Ud/otI/8Y8KvDbHKG2b6OqLp64CCtie8fd6BD5G/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764152; c=relaxed/simple;
	bh=GpmpSA+wJhq9XMvD6uJ1M+brW58Ptbg+555BbR3w48E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C8o97QCtjOkFPbwseWVlTS3/XoFIs7mCn3oJUl2nJ1V8jiTPxHs3bw9wye+nkhkvgnKjNE8v+xb5c1YY72FMn5OCRFTvxWWfH7343MPzjSH5vdMg3LDme+hcPp5mHwJdcJ267cJKcKpY5ErVtkA1syORrAjrJUhPeMkQ2XYz2mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XsidjwkM; arc=none smtp.client-ip=95.215.58.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XsidjwkM"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GpmpSA+wJhq9XMvD6uJ1M+brW58Ptbg+555BbR3w48E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764147; v=1; x=1789368947;
 b=XsidjwkMr1sIltqe74PWN2tvAtAdASdI0OuFtpSFtj2leOqsGNXSDf6Vo1gKkr03lTcrt7vT
 ItnJ3uyJ4BVw1tTGa3iUPk4oD5b9GKP7FUYIiRCrRpKv6f7USz9eCtm7DuWzLxcBWjbwLG4DMAA
 2HqYTKZ6dthzZiz6CEwJCL2k=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7e1d064e21304fbe;
	Mon, 07 Sep 2026 06:55:47 +0000
X-Mizu-Trace-ID: 7e1d064e21304fbe
X-Migadu-Flow: FLOW_OUT
Message-ID: <214d51c6-a71b-4b93-8dd7-6bd1c02b4c3f@linux.dev>
Date: Mon, 7 Sep 2026 14:56:13 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
To: Aamir Ahmed <elb12345@hotmail.co.uk>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Language: en-US
From: Chenguang Zhao <chenguang.zhao@linux.dev>
In-Reply-To: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


在 2026/9/7 07:37, Aamir Ahmed 写道:
> amanda_help() uses simple_strtoul() to parse the port number from
> Amanda CONNECT replies, passing the result directly through htons()
> into a __be16.  simple_strtoul() returns unsigned long, so values
> above 65535 are silently truncated by the implicit conversion to u16
> inside htons().
>
> The existing check "port == 0 || len > 5" is insufficient: it
> catches values that truncate to zero (e.g. 65536) and strings longer
> than 5 digits, but misses values 65537-99999 whose u16 truncation is
> non-zero.  For example, port 65537 becomes port 1, creating a
> conntrack expectation for an unintended port.
>
> Parse into an unsigned long and explicitly reject values above 65535
> before the htons() conversion, mirroring the pattern used by the FTP
> helper's get_port() and the recent IPVS FTP fix (commit
> e625a9477d12).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
> ---
>  net/netfilter/nf_conntrack_amanda.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
> index 14ae660491f3..057cef7e2a7e 100644
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
len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off) already
limits the length so that it cannot be greater than 5. Could the
len > 5 check here be dropped?
>  			break;
> +		port = htons(tmp_port);
>  
>  		exp = nf_ct_expect_alloc(ct);
>  		if (exp == NULL) {

The subject is "[PATCH] ...". Since this is a bugfix, please use "[PATCH net] ...".

Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>

Thanks

Chenguang

