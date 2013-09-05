From: Valentina Giusti <valentina.giusti@oss.bmw-carit.de>
Subject: Re: [PATCH 2/4] libnetfilter-acct: Introduce support for notifications
Date: Thu, 05 Sep 2013 10:04:43 +0200
Message-ID: <52283B1B.4010800@oss.bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de> <1378296333-19208-3-git-send-email-valentina.giusti@bmw-carit.de> <20130904124420.GA3541@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49638 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757216Ab3IEIEo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:04:44 -0400
In-Reply-To: <20130904124420.GA3541@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 09/04/2013 02:44 PM, Pablo Neira Ayuso wrote:
> On Wed, Sep 04, 2013 at 02:05:31PM +0200,valentina.giusti@bmw-carit.de  wrote:

<snip>

>>   #define NFACCT_MAX (__NFACCT_MAX - 1)
>> diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
>> index ba89e2d..4fb0d26 100644
>> --- a/src/libnetfilter_acct.c
>> +++ b/src/libnetfilter_acct.c
>> @@ -60,6 +60,11 @@ struct nfacct {
>>   	char		name[NFACCT_NAME_MAX];
>>   	uint64_t	pkts;
>>   	uint64_t	bytes;
>> +	uint32_t	notify_pkts;
>> +	uint32_t	notify_pkts_rl;
>> +	uint32_t	notify_bytes;
>> +	uint32_t	notify_bytes_rl;
>> +	uint32_t	notify_period;
> This is bloating the nfacct object for everyone in the earth not using
> this notification infrastructure.

Right... I'll replace this with a pointer to another structure. Do you 
suggest that I also #ifdef everything?

Thank you.

-V.
