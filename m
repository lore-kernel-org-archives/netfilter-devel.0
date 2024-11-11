Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B4C1A2C04;
	Mon, 11 Nov 2024 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731342605; cv=none; b=sycg75o6XNJWrXogJoIeZxslxrah6BsEDGcAz7L0uwOyFO7vlPRZf4NrSjcjitawBdDikyYkoU+2nEL0h9A8rmw5LRn1EyFwosE2F6vE+tUxekRQQiza13+I+cWMosMTZJGLCjK04TUmVZ001iAr+hdi3Gj/HGucaKdaO6U1NsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731342605; c=relaxed/simple;
	bh=9fDruoMlfXUHmwmsvf9FAXDWc9/JlJxAuM/fbaROEu4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=JQZp5G9Y8VKUjoESepONxAc3l/wNMkSMaAvAWKYHZvQ1NRZ5gANKCLBh91FNNFZlS+6BQl4YFlK7a3115U5+0tShEOgx08p/33YCCF2kOlTen5JFy4GLD1JwJWJjyVz37yilLbGi7xHbVW7E6vBLn5wcMPnfd8xgtf7Y5K6aSCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XnFPg3pY4z6L6yR;
	Tue, 12 Nov 2024 00:29:43 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id A2A3114022E;
	Tue, 12 Nov 2024 00:29:53 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 11 Nov 2024 19:29:51 +0300
Message-ID: <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
Date: Mon, 11 Nov 2024 19:29:49 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 9/4/2024 1:48 PM, Mikhail Ivanov wrote:
> Landlock implements the `LANDLOCK_RULE_NET_PORT` rule type, which provides
> fine-grained control of actions for a specific protocol. Any action or
> protocol that is not supported by this rule can not be controlled. As a
> result, protocols for which fine-grained control is not supported can be
> used in a sandboxed system and lead to vulnerabilities or unexpected
> behavior.
> 
> Controlling the protocols used will allow to use only those that are
> necessary for the system and/or which have fine-grained Landlock control
> through others types of rules (e.g. TCP bind/connect control with
> `LANDLOCK_RULE_NET_PORT`, UNIX bind control with
> `LANDLOCK_RULE_PATH_BENEATH`). Consider following examples:
> 
> * Server may want to use only TCP sockets for which there is fine-grained
>    control of bind(2) and connect(2) actions [1].
> * System that does not need a network or that may want to disable network
>    for security reasons (e.g. [2]) can achieve this by restricting the use
>    of all possible protocols.
> 
> This patch implements such control by restricting socket creation in a
> sandboxed process.
> 
> Add `LANDLOCK_RULE_SOCKET` rule type that restricts actions on sockets.
> This rule uses values of address family and socket type (Cf. socket(2))
> to determine sockets that should be restricted. This is represented in a
> landlock_socket_attr struct:
> 
>    struct landlock_socket_attr {
>      __u64 allowed_access;
>      int family; /* same as domain in socket(2) */
>      int type; /* see socket(2) */
>    };

Hello! I'd like to consider another approach to define this structure
before sending the next version of this patchset.

Currently, it has following possible issues:

First of all, there is a lack of protocol granularity. It's impossible
to (for example) deny creation of ICMP and SCTP sockets and allow TCP
and UDP. Since the values of address family and socket type do not
completely define the protocol for the restriction, we may gain
incomplete control of the network actions. AFAICS, this is limited to
only a couple of IP protocol cases (e.g. it's impossible to deny SCTP
and SMC sockets to only allow TCP, deny ICMP and allow UDP).

But one of the main advantages of socket access rights is the ability to
allow only those protocols for which there is a fine-grained control
over their actions (TCP bind/connect). It can be inconvenient
(and unsafe) for SCTP to be unrestricted, while sandboxed process only
needs TCP sockets.

Adding protocol (Cf. socket(2)) field was considered a bit during the
initial discussion:
https://lore.kernel.org/all/CABi2SkVWU=Wxb2y3fP702twyHBD3kVoySPGSz2X22VckvcHeXw@mail.gmail.com/

Secondly, I'm not really sure if socket type granularity is required
for most of the protocols. It may be more convenient for the end user
to be able to completely restrict the address family without specifying
whether restriction is dedicated to stream or dgram sockets (e.g. for
BLUETOOTH, VSOCK sockets). However, this is not a big issue for the
current design, since address family can be restricted by specifying
type = SOCK_TYPE_MASK.

I suggest implementing something close to selinux socket classes for the
struct landlock_socket_attr (Cf. socket_type_to_security_class()). This
will provide protocol granularity and may be simpler and more convenient
in the terms of determining access rights. WDYT?
