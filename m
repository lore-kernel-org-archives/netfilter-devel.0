Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD12E4274;
	Sat, 18 Apr 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776511754; cv=none; b=iNyQ29/pgcxDI0SZ9hMpY5PC3T5dj/Sej4Brg9BiPH9S0Z61bJ5YV0nwihsIfX+i3Nb/KbHwJMag/jDovUq+QnTdgKIADk0l8wmbwfW1+xWwI4Wxj/ghWIcOYuMG5EcAWYpMTSv1TUQFQK62rFTvI1R9wTj+UXvZyt8DN/Oo9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776511754; c=relaxed/simple;
	bh=6O/pb8vvHaHRxbC+obPeX028Zh1XWHYTz00dyoHREA4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=b+MueW45HNmUaV0wxg0G7oSW09woKEgv7N/bKo1aEI2xHfHL9bDMVkbOeTjdZyrrzBmX9dZxl+e9QPwkqHtOaV9hxCYAFczlkMPSeBnaVT6oh3b8znsyyvn9SqVLqKyTDJuV3d/AHntyhOTjIK9bHXynEVWS2kyaAPwTV+hYxes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fyTyX5Xc9zJ467k;
	Sat, 18 Apr 2026 19:28:20 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id BAB6C4058B;
	Sat, 18 Apr 2026 19:29:08 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Apr 2026 14:29:06 +0300
Message-ID: <d7b3a4ed-034e-a0a3-4a68-9bc5fdc6e2ff@huawei-partners.com>
Date: Sat, 18 Apr 2026 14:29:04 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 01/19] landlock: Support socket access-control
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
 <20251122.e645d2f1b8a1@gnoack.org>
 <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
In-Reply-To: <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2025 2:13 PM, Mikhail Ivanov wrote:
> On 11/22/2025 1:49 PM, Günther Noack wrote:
>> On Tue, Nov 18, 2025 at 09:46:21PM +0800, Mikhail Ivanov wrote:
>>> +/**
>>> + * struct landlock_socket_attr - Socket protocol definition
>>> + *
>>> + * Argument of sys_landlock_add_rule().
>>> + */
>>> +struct landlock_socket_attr {
>>> +    /**
>>> +     * @allowed_access: Bitmask of allowed access for a socket protocol
>>> +     * (cf. `Socket flags`_).
>>> +     */
>>> +    __u64 allowed_access;
>>> +    /**
>>> +     * @family: Protocol family used for communication
>>> +     * (cf. include/linux/socket.h).
>>> +     */
>>> +    __s32 family;
>>> +    /**
>>> +     * @type: Socket type (cf. include/linux/net.h)
>>> +     */
>>> +    __s32 type;
>>> +    /**
>>> +     * @protocol: Communication protocol specific to protocol family 
>>> set in
>>> +     * @family field.
>>
>> This is specific to both the @family and the @type, not just the @family.
>>
>>> From socket(2):
>>
>>    Normally only a single protocol exists to support a particular
>>    socket type within a given protocol family.
>>
>> For instance, in your commit message above the protocol in the example
>> is IPPROTO_TCP, which would imply the type SOCK_STREAM, but not work
>> with SOCK_DGRAM.
> 
> You're right.
> 

I revised the socket(2) semantics and this part is about that kernel
maps (family, type, 0) to the default protocol of given family and type.
Eg. (AF_INET, SOCK_STREAM, 0) is mapped to (AF_INET, SOCK_STREAM,
IPPROTO_TCP). I would like to clarify that such mapping is taking place
in landlock_socket_attr.protocol field doc.

There should be list of protocols defined per protocol family. From
socket(2):
	The domain argument specifies a communication domain.
	...
	The protocol number to use is specific to the “communication
	domain” in which communication is to take place.

Such mapping allows to define strange socket rules if setting @type=-1.
For example:
	struct landlock_socket_attr attr = {
		.family = AF_INET,
		.type = -1,
		.protocol = 0,
	};

This definition corresponds to (AF_INET, SOCK_STREAM, 0->IPPROTO_TCP)
and to (AF_INET, SOCK_DGRAM, 0->IPPROTO_UDP).

I don't see this as a bad thing as far as there is proper documentation
for landlock_socket_attr.
