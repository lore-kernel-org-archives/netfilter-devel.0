From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] add direction match to conntrack match
Date: Fri, 01 Jun 2007 20:28:11 +0100
Message-ID: <4660734B.3090203@ufomechanic.net>
References: <46604886.4080400@ufomechanic.net> <46604998.3050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46604998.3050602@trash.net>
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

Patrick McHardy wrote:
> Amin Azez wrote:
>   
>> This adds the virtual states ORIGINAL and REPLY to the conntrack match,
>> making it possible to tell if the packet being compared is part of the
>> original flow or the reply flow.
>>
>> e.g.
>>
>> iptables -t mangle -A PREROUTING -m conntrack --ctstate REPLY
>>
>> The patch is against kernel 2.6.17 and iptables 1.3.6, but it is simple
>> enough.
>>     
>
>
> I've been using a similar patch at a previous job, I think its quite
> useful, so if you send me a patch for current -git I'll queue it
> for 2.6.23.
>
>   
>> Index: linux-2.6.17.1/include/linux/netfilter/xt_conntrack.h
>> ===================================================================
>> --- linux-2.6.17.1.orig/include/linux/netfilter/xt_conntrack.h
>> +++ linux-2.6.17.1/include/linux/netfilter/xt_conntrack.h
>> @@ -14,6 +14,9 @@
>>  #define XT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
>>  #define XT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
>>  #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
>> +/* match on direction of packet */
>> +#define XT_CONNTRACK_STATE_ORIGINAL (1 << (IP_CT_NUMBER + 4))
>> +#define XT_CONNTRACK_STATE_REPLY (1 << (IP_CT_NUMBER + 5))
>>     
>
>
> But I think use should use a regular flag for this. The
> XT_CONNTRACK_STATE_SNAT are already a not so great idea
> since the same information is in the status bits, which
> can also be matched.
>   
The regular flags are declared as u_int8_t, and all 8 bits are already used.

This was the neatest way I could come up with without destroying 
user-space compatability.

Git will have to wait a week I'm afraid, but you'll get it ASAP.

Sam
