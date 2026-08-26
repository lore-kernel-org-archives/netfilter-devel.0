Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE9357CFA;
	Wed, 26 Aug 2026 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787764941; cv=none; b=LkGTWQ5hvHd4YFCRQm8JVMdxEq+9309syQYIJqHS1gKl/xeCuw6S5dysfiMkW4nXyef2Rrh+eqGkqLGdOJdgnhVSycCzML5JPQP8V7ZQnsAbhVL7VPesQpTwPnhj+H28dGETQLax0ph81negx4aEx4sNm6ZfZ4C57JgF+0vCgJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787764941; c=relaxed/simple;
	bh=xm90s1d0AKYkw+yeXHP8vErY/xzXMyujQ56myC4Oz7g=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=B/jxBe/pe1EAC0euaxBYn0WSzUhDertTn7yNL067PB1Lfm0g14obxRo/YMiPp4IkUIdhpFxz6Wb9Xvegx4VuKmyS3Z6xTR9NzMPbAYoTP7XzJpc2OIbMP6b+aLt3uiKKJprkTcoDLbSSBvIGqBVEnkG6y0eBlA6LyJboGXWnJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=cKBWgSQ4; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="cKBWgSQ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1787764925;
	bh=xm90s1d0AKYkw+yeXHP8vErY/xzXMyujQ56myC4Oz7g=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=cKBWgSQ4uH5wIjTKbJLmPSA4m+WXocr5mXOU+8iI1EyF2/YviK++67256+gfo24/y
	 YD70o6ElUID2JrDgyDMjx0phtgFaDybOJhPbmZWSidJkgchKoKxjpWkxwpmBqsG16e
	 aBUtfPZbgvON9NkPZ+sqNI7o1zk2jHMVnlP7Y7jup90lfbP6BYt/6kzLl0Zar26t1T
	 +0fw/UPXM1jtUe5GeblqzSjXtt+n9GZMnLfl8kz3SXGVIjt+P6lrLpJRfAhA/QW3cm
	 A2nT8m0EeQ3ngT1u6TbCF+mgYkZblpw1yMP7BCCvD1s+1oXP69sX++NGt1EMRi1KK+
	 orBiBHC9SITPw==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id A78B960075;
	Wed, 26 Aug 2026 17:21:37 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by x201s (Postfix) with ESMTP id AB16820079C;
	Wed, 26 Aug 2026 17:20:47 +0000 (UTC)
Message-ID: <94842eea-a296-4ab9-a026-2475757a82b8@fiberby.net>
Date: Wed, 26 Aug 2026 17:20:47 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Subject: Re: [PATCH net] netlink: specs: fix the conntrack filter type
To: Ilya Maximets <i.maximets@ovn.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>,
 "Remy D. Farley" <one-d-wide@protonmail.com>,
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260825155832.3685714-1-i.maximets@ovn.org>
Content-Language: en-US
In-Reply-To: <20260825155832.3685714-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 3:58 PM, Ilya Maximets wrote:
> The CTA_FILTER doesn't contain nested tuple attributes, instead it
> contains bit masks that specify which tuple attributes to filter on.
> The values for filtering are taken from the top-level CTA_TUPLE_ORIG
> and CTA_TUPLE_REPLY.

As identified by Sashiko-NIPA[1], then CTA_TUPLE_ORIG and CTA_TUPLE_REPLY
are both absent from the GET DUMP request attribute list.

However this doesn't prevent ynl CLI from sending the attributes:

$ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
   '{"nfgen-family": 2, "filter": {"orig-flags": 1}}'
Netlink error: Invalid argument

$ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
'{"nfgen-family": 2, "filter": {"orig-flags": 1}, "tuple-orig": {"tuple-ip": {"ip-v4-src": "192.255.0.255", "ip-v4-dst": 
"192.255.255.0"}}}'
[]

Otherwise, LGTM.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260825155832.3685714-1-i.maximets%40ovn.org
