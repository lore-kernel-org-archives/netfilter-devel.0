Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D4C20B7FA;
	Fri, 10 Jan 2025 13:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736514174; cv=none; b=ZjRMxAnLhytYICV0UDoEWv/0Vyvgk0pz2RG8Q3U+tmZRRYo179EAq8kuuuNPH77zT+lTMtaaL6ZCypmwGjspHFEaZXK1r1kmGuL1k6VN25WNRbdJkb+FxdQosreG5+DOuTchd4OdBhX+NJ2XRRA+LIhh9kU+jqaAL813VINPCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736514174; c=relaxed/simple;
	bh=OAImGcKOliVNNhgW+BfQ1xldEUlrGQVka1gB2COieeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gK71du1DpzSnJWFrHh6MYuuDwT+1z1Os6Ot05gr7IewW1gJerMzmQvI901/voU0TfpMwnE0KiWMivl8Tvppszfl0xBRtL1PBPd8515jBorJgcrj9k/RkmvCe3Y25HYPsZusF8aTg68uGpfVMuJrTk5+6aEHS8hOhL8Xru6v9uMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YV1xm3hCBz6L54Z;
	Fri, 10 Jan 2025 21:01:32 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id CC56C14022E;
	Fri, 10 Jan 2025 21:02:46 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 10 Jan 2025 16:02:44 +0300
Message-ID: <3cdf6001-4ad4-6edc-e436-41a1eaf773f3@huawei-partners.com>
Date: Fri, 10 Jan 2025 16:02:42 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
 <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
 <Z0DDQKACIRRDRZRE@google.com>
 <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
 <20241127.oophah4Ueboo@digikod.net>
 <eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com>
 <20241128.um9voo5Woo3I@digikod.net>
 <af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com>
 <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>
 <20250110.2893966a7649@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20250110.2893966a7649@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 1/10/2025 2:12 PM, Günther Noack wrote:
> Happy New Year!

Happy New Year! Glad to see you :)

> 
> On Tue, Dec 24, 2024 at 07:55:01PM +0300, Mikhail Ivanov wrote:
>> The bitmask approach leads to a complete refactoring of socket rule
>> storage. This shouldn't be a big issue, since we're gonna need
>> multiplexer for insert_rule(), find_rule() with a port range feature
>> anyway [1]. But it seems that the best approach of storing rules
>> composed of bitmasks is to store them in linked list and perform
>> linear scan in landlock_find_rule(). Any other approach is likely to
>> be too heavy and complex.
>>
>> Do you think such refactoring is reasonable?
>>
>> [1] https://github.com/landlock-lsm/linux/issues/16
> 
> The way I understood it in your mail from Nov 28th [1], I thought that the
> bitmasks would only exist at the UAPI layer so that users could more
> conveniently specify multiple "types" at the same time.  In other
> words, a rule which is now expressed as
> 
>    {
>      .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>      .family = AF_INET,
>      .types = 1 << SOCK_STREAM | 1 << SOCK_DGRAM,
>      .protocol = 0,
>    },
> 
> used to be expressed like this (without bitmasks):
> 
>    {
>      .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>      .family = AF_INET,
>      .type = SOCK_STREAM,
>      .protocol = 0,
>    },
>    {
>      .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>      .family = AF_INET,
>      .type = SOCK_DGRAM,
>      .protocol = 0,
>    },

Correct, but we also agreed to use bitmasks for "family" field as well:

https://lore.kernel.org/all/af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com/

> 
> I do not understand why this convenience feature in the UAPI layer
> requires a change to the data structures that Landlock uses
> internally?  As far as I can tell, struct landlock_socket_attr is only
> used in syscalls.c and converted to other data structures already.  I
> would have imagined that we'd "unroll" the specified bitmasks into the
> possible combinations in the add_rule_socket() function and then call
> landlock_append_socket_rule() multiple times with each of these?

I thought about unrolling bitmask into multiple entries in rbtree, and
came up with following possible issue:

Imagine that a user creates a rule that allows to create sockets of all
possible families and types (with protocol=0 for example):
{
	.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
	.families = INT64_MAX, /* 64 set bits */
	.types = INT16_MAX, /* 16 set bits */
	.protocol = 0,
},

This will add 64 x 16 = 1024 entries to the rbtree. Currently, the
struct landlock_rule, which is used to store rules, weighs 40B. So, it
will be 40kB by a single rule. Even if we allow rules with only
"existing" families and types, it will be 46 x 7 = 322 entries and ~12kB
by a single rule.

I understand that this may be degenerate case and most common rule will
result in less then 8 (or 4) entries in rbtree, but I think API should
be as intuitive as possible. User can expect to see the same
memory usage regardless of the content of the rule.

I'm not really sure if this case is really an issue, so I'd be glad
to hear your opinion on it.

I also initially thought that it would be difficult to handle errors
when adding rule. But it seems that it's not gonna be an issue with
correctly implemented removal (this will result in additional method in
ruleset.c and small wrapper over rule structure that would not affect
ruleset domain implementation).

> 
> 
> That being said, I am not a big fan of red-black trees for such simple
> integer lookups either, and I also think there should be something
> better if we make more use of the properties of the input ranges. The
> question is though whether you want to couple that to this socket type
> patch set, or rather do it in a follow up?  (So far we have been doing
> fine with the red black trees, and we are already contemplating the
> possibility of changing these internal structures in [2].  We have
> also used RB trees for the "port" rules with a similar reasoning,
> IIRC.)

I think it'll be better to have a separate series for [2] if the socket
restriction can be implemented without rbtree refactoring.

> 
> Regarding the port range feature, I am also not sure whether the data
> structure for that would even be similar?  Looking for a containment
> in a set of integer ranges is a different task than looking for an
> exact match in a non-contiguous set of integers.
It seems like it would be better to have a different structure for
non-ranged lookups if it results in less memory and lookup duration.
First, we need to check possible candidates for both cases.

> 
> In any case, I feel that for now, an exact look up in the RB tree
> would work fine as a generic solution (especially considering that the
> set of added rules is probably usually small).  IMHO, finding a more
> appropriate data structure might be a can of worms that could further
> delay the patch set and which might better be discussed separately.
> 
> WDYT?

I agree if you think that worst case presented above is not a big issue.

> 
> –Günther
> 
> [1] https://lore.kernel.org/all/eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com/
> [2] https://github.com/landlock-lsm/linux/issues/1
