From: Pablo Neira <pablo@eurodev.net>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 22:00:25 +0100
Message-ID: <41B376E9.10607@eurodev.net>
References: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	'Henrik Nordstrom' <hno@marasystems.com>,
	'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>
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

Richard wrote:

>>  Hi,
>>
>>On Sat, 2004-12-04 at 15:55 +0100, Henrik Nordstrom wrote:
>>    
>>
>>>>ct->timeout->list.next != NULL
>>>>
>>>>test_bit(IPS_CONFIRMED_BIT, &ct->status)
>>>>        
>>>>
>>>The two is at most if not all times equal as all active conntrack
>>>      
>>>
>>entries
>>    
>>
>>>have a timeout of some sort, but maybe it is possible for the timeout to
>>>be established before the conntrack becomes confirmed or something..
>>>      
>>>
>>  It is definitely possible if you use ct_sync. Replicated entries on
>>the slave nodes do not have their timers started, but are in the hash
>>tables.
>>
>>    
>>
>
>I am writing a new target to manipulate the expire value of a conntrack,
>i.e. (ct->timeout.expires). If the expire timeout is not fired, it uses the
>timeout value. If it is, it uses jiffies+timeout. In order to check what
>state it is at, I'd use "ct->timeout->list.next!=NULL)", right?
>  
>

better use ip_ct_refresh_acct to manipulate a conntrack timer.

--
Pablo
