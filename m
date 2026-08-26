Received: from mail-ej2-f10.google.com (mail-ej2-f10.google.com [74.125.228.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433F311C32
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769513; cv=none; b=RbtZdzyacpumX+RaISwgwinmebQm4Y5pzNgtLb9L+8wzwAt1R46KqFruRZtiydWXvqWuRpcu79ztCaTi31bgB1ZIuluJeCkL6lF3NsO1DrCWSc3b9chxQtM7nvdQhSPwZPU9LCPQAqxOXfRuCYo5HknO2GPMskMtcFhSNyAOGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769513; c=relaxed/simple;
	bh=rvhP7RaXDz6UJcdy0LpafQ28K6Jx0UmNaixps3g6iSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nliU0piHA+KyB2H2UYyx2oh0b6O3nUH71crHCDEMmCn5CX99SEevZNofN8U3Lbjj24WwnTJ5ivdp5OrfJ1J/wH6Z9NPoWOYfvbdz0mOoeoTObmEHO6ZbY0qz84nxA21ttr3qUj4GztcslFzDhb+tunGckGdSZq8QYn9UTvkqVfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f10.google.com with SMTP id a640c23a62f3a-c213bf6ad5bso53252866b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 11:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787769498; x=1788374298;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uQAJ6HWMnaptEaDKWJ2YFOon5oDggMOJCWfPqpLuh7Y=;
        b=p49Lyw9xGvY0XLkm3GJLmHIIhVjSupFfJP6yhHw/9xnvaiZIKxTpgNbefcj69LCTVV
         NXsTtqP8zj9d8kSIwWTkgVoXFlLkzr09gZNEb0+xzY0LROTlPl3jnp8swxVJfJdKxibT
         kPRhJpYKPUw6MF+9+JCP9zrqU7NVs1TnirIDiiKFWRmHafJhceW+WY+HdKbgt2Hw6eGV
         ED9Cm56o2nAATalPvdQkpG4GZ7ZeJKdsDWlNlKcLksq4tRhWWPvizGHNsChiEsP5x7+a
         wOfgw/WIAOJBvDLfiYSL9XZ1ka8OLOlB9krwIlDoVpIS6L7d5K7yRRIhX2nHzWTpQywS
         wzow==
X-Forwarded-Encrypted: i=1; AHgh+RqgnLHMfy9oLl76JZTuhH2Ruq/D6qZzArP8HxkIizRJe+KL9VWvpGZ+l1QLNdkKsWGiANTGdDiciJOJ+CXgS1w=@vger.kernel.org
X-Gm-Message-State: AFuF++kDdIIPvKSfXv/OeNGVepLSJTgRc4lk6WjG3kxcU/X7M1YLx5WU
	k+70Xy/owNH/pUzLGWk0Qo3WcTbm0trBJTHcl70S57ZVi6EpxLnDYUEw
X-Gm-Gg: AR+sD114iArlkfTL5vr0NmpBv0VySk6+F+uRFfHn6TVZYiyHM1lVqo4Yr/OguOeScUp
	S5Rsns4O/n41GUheKYHJIDt6JDDcKXp/FZCvbjCVF1C6bI11/TzmICyUx6fs6tb/nR5DYN2C0aC
	XNLa053LnktFpVRYidDq03k8MdWLEyJdnwpdR9ajGGsUKkkcyhIGdhWaqAjAO+JSv6FgkSwOT63
	JocbgSGhGzL3oDXOzUwdNNVhkRRXh1fR00edKdRpVaGtXghnjyfB2exQVR+hKMq1Zi/29ox7Qf+
	9eDQ5uidtKDA7mGuMyvpjjGXmxhRf0/uEyFfCiX4uSpGJzNId1lClnaMcUbE9MarmiLM/Mop55d
	e5WuMAo5esN8qwZKhgUODWInB4QeZ2yUWcWIfaaPVK1cUW5ZGJ7oNejEQwBYzSSR9ig/rGN11DQ
	+Z/w8oSUHe4fss9zvn3da3nT3YOXyvn9N1jZ1tCwpmn2HUeZFa7vzyI4pswVytWW63FRj3F2Wiv
	m/xpJtWbOZWWxA=
X-Received: by 2002:a17:907:d07:b0:c19:5572:d234 with SMTP id a640c23a62f3a-c250bb3791amr1150758066b.1.1787769497364;
        Wed, 26 Aug 2026 11:38:17 -0700 (PDT)
Received: from [192.168.88.241] (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5de8ea655sm5491581a12.12.2026.08.26.11.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 11:38:16 -0700 (PDT)
Message-ID: <7b1f615f-d435-4b83-a180-67cf9a4223a0@ovn.org>
Date: Wed, 26 Aug 2026 20:38:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netlink: specs: fix the conntrack filter type
To: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>,
 Ilya Maximets <i.maximets@ovn.org>
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
 <94842eea-a296-4ab9-a026-2475757a82b8@fiberby.net>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <94842eea-a296-4ab9-a026-2475757a82b8@fiberby.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/26/26 7:20 PM, Asbjørn Sloth Tønnesen wrote:
> On 8/25/26 3:58 PM, Ilya Maximets wrote:
>> The CTA_FILTER doesn't contain nested tuple attributes, instead it
>> contains bit masks that specify which tuple attributes to filter on.
>> The values for filtering are taken from the top-level CTA_TUPLE_ORIG
>> and CTA_TUPLE_REPLY.
> 
> As identified by Sashiko-NIPA[1], then CTA_TUPLE_ORIG and CTA_TUPLE_REPLY
> are both absent from the GET DUMP request attribute list.
> 
> However this doesn't prevent ynl CLI from sending the attributes:
> 
> $ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
>    '{"nfgen-family": 2, "filter": {"orig-flags": 1}}'
> Netlink error: Invalid argument
> 
> $ sudo ./tools/net/ynl/pyynl/cli.py --family conntrack --dump get --json \
> '{"nfgen-family": 2, "filter": {"orig-flags": 1}, "tuple-orig": {"tuple-ip": {"ip-v4-src": "192.255.0.255", "ip-v4-dst": 
> "192.255.255.0"}}}'
> []
> 
> Otherwise, LGTM.
> 
> [1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260825155832.3685714-1-i.maximets%40ovn.org

The reported issue is preexisting and a little orthogonal to the goal of
this patch.  I.e. missing dump attributes vs wrong type of attributes that
are specified.

I can add all the missing attributes: tuple-orig, tuple-reply, mark-mask
and status-mask.  Either as a separate patch, or fold the change into this
one, but rename it into something like:
  "netlink: specs: fix conntrack filtering attributes and types"

WDYT?

Best regrads, Ilya Maximets.
