Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FA01922D3;
	Mon, 25 Nov 2024 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732532667; cv=none; b=HrGfbt1WQPExDZ1qZCzGutWOQv+M4T7HaibdB20126RsEM3oCWWseakAxmoQ0Ze8NDV28nZaVI8//9vc3MaKnNXmpozarHUeEwvaQCLbVED7cZfXYpvKWkxvVz3qO48CrUGBVYZ7AZYZtHHoKxjZt2jvCN8QJCZgsWu+qH60WT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732532667; c=relaxed/simple;
	bh=NFhBhP3/TVWro0ElJi6vj5V8/PmXfpxK+X0fLDMV7GA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=I0nDCM8PeOVurUpvxOh6g8jQH8aX2R9PeDc0kDdBW8C2cIdvUUg5/907DJz85DF4vuDcFv04/aUejcbqyciJb4fHudhUD+MH+wRFPgXjIFGRVycyFhWpFseLrk3wv8Hi1HaN/dABS77H1qra1F1zQn8WqachtAstph8r+2frNrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XxjW32Jvwz6L76x;
	Mon, 25 Nov 2024 19:03:43 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 5BF34140367;
	Mon, 25 Nov 2024 19:04:13 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 25 Nov 2024 14:04:11 +0300
Message-ID: <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
Date: Mon, 25 Nov 2024 14:04:09 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
 <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
 <Z0DDQKACIRRDRZRE@google.com>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <Z0DDQKACIRRDRZRE@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2024 8:45 PM, Günther Noack wrote:
> Hello Mikhail,
> 
> sorry for the delayed response;
> I am very happy to see activity on this patch set! :)

Hello Günther,
No problem, thanks a lot for your feedback!

> 
> On Mon, Nov 11, 2024 at 07:29:49PM +0300, Mikhail Ivanov wrote:
>> On 9/4/2024 1:48 PM, Mikhail Ivanov wrote:
>>> Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
>>> fine-grained control of actions for a specific protocol. Any action or
>>> protocol that is not supported by this rule can not be controlled. As a
>>> result, protocols for which fine-grained control is not supported can be
>>> used in a sandboxed system and lead to vulnerabilities or unexpected
>>> behavior.
>>>
>>> Controlling the protocols used will allow to use only those that are
>>> necessary for the system and/or which have fine-grained Landlock control
>>> through others types of rules (e.g. TCP bind/connect control with
>>> `LANDLOCK_RULE_NET_PORT`, UNIX bind control with
>>> `LANDLOCK_RULE_PATH_BENEATH`). Consider following examples:
>>>
>>> * Server may want to use only TCP sockets for which there is fine-grained
>>>     control of bind(2) and connect(2) actions [1].
>>> * System that does not need a network or that may want to disable network
>>>     for security reasons (e.g. [2]) can achieve this by restricting the use
>>>     of all possible protocols.
>>>
>>> This patch implements such control by restricting socket creation in a
>>> sandboxed process.
>>>
>>> Add `LANDLOCK_RULE_SOCKET` rule type that restricts actions on sockets.
>>> This rule uses values of address family and socket type (Cf. socket(2))
>>> to determine sockets that should be restricted. This is represented in a
>>> landlock_socket_attr struct:
>>>
>>>     struct landlock_socket_attr {
>>>       __u64 allowed_access;
>>>       int family; /* same as domain in socket(2) */
>>>       int type; /* see socket(2) */
>>>     };
>>
>> Hello! I'd like to consider another approach to define this structure
>> before sending the next version of this patchset.
>>
>> Currently, it has following possible issues:
>>
>> First of all, there is a lack of protocol granularity. It's impossible
>> to (for example) deny creation of ICMP and SCTP sockets and allow TCP
>> and UDP. Since the values of address family and socket type do not
>> completely define the protocol for the restriction, we may gain
>> incomplete control of the network actions. AFAICS, this is limited to
>> only a couple of IP protocol cases (e.g. it's impossible to deny SCTP
>> and SMC sockets to only allow TCP, deny ICMP and allow UDP).
>>
>> But one of the main advantages of socket access rights is the ability to
>> allow only those protocols for which there is a fine-grained control
>> over their actions (TCP bind/connect). It can be inconvenient
>> (and unsafe) for SCTP to be unrestricted, while sandboxed process only
>> needs TCP sockets.
> 
> That is a good observation which I had missed.
> 
> I agree with your analysis, I also see the main use case of socket()
> restrictions in:
> 
>   (a) restricting socket creating altogether
>   (b) only permitting socket types for which there is fine grained control
> 
> and I also agree that it would be very surprising when the same socket types
> that provide fine grained control would also open the door for unrestricted
> access to SMC, SCTP or other protocols.  We should instead strive for a
> socket() access control with which these additional protocols weren't
> accessible.
> 
> 
>> Adding protocol (Cf. socket(2)) field was considered a bit during the
>> initial discussion:
>> https://lore.kernel.org/all/CABi2SkVWU=Wxb2y3fP702twyHBD3kVoySPGSz2X22VckvcHeXw@mail.gmail.com/
> 
> So adding "protocol" to the rule attributes would suffice to restrict the use of
> SMC and SCTP then?  (Sorry, I lost context on these protocols a bit in the
> meantime, I was so far under the impression that these were using different
> values for family and type than TCP and UDP do.)

Yeap. Following rule will be enough to allow TCP sockets only:

const struct landlock_socket_attr create_socket_attr = {
	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
	.family = AF_INET{,6},
	.type = SOCK_STREAM,
	.protocol = 0
};

Btw, creation of SMC sockets via IP stack was added quite recently.
So far, creation has been possible only with AF_SMC family.

https://lore.kernel.org/all/1718301630-63692-1-git-send-email-alibuda@linux.alibaba.com/

> 
> 
>> Secondly, I'm not really sure if socket type granularity is required
>> for most of the protocols. It may be more convenient for the end user
>> to be able to completely restrict the address family without specifying
>> whether restriction is dedicated to stream or dgram sockets (e.g. for
>> BLUETOOTH, VSOCK sockets). However, this is not a big issue for the
>> current design, since address family can be restricted by specifying
>> type = SOCK_TYPE_MASK.
> 
> Whether the user is adding one rule to permit AF_INET+*, or whether the user is
> adding two rules to permit (1) AF_INET+SOCK_STREAM and (2) AF_INET+SOCK_DGRAM,
> that does not seem like a big deal to me as long as the list of such
> combinations is so low?

Agreed

> 
> 
>> I suggest implementing something close to selinux socket classes for the
>> struct landlock_socket_attr (Cf. socket_type_to_security_class()). This
>> will provide protocol granularity and may be simpler and more convenient
>> in the terms of determining access rights. WDYT?
> 
> I see that this is a longer switch statement that maps to this enum, it would be
> an additional data table that would have to be documented separately for users.

This table is the general drawback, since it makes API a bit more
complex.

> 
> Do you have an example for how such a "security class enum" would map to the
> combinations of family, type and socket for the protocols discussed above?

I think the socket_type_to_security_class() has a pretty good mapping
for UNIX and IP families.

> 
> If this is just a matter of actually mapping (family, type, protocol)
> combinations in a more flexible way, could we get away by allowing a special
> "wildcard" value for the "protocol" field, when it is used within a ruleset?
> Then the LSM would have to look up whether there is a rule for (family, type,
> protocol) and the only change would be that it now needs to also check whether
> there is a rule for (family, type, *)?

Something like this?

const struct landlock_socket_attr create_socket_attr = {
	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
	.family = AF_INET6,
	.type = SOCK_DGRAM,
	.protocol = LANDLOCK_SOCKET_PROTO_ALL
};

> 
> —Günther
