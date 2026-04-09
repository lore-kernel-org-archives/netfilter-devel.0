Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB9238F92E
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775773522; cv=none; b=arXOjROI2/DoRKS7L2WZY/PWMyzkefdX7EZJAyLB9a91g2481xRScYja2uvuZqXLjNYboG6OL+LBL0M7Ci1lp++VEnbvMyree10XK6+5vTvOgEyqEyyOhQy0oFMlG1f7dp1GsyBLGoPI1fG/GjrmNL4YLYjd/p/tt1RzJAoTFf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775773522; c=relaxed/simple;
	bh=AbJbBW6X9LmrirWXz3KRksKCyyWsSci1hJLqJfBEgC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhrYOiFZ78VHpNuC6w7UHFQL2ev+nPt0xAt9HeCW8J7ZYpVX/4xY02co+Q2l8yZVtjHF+AtJJy0z7VTNwR6sLOcOLf70/NxpUISfFmNBtgoxya7SJfGKorYqPihf2D1Or354AV4tbrqpzG/LBRRrdSUi5KccPqrPU0ZCB3xp+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=w6MEW9XH; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="w6MEW9XH"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id AoF4wCYtzc9KCAxoNwFBlw; Thu, 09 Apr 2026 22:25:20 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id AxoIwzlzwFeDMAxoIw78gD; Thu, 09 Apr 2026 22:25:14 +0000
X-Authority-Analysis: v=2.4 cv=aq2yCTZV c=1 sm=1 tr=0 ts=69d8274f
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=chC0KcwHAXg1M6QkddG+Hg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7T7KSl7uo7wA:10 a=_Wotqz80AAAA:8
 a=q7JyIVeMSE5i464zDnEA:9 a=QEXdDO2ut3YA:10 a=buJP51TR1BpY-zbLSsyS:22
 a=2aFnImwKRvkU0tJ3nQRT:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4BBlkBrjrnSTWHBfnhpyKI7M2eVDU51iIMYacZS4Q/0=; b=w6MEW9XHtJeoU3e8FoHDHf8K3/
	ivR3cFvN7s2LInyuaPqW9dcyLaYXkkDM5MpKvf3aEFCuMK2vFJf/2muGzJPrwuYm9GY7bfO/49a3z
	cnBSWDCM47on+tX1INjqvFb14khL7P8XSgxUORsdk5RxpjYtWBd4RPWTOtCfKrq5n3T5uabX/pzIe
	TrJDVueDCobFbUKfLcxProglFvYrYmSJNiwFtYDBklxwAPyJUsw8i8FfIUN4NIlXBv3/aZgF2w7ew
	AqoX0SjMheEX1J+m1ZSmmm1WqPtmHIMaCMekzg1lNQAlZM5L+KnoWStWJcrAQQbfGG0Ucof8CutUS
	JSdjFgKw==;
Received: from [177.238.18.219] (port=45456 helo=[192.168.0.104])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.99.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1wAxoG-00000003aQj-0zkt;
	Thu, 09 Apr 2026 17:25:12 -0500
Message-ID: <3d07eb02-1a18-4de1-9683-5c05b80600e2@embeddedor.com>
Date: Thu, 9 Apr 2026 16:23:59 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
To: Florian Westphal <fw@strlen.de>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Kees Cook <kees@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <adgL5wPm9VpaV3MO@kspp>
 <96b116e4-d91d-456a-9a08-fb3de4822a62@embeddedor.com>
 <adglrthId0L5__9w@strlen.de>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <adglrthId0L5__9w@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.18.219
X-Source-L: No
X-Exim-ID: 1wAxoG-00000003aQj-0zkt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.104]) [177.238.18.219]:45456
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOsvKXZemnFW/V0068K1GQGWYkvZE+MNWlGEMfiaF9BsWOmmQqh0Yx8oGzZ3v9/z42kVYSe87J4jDiUpSz9iLxXzyzJzWN25OrUPw4eO+85bMNgNCC9M
 pkSHD5y9opJpxRRHrrfHFuQcuYcrYxkCVTPsXyKjx5ama0hKSgBwV66tKACcWplErr2esNRP78eCfzXazkkJRLCReihPCqtOLxdPJ4xg1gZ7GnaI+4Y/F8Rp



On 4/9/26 16:18, Florian Westphal wrote:
> Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index b39017c80548..9dd5957d9ed4 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -819,13 +819,15 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
>>
>>    /* non-compat version may have padding after verdict */
>>    struct compat_xt_standard_target {
>> -       struct compat_xt_entry_target t;
>> -       compat_uint_t verdict;
>> +       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
>> +               compat_uint_t verdict;
>> +       );
>>    };
>>
>>    struct compat_xt_error_target {
>> -       struct compat_xt_entry_target t;
>> -       char errorname[XT_FUNCTION_MAXNAMELEN];
>> +       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
>> +               char errorname[XT_FUNCTION_MAXNAMELEN];
>> +       );
>>    };
>>
>> You tell me what you prefer.
> 
> I have no strong opinion. This compat code is needed to run 32bit
> iptables binaries on a 64 bit host, not many users these days I think.
> I still hope we can remove this eventually.
> 
> But as the above diff is smaller I would prefer it.

Okay; I'll submit this as v3 then.

Thanks for the feedback,
-Gustavo

