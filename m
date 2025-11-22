Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C55224B12;
	Sat, 22 Nov 2025 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763830289; cv=none; b=qyDGPCyMhRGvCrga40spkWcDzZSui+sNCN/I/aqIxBEj/t873sATXXG2PWjUvSzipndPtn879dwGJwIliFF6U+dzQr0MVGQnJX75l0glmJX49dZcAMCi42ng0GFiLtweKZNg70jtUS+XHr8YQBMRuuyHrFUoey3bKDx557FuVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763830289; c=relaxed/simple;
	bh=wyb8SqploHKIRrTaA0bboIpmJbOyPUUK49DFFJ4k/yA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VIButL/ZCYFF+LBRKKK7KBsqG1YjU7EcJbHBPWYJC/ZtFHV7VavC9FxCFEBgsSCCFO4ti1Ir/GvRqBPg3aN64U76vz+zQ8Itv74Xu9OhIH1yhqaNbfAxS4epxFoswibmrTuI/v6lua3JCVjEjGqL52ABBAZN2ysP1maTdBitOek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dDJ486hH5zJ4674;
	Sun, 23 Nov 2025 00:50:32 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id EDD68140276;
	Sun, 23 Nov 2025 00:51:21 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 19:51:19 +0300
Message-ID: <965372d6-85e7-06e2-624f-192b7a492d0e@huawei-partners.com>
Date: Sat, 22 Nov 2025 19:51:17 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 01/19] landlock: Support socket access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>, <mic@digikod.net>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
 <20251122.e645d2f1b8a1@gnoack.org>
 <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
 <20251122.d391a246d7dd@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20251122.d391a246d7dd@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 11/22/2025 3:18 PM, Günther Noack wrote:
> On Sat, Nov 22, 2025 at 02:13:08PM +0300, Mikhail Ivanov wrote:
>> On 11/22/2025 1:49 PM, Günther Noack wrote:
>>> (Remark, should those be exposed as constants?)
>>
>> I thought it could overcomplicate socket rules definition and Landlock
>> API. Do you think introducing such constants will be better decision?
> 
> No, I am not convinced either.  FWIW, there is a bit of prior art for
> "wildcard-like" -1 constants (grepping include/uapi for 'define.*-1'),
> but then again, the places where people did the opposite are hard to
> grep for.  I would also be OK if we documented "-1" in that place and
> left out the constant.
> 
> Mickaël, maybe you have a preference for the API style here?
> 
> 
>>>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>>>> index 33eafb71e4f3..e9f500f97c86 100644
>>>> --- a/security/landlock/syscalls.c
>>>> +++ b/security/landlock/syscalls.c
>>>> @@ -407,6 +458,8 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
>>>>     *   &landlock_net_port_attr.allowed_access is not a subset of the ruleset
>>>>     *   handled accesses)
>>>>     * - %EINVAL: &landlock_net_port_attr.port is greater than 65535;
>>>> + * - %EINVAL: &landlock_socket_attr.{family, type} are greater than 254 or
>>>> + *   &landlock_socket_attr.protocol is greater than 65534;
>>>
>>> Hmm, this is a bit annoying that these values have such unusual
>>> bounds, even though the input parameters are 32 bit.  We are exposing
>>> a little bit that we are internally storing this with only 8 and 16
>>> bits...  (I don't know a better solution immediately either, though. I
>>> think we discussed this on a previous version of the patch set as well
>>> and ended up with permitting larger values than the narrower SOCK_MAX
>>> etc bounds.)
>>
>> I agree, one of the possible solutions may be to store larger values in
>> socket keys (eg. s32), but this would require to make a separate
>> interface for storing socket rules (in order to not change key size for
>> other type of rules which is currently 32-64 bit depending on virtual
>> address size).
> 
> Yes, I'd be OK with it.
> 
> Do I remember this correctly that we settled on enforcing the looser
> UINT8_MAX and UINT16_MAX instead of SOCK_MAX, AF_MAX, which we used in
> v3 and before?  I tried to find the conversation but could not find it
> any more.  (Or did you have other reasons why you switched the
> implementation to use these larger bounds?)

Mickaël mentioned that Landlock should accept rules defined even for
unsupported protocol families:
https://lore.kernel.org/all/20241128.um9voo5Woo3I@digikod.net/

> 
> Thanks,
> –Günther
