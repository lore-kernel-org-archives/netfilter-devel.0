Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DD155314;
	Thu,  3 Oct 2024 12:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727960396; cv=none; b=cIoyj/T//xBrrMJ1+Al+iRdSUQQJs+/Lr4SHeCkLfWFlQ7zfrOPZdx0z7KB77FSOYj8AAQRWG4nGeZdVuh+MnTVDbqDJRb/8mCiqEkl/Zmrec52sVmAJ0DCfTqpOB9cJbTfPfd6YVwhl0L60SU51ekWgiA9jjezW2XLG518o8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727960396; c=relaxed/simple;
	bh=PTNIJBDutOvlmo3BkQFp9X55W62sCcVJ1Q6khxnJeRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JUJUY0CuZGA8pFcOL8YfbCRcUAqs169Pq6UCpwLJqqNCj6ziEI+xN64HWC2WxhaXeybqYIJAFZV5HyQTbRDSRZIH75e1uzitYbj4PkG+atXB8MYJeVbNpJnnulWKLpA7RMY/0es/75MTo3xLPPmrAGV1ZCbDhK+I73U1SCqhrCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XKBVv2rFfz1HKSN;
	Thu,  3 Oct 2024 20:55:51 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id AE6BD140118;
	Thu,  3 Oct 2024 20:59:50 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 20:59:46 +0800
Message-ID: <bc7afd55-f560-7439-2806-a1f9e73307a0@huawei-partners.com>
Date: Thu, 3 Oct 2024 15:59:42 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 17/19] samples/landlock: Replace atoi() with
 strtoull() in populate_ruleset_net()
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-18-ivanov.mikhail1@huawei-partners.com>
 <ZvbLcsQVTs_RESx0@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZvbLcsQVTs_RESx0@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/27/2024 6:12 PM, Günther Noack wrote:
> On Wed, Sep 04, 2024 at 06:48:22PM +0800, Mikhail Ivanov wrote:
>> Add str2num() helper and replace atoi() with it. atoi() does not provide
>> overflow checks, checks of invalid characters in a string and it is
>> recommended to use strtol-like functions (Cf. atoi() manpage).
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   samples/landlock/sandboxer.c | 27 ++++++++++++++++++++++++++-
>>   1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index e8223c3e781a..d4dba9e4ce89 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
>> @@ -150,6 +150,26 @@ static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
>>   	return ret;
>>   }
>>   
>> +static int str2num(const char *numstr, unsigned long long *num_dst)
>> +{
>> +	char *endptr = NULL;
>> +	int err = 1;
>> +	unsigned long long num;
>> +
>> +	errno = 0;
>> +	num = strtoull(numstr, &endptr, 0);
>> +	if (errno != 0)
>> +		goto out;
>> +
>> +	if (*endptr != '\0')
>> +		goto out;
>> +
>> +	*num_dst = num;
>> +	err = 0;
>> +out:
>> +	return err;
>> +}
> 
> I believe if numstr is the empty string, str2num would return success and set
> num_dst to 0, which looks unintentional to me.

Yeap.. I'll fix this

> 
> Do we not have a better helper for this that we can link from here?

I've checked how such convertion is performed in selftests by another
subsystems and it seems that most common practise is to implement static
helper or inline convertion in the needed place (e.g. safe_int() in
selftests/net/af_unix/scm_pidfd.c).

> 
>> +
>>   static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>>   				const __u64 allowed_access)
>>   {
>> @@ -168,7 +188,12 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>>   
>>   	env_port_name_next = env_port_name;
>>   	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
>> -		net_port.port = atoi(strport);
>> +		if (str2num(strport, &net_port.port)) {
>> +			fprintf(stderr,
>> +				"Failed to convert \"%s\" into a number\n",
>> +				strport);
>> +			goto out_free_name;
>> +		}
>>   		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>   				      &net_port, 0)) {
>>   			fprintf(stderr,
>> -- 
>> 2.34.1
>>
