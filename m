From: Pablo Neira <pablo@eurodev.net>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 22:21:42 +0100
Message-ID: <41B37BE6.1090208@eurodev.net>
References: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>
	<41B376E9.10607@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, 'Krisztian Kovacs' <hidden@sch.bme.hu>,
	'Henrik Nordstrom' <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <41B376E9.10607@eurodev.net>
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

Pablo Neira wrote:

> Richard wrote:
>
>>>  Hi,
>>>
>>> On Sat, 2004-12-04 at 15:55 +0100, Henrik Nordstrom wrote:
>>>   
>>>
>>>>> ct->timeout->list.next != NULL
>>>>>
>>>>> test_bit(IPS_CONFIRMED_BIT, &ct->status)
>>>>>       
>>>>
>>>> The two is at most if not all times equal as all active conntrack
>>>>     
>>>
>>> entries
>>>   
>>>
>>>> have a timeout of some sort, but maybe it is possible for the 
>>>> timeout to
>>>> be established before the conntrack becomes confirmed or something..
>>>>     
>>>
>>>  It is definitely possible if you use ct_sync. Replicated entries on
>>> the slave nodes do not have their timers started, but are in the hash
>>> tables.
>>>
>>>   
>>
>>
>> I am writing a new target to manipulate the expire value of a conntrack,
>> i.e. (ct->timeout.expires). If the expire timeout is not fired, it 
>> uses the
>> timeout value. If it is, it uses jiffies+timeout. In order to check what
>> state it is at, I'd use "ct->timeout->list.next!=NULL)", right?
>>  
>>
>
> better use ip_ct_refresh_acct to manipulate a conntrack timer.


still think that you should use that function.

Hm, I just realized that the amanda helper is faking counters, I guess 
that we need a version of ip_ct_refresh_acct which doesn't the increase 
skb counters. I'll send a patch to fix this once I know what is 
scheduled with nf_conntrack.

--
Pablo
