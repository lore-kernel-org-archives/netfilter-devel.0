From: Amin Azez <azez@ufomechanic.net>
Subject: Re: BUG/CONFLICT conntrack with preroute/postroute mangle table
Date: Thu, 05 May 2005 12:08:07 +0100
Message-ID: <d5cue9$3qf$1@sea.gmane.org>
References: <42677180.60003@ufomechanic.net>
	<42677732.1000905@ufomechanic.net>	<20050421180723.03CF.LARK@linux.net.cn>	<426788B0.4090908@eurodev.net>
	<426CF5FC.6090409@ufomechanic.net>	<426D1C69.2060107@ufomechanic.net>	<426D1E35.4030605@ufomechanic.net>
	<426E4442.5070800@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <426E4442.5070800@ufomechanic.net>
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

Further to the problem below, skb->nfcache is having the lower 2 bits 
clobbered by net/ipv4/netfilter/ip_tables.c around line 316 (2.6.11.7)

         back = get_entry(table_base, table->private->underflow[hook]);

         do {
                 IP_NF_ASSERT(e);
                 IP_NF_ASSERT(back);

//THIS IS THE CULPRIT!
                 (*pskb)->nfcache |= e->nfcache;


e->nfcache has been observed at 0,1,2,0x4000
1 and 2 are IPCT_NEW and IPCT_RELATED and these are causing the damage.

At this point, e is a: struct ipt_entry *e

I haven't manage to find in the kernel source where nfcache of an 
ipt_entry is used or set for anything.

find net include -type f | xargs grep 'nfcache' | less
shows every modification to be on some kind of skb!

I'm baffled, but I'll keep looking to see where this is being set.

Anyone else got ideas?

Is this maybe just ipt_entry not being properly initialized when 
allocated and I'm just getting junk?

Amin Azez wrote:
> 
> I've got a sample case of two iptables rules that reproduce the problems 
> of a netlink message for every packet that I have been having with 
> conntrack(-tool).
> 
...
> To reproduce the bug, follow these steps which I have just verified, yes 
> on a pristine 2.6.11.7 kernel with ctnetlink, nfnetlink and 
> conntrack-event-api (and without my conntrack mac address patches):
> 
> 1) modprobe ip_conntrack_netlink
> 2) /path/to/conntrack -E conntrack
> 3) now connect to the box and see that conntrack is reporting NEW UPDATE 
> UPDATE
> 
> then do: (1.2.3.4 is any IP address nowhere near your network)
> 4) iptables -t mangle -A PREROUTING -d 1.2.3.4
> 5) iptables -t mangle -A POSTROUTING -d 1.2.3.4
> 7) /path/to/conntrack -E conntrack
> 8) now connect to the box and watch it spring an event for every packet 
> as NEW NEW NEW
> 
> Thats it! So why does presence of these rules in PREROUTING and 
> POSTROUTING damage skb->nfcache in this way?
> Either rule will do it, they aren't both needed, but note that the rules 
> don't actually match OR take any action if it does match.
> 
> So it is merely the action of processing the rule that breaks 
> skb->nfcache value.
> 
> Amin
> 
> Amin Azez wrote:
> 
>> Further investigation points to the layer 7 matching and mangle-tables 
>> rules etc, once I remove those rules it stops the magical increment 
>> from 4078 to c079.
>>
>> Possibly this has been the cuase of the problems, I'll check tomorrow 
>> to see how this could cause it.
>>
>> Amin
>>
>> Amin Azez wrote:
>>
>>> Looking at some of my skb->nfcache debugging
>>> (de8ce580 is the skb address)
>>>
>>> during tcp_packet, I get calls to ip_conntrack_event_cache which 
>>> changes nfcache thus:
>>> * event_cache on de8ce580 from 4000 to 4040
>>> * event_cache on de8ce580 from 4040 to 4060
>>> * {leave tcp_packet}
>>> * event_cache on de8ce580 from 4060 to 4068
>>> * event_cache on de8ce580 from 4068 to 4078
>>> * deliver_cached_events c079 right now skb de8ce580
>>>
>>> By the time ip_confirm is called some more stuff has happened to 
>>> nfcache, hence ip_confirm c079 de8ce580
>>>
>>> Question is how did the nfcache get from 4078 to c079
>>> It was c079 when ip_confirm was called
>>>
>>> Whence the extra 8001 that has been combined? The 1 is IPCT_NEW, the 
>>> 8000 is NFC_ALTERED
>>>
>>> NFC_ALTERED is used in various places, the most like in 
>>> ip_ct_gather_frags but this hardly seems likely if src and dst 
>>> machines are on the same subnet?
>>> I confirmed with logging that it isn't there so I will have to add 
>>> debug to all the other places to see which one is guilty.
>>>
>>> Azez
>>>
>>
>>
> 
> 
> 
