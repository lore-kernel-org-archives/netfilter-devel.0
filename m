From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH v2 2/3] netfilter: log: protect nf_log_register against
 double registering
Date: Tue, 28 Oct 2014 10:51:40 -0200
Message-ID: <544F915C.7010608@redhat.com>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com> <dad1a3c1e30a676f3d17244ec74acef4dd0c9ca9.1414155204.git.mleitner@redhat.com> <20141027220908.GB5998@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJ1Mv7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:51:59 -0400
In-Reply-To: <20141027220908.GB5998@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27-10-2014 20:09, Pablo Neira Ayuso wrote:
> Hi Marcelo,
>
> I just noticed another minor issue that I didn't notice in my previous
> review.
>
> On Fri, Oct 24, 2014 at 10:59:50AM -0200, Marcelo Ricardo Leitner wrote:
>> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
>> index f1409d95f810c689ec70755eb8a85125d291ad47..e7c7439f48db590eba8f7f2eac61fafd9e571389 100644
>> --- a/net/netfilter/nf_log.c
>> +++ b/net/netfilter/nf_log.c
>> @@ -82,10 +82,19 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>>   	mutex_lock(&nf_log_mutex);
>>
>>   	if (pf == NFPROTO_UNSPEC) {
>> +		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
>> +			if (nft_log_dereference(loggers[i][logger->type])) {
>
> Given that we're not dereferencing, I think you can use
> rcu_access_pointer() instead here.

Right! I'll update it (this and the below one) and send in a few, thanks.

Marcelo

>> +				mutex_unlock(&nf_log_mutex);
>> +				return -EEXIST;
>> +			}
>> +		}
>>   		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
>>   			rcu_assign_pointer(loggers[i][logger->type], logger);
>>   	} else {
>> -		/* register at end of list to honor first register win */
>> +		if (nft_log_dereference(loggers[pf][logger->type])) {
>
> Same thing here.
>

