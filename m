Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60753209;
	Fri, 11 Jul 2025 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752238525; cv=none; b=Ffcn6XZfGLvhmqG0DLskh2M45oFw2kP4+OgzL2bbVaJ62H28XyFsrK6NX5PSJ/dBCpl90u2ByV76sq4k6vkYxNdG4/OVa1EqTG9g906gcXcRBNc4OLA3xHypwWmVivpYCYyHQCCjEH6hdPk9A/lU6I3WeLWI8MB5EfUihVYUOiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752238525; c=relaxed/simple;
	bh=AWYHOjXUBWsoijdTe5XjvSVN3q2c0/IUFuIvj0336tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tz5pa1hTH9l1+NGJfPdBYRx64aKim0i0jz/vSzwNVZnO6stNdOVpwgsLwrbnhkt+ZC/4PZpuXX2NKcRrUdeFXcr89jCyekx/CYK2iD4qAoE9F/qr6sQTf74kCRAAw93Bwkcv9MkQEvIOrXJNb/8jeF30sQgLCY8EuX56ijxyv8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tl2GWJnr; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tl2GWJnr"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ae360b6249fso349455866b.1;
        Fri, 11 Jul 2025 05:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752238522; x=1752843322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s1kNo4Un3jL4ulQLE5GVMXMgYj71cxIyyrEQPeH9RHM=;
        b=Tl2GWJnrNv8xWtgf+hJ4hNFqW9Xl5cgDdvMyRZSy1aNeVAThi+Saw05EtV3jrHLbWR
         vOu2vlhA2ZFuq+qLvu2dVWXeOEdUhsJa+4sGvW/d3uUvua2UwNl5bCgyi8X5wBOrJd98
         n/KoYFZ1Trhmg+cMAaWjTfseV0ejphhF9Bk0LfLkfhLCRbhEjsDZy4LfFaOgQNJQVDQ6
         dS1FnO8h8H/52QyCW2/9JxNLWWgScueEg6CpMyHpfsftbf24/L1soucP32urZXv8WpBN
         5WNMuPmAJenm1gqVd/hvAIx8zKntLn08uNou7qjA+mV/faFGDkwSnx5I+Vboub9e0eA/
         iksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752238522; x=1752843322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s1kNo4Un3jL4ulQLE5GVMXMgYj71cxIyyrEQPeH9RHM=;
        b=eh2PUZrJKq2sqjXMsQtnJrcN8IXePKxdle5dyVQitgwjoaEH8Kp3GaMZeOR6LVre9t
         H7n2ueUyqqVN9B29Omzi3lwt33zbDly+ZGRFvYs+2ldnFUtEdmpHBFm2irOg+KA1ic9D
         +q79UNOV2nl3aQVlvy6OWnmJOTs+lALhD8keyLiGYK+Ma492Z3UvZ2fk7vvzLogxOKiv
         YeAi50SNKlc3SF18Dh9a3aFFgiwyXYRV0bXQ52yi4gPbrs0ob9VsPT95MzQJc+MqTj9t
         pdeVIij5XXg3NOUaxoPq2/Vji9KN/saJ0vESRY56eSZAQRinuZZaUXAaLps2dmhzHL2r
         D7Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXZCBKefiKuDiUyEKHBPMDGnzoq1487BECUoyAKUr2dnzCruHLZMIW0ZN0X47J8gK7ixI9a3jOao3TgeuNpl2UJ@vger.kernel.org, AJvYcCXzOgH9Mn7sXtsX5g0sFAc9g4xexkoX9I3po44b6CUvwUqdSX8Z8w99iVwQxYWx3oYGd0Gnnco=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH2O+HNOfNoLZkdswqmMESx+oe+harf71PCiFHfpTR+qE18Quw
	LaCKcy6/xfBgG0+qTit2KmM2pot4ki82fXNhQL5nwE/FNL0OUg893B+7
X-Gm-Gg: ASbGncuibkCbBBKrzUFldgaW2P7pKxJQwNGPsY9qdMrWj71GFuDlk+ZNrZbBrWXNIcl
	8C5lVSBuMjq8EkcqGN9Hp/MU8vw+q9s4s9IiLNygSZY3cv+qFR7j2MRM+gNolDUNIk2NbWJy7KK
	lSmLycbkpEgwvWOmFRHJMLATg9OyJXS8L71UqKb3k0LSeVU4pjp7n4ILNkJLjzXBsEuyX0GeDaQ
	z9UBSqzbPCCf5qoK04n/92O79aqyvShseiXpmBGf0L3M8LH7DdHUZ/boQnv3SK5ktmLS4G1oyi1
	o2eRTkdqY315OwDm1nvHhkNMHVoAczhDg4NeKCKFN+4X0rNly99O6rdTxRlZeDuK6bE3b4mJYo2
	DuLUd9W9S/QTJ6UcypVVUyDrYmwVw529Du47QWN6L/061IBB/vjV29PK+XkKZT//NIHWjs7tFYj
	SGqoBlndedzHr5dUoJ8ZpaeR/s1JEuQsFw1DheFW3FTOK/Ff2hyUBd5iiF72WUwgGavPc50+jdk
	RO7Mf+Va7w=
X-Google-Smtp-Source: AGHT+IGFQaxrT7dzjizCciqU78HSGz6eRug0Ek+s0ytFx7ZsmssnCbtFFJ5dIA8PAbzHsdYn9MXgMw==
X-Received: by 2002:a17:907:3cc6:b0:ae3:a812:a780 with SMTP id a640c23a62f3a-ae6fc1c07a3mr310674266b.61.1752238521536;
        Fri, 11 Jul 2025 05:55:21 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e82962acsm292076666b.139.2025.07.11.05.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 05:55:20 -0700 (PDT)
Message-ID: <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com>
Date: Fri, 11 Jul 2025 14:55:19 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com> <aG2Vfqd779sIK1eL@strlen.de>
Content-Language: en-US
From: Eric Woudstra <ericwouds@gmail.com>
In-Reply-To: <aG2Vfqd779sIK1eL@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/9/25 12:02 AM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> +		if (!pskb_may_pull(skb, VLAN_HLEN))
>> +			break;
>> +		vhdr = (struct vlan_hdr *)(skb->data);
>> +		offset = VLAN_HLEN;
>> +		outer_proto = skb->protocol;
>> +		proto = vhdr->h_vlan_encapsulated_proto;
>> +		skb_set_network_header(skb, offset);
>> +		skb->protocol = proto;
> 
> Why is skb->protocol munged?  Also applies to the previous patch,
> I forgot to ask.

In the previous patch in nf_ct_bridge_pre(), indeed, no need to munge
skb->protocol. So I'll change that.

But in nft_do_chain_bridge() it is needed in the case of matching 'ip
saddr', 'ip daddr', 'ip6 saddr' or 'ip6 daddr'. I suspect all ip/ip6
matches are suffering.

So still matching is something like:

tcp dport 8080 counter name "check"

But no match when:

ip saddr 192.168.1.1 tcp dport 8080 counter name "check"

After munging skb->protocol, I do get the match.

I haven't found where yet, but It seems nft is checking skb->protocol,
before it tries to match the ip(6) saddr/daddr.


And to answer a question in the other patch: this issue is found by
using my script bridge_fastpath.sh. It first checks the connection,
conntrack and nft-chain are functional in all testcases. So, it tests
the functionality of the patches in this patch-set. I want to improve
the script on a few more issues and then send a non-rfc.

