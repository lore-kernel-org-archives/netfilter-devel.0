Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBE218B47D;
	Wed, 18 Sep 2024 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668109; cv=none; b=BpAfwbPDHWuPHMGQFs6d1qwJJjWIB+SIDYJcU1xFqX6X3zzr+3f8b6TGJtrkns9FUxODrsdoK11Okn7vbhS5AZu4sB6ysNUYwvw2M+KgDAxpBA89s4pcKsGuzrGBbI58bze6k3a3cakryVnBO9jOrey46nlADm8FUqht9kwzxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668109; c=relaxed/simple;
	bh=0aqOgRl7qZHjrDJjX8+gvKikr2K+R8PiehTfS7v77qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UGAg88/WRptydAX9DVG1+kkzzN4APRl8g+FkHtzHZ3WWL5qh8AJUfXTms1JfU71q4Y65P7+nb01SPJZ3wAziG8XP8O7Q1s421ujHCt/3r0nwaizANygqgfBiZPAp6Gi7AUXE4H9qB5vBTOjdZU7BkI2PoJbakROZ0SUmljg5gR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4X80g42SMwz2QTxR;
	Wed, 18 Sep 2024 22:01:04 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id A5A7D140138;
	Wed, 18 Sep 2024 22:01:42 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Sep 2024 22:01:38 +0800
Message-ID: <f4d4db55-2bb3-3a53-8d64-dec0fe5ce6d3@huawei-partners.com>
Date: Wed, 18 Sep 2024 17:01:34 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 13/19] selftests/landlock: Test packet protocol
 alias
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-14-ivanov.mikhail1@huawei-partners.com>
 <ZurWqFq_dGWOsgUU@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZurWqFq_dGWOsgUU@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/18/2024 4:33 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:18PM +0800, Mikhail Ivanov wrote:
>> (AF_INET, SOCK_PACKET) is an alias for (AF_PACKET, SOCK_PACKET)
>> (Cf. __sock_create). Landlock shouldn't restrict one pair if the other
>> was allowed. Add `packet_protocol` fixture and test to
>> validate these scenarios.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 75 ++++++++++++++++++-
>>   1 file changed, 74 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 23698b8c2f4d..8fc507bf902a 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -7,7 +7,7 @@
>>   
>>   #define _GNU_SOURCE
>>   
>> -#include "landlock.h"
>> +#include <linux/landlock.h>
>>   #include <linux/pfkeyv2.h>
>>   #include <linux/kcm.h>
>>   #include <linux/can.h>
>> @@ -665,4 +665,77 @@ TEST(kernel_socket)
>>   	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
>>   }
>>   
>> +FIXTURE(packet_protocol)
>> +{
>> +	struct protocol_variant prot_allowed, prot_tested;
>> +};
>> +
>> +FIXTURE_VARIANT(packet_protocol)
>> +{
>> +	bool packet;
>> +};
>> +
>> +FIXTURE_SETUP(packet_protocol)
>> +{
>> +	self->prot_allowed.type = self->prot_tested.type = SOCK_PACKET;
>> +
>> +	self->prot_allowed.family = variant->packet ? AF_PACKET : AF_INET;
>> +	self->prot_tested.family = variant->packet ? AF_INET : AF_PACKET;
> 
> Nit: You might as well write these resulting prot_allowed and prot_tested struct
> values out in the two fixture variants.  It's one layer of indirection less and
> clarity trumps deduplication in tests, IMHO.  Fine either way though.

Agreed, thanks!

> 
> 
>> +
>> +	/* Packet protocol requires NET_RAW to be set (Cf. packet_create). */
>> +	set_cap(_metadata, CAP_NET_RAW);
>> +};
>> +
>> +FIXTURE_TEARDOWN(packet_protocol)
>> +{
>> +	clear_cap(_metadata, CAP_NET_RAW);
>> +}
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(packet_protocol, packet_allows_inet) {
>> +	/* clang-format on */
>> +	.packet = true,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(packet_protocol, inet_allows_packet) {
>> +	/* clang-format on */
>> +	.packet = false,
>> +};
>> +
>> +TEST_F(packet_protocol, alias_restriction)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr packet_socket_create = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = self->prot_allowed.family,
>> +		.type = self->prot_allowed.type,
>> +	};
>> +	int ruleset_fd;
>> +
>> +	/*
>> +	 * Checks that packet socket is created sucessfuly without
> 
> Typo nit: "successfully"
> 
> Please also check in other locations, I might well have missed some ;-)

Of course, sorry for that)

> 
>> +	 * landlock restrictions.
>> +	 */
>> +	ASSERT_EQ(0, test_socket_variant(&self->prot_tested));
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +				       &packet_socket_create, 0));
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +
>> +	/*
>> +	 * (AF_INET, SOCK_PACKET) is an alias for the (AF_PACKET, SOCK_PACKET)
>> +	 * (Cf. __sock_create). Checks that Landlock does not restrict one pair
>> +	 * if the other was allowed.
>> +	 */
>> +	EXPECT_EQ(0, test_socket_variant(&self->prot_tested));
> 
> Why not check both AF_INET and AF_PACKET in both fixtures?
> Since they are synonymous, they should both work, no matter which
> of the two variants was used in the rule.
> 
> It would be slightly more comprehensive and make the fixture smaller.
> WDYT?

Agreed, prot_tested should be removed.

> 
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.34.1
>>
> 
> —Günther
