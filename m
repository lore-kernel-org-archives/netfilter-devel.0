Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1537F13C3F6;
	Wed, 11 Sep 2024 08:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042803; cv=none; b=CPCxH6OG+j9aSSTEDUHbGY5QY9o8gBzw71vwQ3M0IMoSrxUA/7n7qIGDDa9WHyhJislmjRzW3jIETF8Yz3453qAO5X1n5sYPTNil9ujcOqpQ2XJJP+SBSRb3jXIEjeRVuvL3XF7JhHJw69ZAs7oF3B8y98JNnpY5vvo/Os6W/9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042803; c=relaxed/simple;
	bh=9VMUszZaeIWHmM4Y7Yv+ayb1ZPtSphTJzQLaaR82afY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AOXUkMbiQQUy8r8gf5nfRRkWOsLnTtOn6aJu8VANBcxDAhiSOe06Oz7YwCAvar541g4ofd3g3UaPAH4lhfhipoa2vJuSfhGK/lbANDv1l6rBLtY1mGr4f+tsJ2IZhm+0CWNnKmlUbdMbhLx1OItN2CbmZeWyGrVD4Np/n1wVYpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4X3YPP43VczyQrr;
	Wed, 11 Sep 2024 16:18:49 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C2EE18006C;
	Wed, 11 Sep 2024 16:19:56 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Sep 2024 16:19:52 +0800
Message-ID: <fd6ef478-4d0b-03f2-78f6-8bfd0fc3a846@huawei-partners.com>
Date: Wed, 11 Sep 2024 11:19:48 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 06/19] selftests/landlock: Test adding a rule for
 unhandled access
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-7-ivanov.mikhail1@huawei-partners.com>
 <ZuAP8iSv_sjmlYIp@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZuAP8iSv_sjmlYIp@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/10/2024 12:22 PM, Günther Noack wrote:
> Hi!
> 
> On Wed, Sep 04, 2024 at 06:48:11PM +0800, Mikhail Ivanov wrote:
>> Add test that validates behaviour of Landlock after rule with
>> unhandled access is added.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>> Changes since v2:
>> * Replaces EXPECT_EQ with ASSERT_EQ for close().
>> * Refactors commit title and message.
>>
>> Changes since v1:
>> * Refactors commit message.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 811bdaa95a7a..d2fedfca7193 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -351,4 +351,37 @@ TEST_F(protocol, rule_with_unknown_access)
>>   	ASSERT_EQ(0, close(ruleset_fd));
>>   }
>>   
>> +TEST_F(protocol, rule_with_unhandled_access)
>> +{
>> +	struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	struct landlock_socket_attr protocol = {
>> +		.family = self->prot.family,
>> +		.type = self->prot.type,
>> +	};
>> +	int ruleset_fd;
>> +	__u64 access;
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	for (access = 1; access > 0; access <<= 1) {
>> +		int err;
>> +
>> +		protocol.allowed_access = access;
>> +		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +					&protocol, 0);
>> +		if (access == ruleset_attr.handled_access_socket) {
>> +			EXPECT_EQ(0, err);
>> +		} else {
>> +			EXPECT_EQ(-1, err);
>> +			EXPECT_EQ(EINVAL, errno);
>> +		}
>> +	}
>> +
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +}
>> +
> 
> I should probably have noticed this on the first review round; you are not
> actually exercising any scenario here where a rule with unhandled access is
> added.
> 
> To clarify, the notion of an access right being "unhandled" means that the
> access right was not listed at ruleset creation time in the ruleset_attr's
> .handled_access_* field where it would have belonged.  If that is the case,
> adding a ruleset with that access right is going to be denied.
> 
> As an example:
> If the ruleset only handles LANDLOCK_ACCESS_FS_WRITE_FILE and nothing else,
> then, if the test tries to insert a rule for LANDLOCK_ACCESS_SOCKET_CREATE,
> that call is supposed to fail -- because the "socket creation" access right is
> not handled.

This test was added to exercise adding a rule with future possible
"unhandled" access rights of "socket" type, but since this patch
implements only one, this test is really meaningless. Thank you for
this note!

> 
> IMHO the test would become more reasonable if it was more clearly "handling"
> something entirely unrelated at ruleset creation time, e.g. one of the file
> system access rights.  (And we could do the same for the "net" and "fs" tests as
> well.)
> 
> Your test is a copy of the same test for the "net" rights, which in turn is a
> copy of teh same test for the "fs" rights.  When the "fs" test was written, the
> "fs" access rights were the only ones that could be used at all to create a
> ruleset, but this is not true any more.

Good idea! Can I implement such test in the current patchset?

> 
> —Günther
