From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 14:43:41 +0200
Message-ID: <467FB87D.9020004@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Jun 25 2007 13:41, Patrick McHardy wrote:
>   
>>> +config NETFILTER_XT_MATCH_CONNLIMIT
>>> +	tristate '"connlimit" match support"'
>>> +	depends on NETFILTER_XTABLES && NF_CONNTRACK_IPV4
>>>   
>>>       
>> This doesn't seem right for an x_tables target. Adding IPv6 looks
>> trivial, the only thing that really depends on the address length
>> seems to be the masked comparison.
>>     
>
> Indeed - leftovers from its POM ascendant. But do I have to add ipv6 now?
>
> (It would also be quite a duplicate of count_them() and connlimit_match() -
> is there a better way without too many if()s?)
>   
I'd use a conditional in count_them and add an connlimit_match6 function.


>   
>>> +static inline unsigned int connlimit_iphash(u_int32_t addr)
>>> +{
>>> +	/*
>>> +	 * Since iphash (in struct xt_connlimit_data) has 256 entries, we need
>>> +	 * to "% 256" it. "& mask" works too, but _only_ if the iphash array
>>> +	 * size is exactly a {power of two} minus 1.
>>>   
>>>       
>> Incorrect comment, it does use &.
>>     
>
> I reword it.
>
>
>   
>> Can't be NULL here.
>> OK it can. But you should probably just continue for found == NULL above.
>>     
>
> I doubt I can do that. Is is part of the destruction.
> A little more below, there is /* this one is gone */
>   
Right.

>>> +	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
>>>   
>>>       
>> I prefer post-increment in all cases but those where pre-increment
>> is really needed.
>>     
>
> Can I ignore that?
>   

Yes.
>   
>>> +static struct xt_match connlimit_reg = {
>>>   
>>>       
>> __read_mostly?
>>     
>
> No other xt_ modules have it, but I can add it.
>   

They don't? I'll add it to the others.
>   
>>> +static int __init xt_connlimit_init(void)
>>> +{
>>> +	get_random_bytes(&connlimit_iphash_rnd, sizeof(connlimit_iphash_rnd));
>>>   
>>>       
>> We usually initialize jhash random values at the time the first
>> hash is calculated because there might be not enough entropy
>> available during boot.
>>     
>
> The routing code (where Eric pointed me to) does it on boot-up.
>   

It does not use get_random_bytes during boot and reinitizalizes the
random value after a flush.

> I have xt_connlimit loaded at boot (in runlevel B), there does not seem to be a
> problem.
>   

Think of a diskless system.
