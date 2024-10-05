Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F241262A8;
	Sat,  5 Oct 2024 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728149465; cv=none; b=i+g9HpNjqj9exLYXoUtDj5gFfH5mVsBe6NmovZEtOHKtsv05YUjMGSbDQz+pprg6SM+CKA2Ei2AtKyxCp2lpWC36Z7dz7jdg9beVVkiZLuTmpq+VhEb8b3Vuv/gyJ/X6amsLuWuK/pM2DK4t5D5URq2o8dJN+Wx3zHMklDrIyno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728149465; c=relaxed/simple;
	bh=6YYMhnVCMMJkPNBpD3IKwss3tmQ+77STIzbsK4klpzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VbCJPyl4n4+4w5VgnDxl+XXdmKNDmcuf7QkkU+RQZ7WdzDJQTQsPYWK8bxii99WvL/p6DDG4No/vOYnqF9bNCpsOn2eHf2P5TzClw40PdILhsblcvBbyqtQadfOFyrAeix3WjSbfr+0zpNrCssNVpyeXH23E6+hiC+svflwxVwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XLXTY55qxz10Myp;
	Sun,  6 Oct 2024 01:29:21 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 70CA5140393;
	Sun,  6 Oct 2024 01:31:00 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 6 Oct 2024 01:30:56 +0800
Message-ID: <e29d8958-f272-420c-d3db-16c7a4109db2@huawei-partners.com>
Date: Sat, 5 Oct 2024 20:30:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 9/9] samples/landlock: Support
 LANDLOCK_ACCESS_NET_LISTEN
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-10-ivanov.mikhail1@huawei-partners.com>
 <20241005.92cff495291f@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241005.92cff495291f@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/5/2024 7:57 PM, Günther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:51AM +0800, Mikhail Ivanov wrote:
>> Extend sample with TCP listen control logic.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   samples/landlock/sandboxer.c | 31 ++++++++++++++++++++++++++-----
>>   1 file changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index e8223c3e781a..3f50cb3f8039 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
>> @@ -55,6 +55,7 @@ static inline int landlock_restrict_self(const int ruleset_fd,
>>   #define ENV_FS_RW_NAME "LL_FS_RW"
>>   #define ENV_TCP_BIND_NAME "LL_TCP_BIND"
>>   #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
>> +#define ENV_TCP_LISTEN_NAME "LL_TCP_LISTEN"
>>   #define ENV_DELIMITER ":"
>>   
>>   static int parse_path(char *env_path, const char ***const path_list)
>> @@ -208,7 +209,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>>   
>>   /* clang-format on */
>>   
>> -#define LANDLOCK_ABI_LAST 5
>> +#define LANDLOCK_ABI_LAST 6
>>   
>>   int main(const int argc, char *const argv[], char *const *const envp)
>>   {
>> @@ -222,15 +223,16 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   	struct landlock_ruleset_attr ruleset_attr = {
>>   		.handled_access_fs = access_fs_rw,
>>   		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP |
>> +				      LANDLOCK_ACCESS_NET_LISTEN_TCP,
>>   	};
>>   
>>   	if (argc < 2) {
>>   		fprintf(stderr,
>> -			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
>> +			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
>>   			"<cmd> [args]...\n\n",
>>   			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> -			ENV_TCP_CONNECT_NAME, argv[0]);
>> +			ENV_TCP_CONNECT_NAME, ENV_TCP_LISTEN_NAME, argv[0]);
>>   		fprintf(stderr,
>>   			"Execute a command in a restricted environment.\n\n");
>>   		fprintf(stderr,
>> @@ -251,15 +253,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   		fprintf(stderr,
>>   			"* %s: list of ports allowed to connect (client).\n",
>>   			ENV_TCP_CONNECT_NAME);
>> +		fprintf(stderr,
>> +			"* %s: list of ports allowed to listen (server).\n",
>> +			ENV_TCP_LISTEN_NAME);
>>   		fprintf(stderr,
>>   			"\nexample:\n"
>>   			"%s=\"${PATH}:/lib:/usr:/proc:/etc:/dev/urandom\" "
>>   			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>>   			"%s=\"9418\" "
>>   			"%s=\"80:443\" "
>> +			"%s=\"9418\" "
>>   			"%s bash -i\n\n",
>>   			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> -			ENV_TCP_CONNECT_NAME, argv[0]);
>> +			ENV_TCP_CONNECT_NAME, ENV_TCP_LISTEN_NAME, argv[0]);
>>   		fprintf(stderr,
>>   			"This sandboxer can use Landlock features "
>>   			"up to ABI version %d.\n",
>> @@ -326,6 +332,11 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   	case 4:
>>   		/* Removes LANDLOCK_ACCESS_FS_IOCTL_DEV for ABI < 5 */
>>   		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_IOCTL_DEV;
>> +		__attribute__((fallthrough));
>> +	case 5:
>> +		/* Removes LANDLOCK_ACCESS_NET_LISTEN support for ABI < 6 */
>> +		ruleset_attr.handled_access_net &=
>> +			~(LANDLOCK_ACCESS_NET_LISTEN_TCP);
> 
> (same remark as on other patch set)
> 
> ABI version has shifted by one in the meantime.

Thanks, I'll update it for the next version.

> 
>>   
>>   		fprintf(stderr,
>>   			"Hint: You should update the running kernel "
>> @@ -357,6 +368,12 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   		ruleset_attr.handled_access_net &=
>>   			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>   	}
>> +	/* Removes listen access attribute if not supported by a user. */
> 
> (also same remark as on other patch set)
> 
> Please s/supported/requested/, for consistency.

Ok, thanks!

> 
>> +	env_port_name = getenv(ENV_TCP_LISTEN_NAME);
>> +	if (!env_port_name) {
>> +		ruleset_attr.handled_access_net &=
>> +			~LANDLOCK_ACCESS_NET_LISTEN_TCP;
>> +	}
>>   
>>   	ruleset_fd =
>>   		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> @@ -380,6 +397,10 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>> +	if (populate_ruleset_net(ENV_TCP_LISTEN_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_LISTEN_TCP)) {
>> +		goto err_close_ruleset;
>> +	}
>>   
>>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>>   		perror("Failed to restrict privileges");
>> -- 
>> 2.34.1
>>
> 
> Reviewed-by: Günther Noack <gnoack3000@gmail.com>
