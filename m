From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: [PATCH] netfilter: nfnetlink_acct: use flag to reset counters
Date: Tue, 29 Jul 2014 15:46:00 +0400
Message-ID: <53D78978.5090408@samsung.com>
References: <20140725160123.GA20548@salvia>
 <1406570272-3704-2-git-send-email-a.perevalov@samsung.com>
 <20140728215325.GA4093@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10902 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaG2LqF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:46:05 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9H004MD208BE20@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 29 Jul 2014 12:45:44 +0100 (BST)
In-reply-to: <20140728215325.GA4093@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/29/2014 01:53 AM, Pablo Neira Ayuso wrote:
> On Mon, Jul 28, 2014 at 09:57:51PM +0400, Alexey Perevalov wrote:
>> Two additional NFACCT_F* was introduced for ability to reset
>> counters with and without quota separately.
>>
>> It could be useful when client has to reset counters and wants to keep
>> quotas untouched or vice versa without flushing and renewing.
>>
>> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
>> ---
>>   include/uapi/linux/netfilter/nfnetlink_acct.h |    2 ++
>>   net/netfilter/nfnetlink_acct.c                |   30 ++++++++++++++++++++-----
>>   2 files changed, 27 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
>> index 51404ec..1181c8e 100644
>> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
>> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
>> @@ -18,6 +18,8 @@ enum nfnl_acct_flags {
>>   	NFACCT_F_QUOTA_PKTS	= (1 << 0),
>>   	NFACCT_F_QUOTA_BYTES	= (1 << 1),
>>   	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
>> +	NFACCT_F_RESET_COUNTERS = (1 << 3),
>> +	NFACCT_F_RESET_QUOTAS   = (1 << 4),
>>   };
>>   
>>   enum nfnl_acct_type {
>> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
>> index 2baa125..1f47503 100644
>> --- a/net/netfilter/nfnetlink_acct.c
>> +++ b/net/netfilter/nfnetlink_acct.c
>> @@ -121,9 +121,23 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>>   	return 0;
>>   }
>>   
>> +static inline bool
>> +is_counters_reset(u32 nfacct_flags, unsigned long counter_flags)
>> +{
>> +	return nfacct_flags & NFACCT_F_RESET_COUNTERS &&
>> +		!(counter_flags & NFACCT_F_QUOTA);
>> +}
>> +
>> +static inline bool
>> +is_quotas_reset(u32 nfacct_flags, unsigned long counter_flags)
>> +{
>> +	return nfacct_flags & NFACCT_F_RESET_QUOTAS &&
>> +		counter_flags & NFACCT_F_QUOTA;
>> +}
> I think you can use the existing flags, ie.
>
> 1) If no flag is set, it means that userspace wants to dump/reset
> everything.
>
> 2) If NFACCT_F_QUOTA_PKTS is set, it means that userspace wants to
> dump/reset only packet-based quotas.
>
> 3) If NFACCT_F_QUOTA_BYTES is set, it means that userspace wants to
> dump/reset only byte-based quotas.
>
> 4) If NFACCT_F_QUOTA_PKTS|NFACCT_F_QUOTA_BYTES are set, any accounting
> object with quota is dump/reset.
>
> 5) If NFACCT_F_OVERQUOTA is set, only objects overquota are reset.
>
> ... Basically, you could even make any possible combination. I think
> that should be flexible enough for all cases.

>
> Therefore:
>
>>   static int
>>   nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>> -		   int event, struct nf_acct *acct)
>> +		   int event, struct nf_acct *acct, u32 nfacct_flags)
>>   {
>>   	struct nlmsghdr *nlh;
>>   	struct nfgenmsg *nfmsg;
>> @@ -143,7 +157,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>>   	if (nla_put_string(skb, NFACCT_NAME, acct->name))
>>   		goto nla_put_failure;
>>   
>> -	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
>> +	if (type == NFNL_MSG_ACCT_GET_CTRZERO &&
>> +		(!nfacct_flags || is_counters_reset(nfacct_flags, acct->flags) ||
>> +		is_quotas_reset(nfacct_flags, acct->flags))) {
> Replacing this:
>
>                  acct->flags & nfacct_flags == nfacct_flags
>
> I think it should be enough.
>
Yes, agree, but how to be with just counters without a quota,
at first look it should be
#define NFACCT_F_COUNTER ~(NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES | 
NFACCT_F_OVERQUOTA)
if you don't want additional flags, kernel will check it manually, 
because _no_ flag reserved for everything, as before.

Also I decided to put such condition not into nfnl_acct_fill_info, but 
directly into nfnl_acct_dump, it will make this feature more general,
client will get ability to filter it not only for reset command, but 
also for list command, also nfnl_acct_fill_info is using in many places, 
e.g.
just get command or nfnl_overquota_report.

And finally, I found strange approach for working with 
NFACCT_F_OVERQUOTA (value 1 << 2, 4), in nfnl_acct_overquota the 
test_and_set_bit function is used, which wants
Nth bit, and that Nth bit is 4, but not 2. Clearing is fine clear_bit 
accept Nth bit as well,
but nfnl_acct_new gets from netlink attribute NFACCT_F_OVERQUOTA not as 
offset value.

I took a look at it because of:
1. It's not convenient to keep combined bit set for NFACCT_F_COUNTER, 
because NFACCT_F_OVERQUOTA not what we have in acct->flags. Of course if 
you not against such bit set.
2. nlnf_overquata_report sends to user space _forth_ activated bit, but 
not _second_ for NFACCT_F_OVERQUOTA, but NFACCT_F_QUOTA_[BYTES|PKTS] was 
being sent as is. Output of the nfacct, after overquota event occurred, 
not so clear, in case of bytes quota it's just changing to package. It's 
not a big deal to fix it to print "overquoted", but I feel it's better 
to use some unified method to set bits.


-- 
Best regards,
Alexey Perevalov
