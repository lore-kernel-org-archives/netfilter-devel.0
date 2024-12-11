Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949013B5AE;
	Wed, 11 Dec 2024 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733931065; cv=none; b=MtmCecBGLb2Kzk3jpLxQ6uoxReepFxY1hJO/UebtBs40qOvf0IBHSNW/p3KNB0kUchCNM7LZYcRvJgCoxQhYQ8YR9QYSS0hoQLU4BkmUDS0mP0UbncqlSguedzoYpR2b5Q/ff8vLPPsl2FYjT+7gyISSUox6C84s5CEgF7xubv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733931065; c=relaxed/simple;
	bh=AsVg+gx9nWV4PRZYQ0dbhVzBEv13OVRQm9qm5jKbOuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dGBpH1CgzQOOdpzlDwMxkYKDK9OO2tkNTgAZ7KIVP1BDioZ/MsTLbLX9kAyMUQzMK4LRzblreFyi8sSTrFB9Q4o9fg+bDnHD6QdSSwTI3IBOSumMRITglKwEpXCbT0bnyoEGtu+OjIwglQROMDzVeH4jbZWs+msfu+tDjs4bubg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y7fcK0WDNz6D8Xm;
	Wed, 11 Dec 2024 23:27:45 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id A59331400DB;
	Wed, 11 Dec 2024 23:31:01 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 11 Dec 2024 18:30:59 +0300
Message-ID: <c508ead6-67c3-6e84-367b-e266d49306f7@huawei-partners.com>
Date: Wed, 11 Dec 2024 18:30:59 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 7/8] landlock: Add note about errors consistency in
 documentation
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Paul Moore
	<paul@paul-moore.com>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-8-ivanov.mikhail1@huawei-partners.com>
 <20241210.kohGhez4osha@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241210.kohGhez4osha@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 12/10/2024 9:08 PM, Mickaël Salaün wrote:
> On Thu, Oct 17, 2024 at 07:04:53PM +0800, Mikhail Ivanov wrote:
>> Add recommendation to specify Landlock first in CONFIG_LSM list, so user
>> can have better LSM errors consistency provided by Landlock.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   Documentation/userspace-api/landlock.rst | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>> index bb7480a05e2c..0db5eee9bffa 100644
>> --- a/Documentation/userspace-api/landlock.rst
>> +++ b/Documentation/userspace-api/landlock.rst
>> @@ -610,7 +610,8 @@ time as the other security modules.  The list of security modules enabled by
>>   default is set with ``CONFIG_LSM``.  The kernel configuration should then
>>   contains ``CONFIG_LSM=landlock,[...]`` with ``[...]``  as the list of other
>>   potentially useful security modules for the running system (see the
>> -``CONFIG_LSM`` help).
>> +``CONFIG_LSM`` help). It is recommended to specify Landlock first of all other
>> +modules in CONFIG_LSM list since it provides better errors consistency.
> 
> This is partially correct because Landlock may not block anything
> whereas another LSM could deny a network action, with potentially a
> wrong error code.  I don't think this patch is worth it, especially
> because other LSMs have bugs that should be fixed.

Ok, agreed

> 
>>   
>>   Boot time configuration
>>   -----------------------
>> -- 
>> 2.34.1
>>
>>
