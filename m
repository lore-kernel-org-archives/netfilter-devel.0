From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: [PATCH v3 1/2] nfacct: check cmd line argument for singleness
Date: Fri, 12 Sep 2014 12:24:51 +0400
Message-ID: <5412ADD3.4080203@samsung.com>
References: <1410450640-2414-1-git-send-email-a.perevalov@samsung.com>
 <1410450640-2414-2-git-send-email-a.perevalov@samsung.com>
 <20140911165537.GA6897@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25433 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaILIY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:24:56 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBS00IUA4U90M60@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Fri, 12 Sep 2014 09:27:45 +0100 (BST)
In-reply-to: <20140911165537.GA6897@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/11/2014 08:55 PM, Pablo Neira Ayuso wrote:
> On Thu, Sep 11, 2014 at 07:50:39PM +0400, Alexey Perevalov wrote:
>> It was possible to specify several equal options for list operation.
>>
>> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
>> ---
>>   src/nfacct.c |   16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/nfacct.c b/src/nfacct.c
>> index 091a5c9..d77a57e 100644
>> --- a/src/nfacct.c
>> +++ b/src/nfacct.c
>> @@ -25,6 +25,13 @@
>>   #include <linux/netfilter/nfnetlink_acct.h>
>>   #include <linux/netfilter/nfnetlink.h>
>>   
>> +#define CHECK_OPT_PLURARITY(opt_name, msg) \
>> +	opt_name += 1; \
>> +	if (opt_name > 1) { \
>> +		nfacct_perror(msg); \
>> +		return -1; \
>> +	}
>> +
>>   enum {
>>   	NFACCT_CMD_NONE = 0,
>>   	NFACCT_CMD_LIST,
>> @@ -166,6 +173,8 @@ err:
>>   	return MNL_CB_OK;
>>   }
>>   
>> +#define NFACCT_F_QUOTAS (NFACCT_F_QUOTA_BYTES | NFACCT_F_QUOTA_PKTS)
>> +
>>   static int nfacct_cmd_list(int argc, char *argv[])
>>   {
>>   	bool zeroctr = false, xml = false;
>> @@ -177,8 +186,14 @@ static int nfacct_cmd_list(int argc, char *argv[])
>>   
>>   	for (i=2; i<argc; i++) {
>>   		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
>> +			static int opt_reset;
>> +			CHECK_OPT_PLURARITY(opt_reset, "reset couldn't be "
>> +				            "defined more than once");
> I prefer if you add something similar to what iproute2 provides:
>
> void duparg2(const char *key, const char *arg)
> {
>          fprintf(stderr, "Error: either \"%s\" is duplicate, or \"%s\" is a garbage.\n", key, arg);
>          exit(-1);
> }
>
> You can probably check:
>
>                          if (zeroctr)
>                                  duparg2("reset", argv[i]);
>
>>   			zeroctr = true;
>>   		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
>> +			static int opt_xml;
>> +			CHECK_OPT_PLURARITY(opt_xml, "xml couldn't be defined "
>> +					    "more than once");
> Similar thing here.
>
> I always wanted to get this code more in line iproute2, but failed to
> find the time, later.
>
> So please, do it the way I'm proposing so we start looking into
> converging to iproute2.
ok, but now nfacct doesn't use iprout2, so suggested function should by 
copy-pasted, maybe with modification,
because "is a garbage" I think no necessary.
Do you want to make nfacct code more similar with iproute2 code, to 
merge it in future?

>
> Thanks.
>


-- 
Best regards,
Alexey Perevalov,
Tizen Developer,
phone: +7 (495) 797 25 00 ext 3969
e-mail: a.perevalov@samsung.com <mailto:a.perevalov@samsumng.com>

Mobile group, Samsung R&D Institute Rus
12 Dvintsev street, building 1
127018, Moscow, Russian Federation
