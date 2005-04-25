From: Amin Azez <azez@ufomechanic.net>
Subject: Re: extending conntrack event data
Date: Mon, 25 Apr 2005 14:51:56 +0100
Message-ID: <426CF5FC.6090409@ufomechanic.net>
References: <42677180.60003@ufomechanic.net> <42677732.1000905@ufomechanic.net>
	<20050421180723.03CF.LARK@linux.net.cn>
	<426788B0.4090908@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <426788B0.4090908@eurodev.net>
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

> Wang Jian wrote:
>
>> On Thu, 21 Apr 2005 10:49:38 +0100, Amin Azez <azez@ufomechanic.net> 
>> wrote:
>>
>>> OK, I see that the skb is only available in ip_conntrack_event_cache 
>>> and not ip_conntrack_event. I'm not clear on the different purposes 
>>> of these two functions, but I see that both could potentially cause 
>>> events in conntrack(-tool). I also see that notifier_call_chain is a 
>>> general function and that my suggestion of adding an extra parameter 
>>> to it is not likely to be well received.
>>
>> ip_conntrack_event_cache() marks a bitmap to indicate that certain event
>> occurs. The message will not be delivered immediately due to whatever
>> reason such as performance. 
>
> right, performance is the reason why we use event caching. Spamming a 
> netlink message to user space every time a packet is received is 
> simply "matador" (overkill).

I've been through this in a lot of detail in the source, and I can't see 
how the source should give different behaviour to what I see, which is a 
netlink message for every packet of an open connection. (At least event 
caching stops multiple messages per packet)

I suspect the problem is either in the fact that ip_confirm calls 
ip_conntrack_deliver_cached_events for every packet, (ip_confirm is 
called as a netlink hook) or in what tcp_packet 
(net/ipv4/netfilter/ip_conntrack_proto_tcp.c) does to the skb before 
ip_confirm gets it.
(Is the problem because the connection terminates on the test machine 
instead of passing through it? I have confirmed that bridging has 
nothing to do with it)

We may get through this quickly if someone can send me their 
ip_conntrack_proto_tcp.c file to diff against; however I go into the 
detail of my examinations below.

tcp_packet always calls:
ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
unless new_state is one of TCP_CONNTRACK_IGNORE, TCP_CONNTRACK_MAX, 
TCP_CONNTRACK_SYN_SENT, TCP_CONNTRACK_CLOSE.

Is there a reason why we are doing this, even when new_state or 
old_state=TCP_CONNTRACK_ESTABLISHED ?
It also calls calling ip_conntrack_event_cache for pretty much every 
packet too, including those for TCP_CONNTRACK_ESTABLISHED connections.

Also, how is the code supposed to reduce the netlink message rate? The 
timer functions seem to be related only to death by timeout, there 
doesn't seem to be any mechanism for selecting only some packets for 
netlink notification/

As an experiement, if I type ^U into an active ssh session, tcpdump 
shows 4 packets, summarized below, along with the nfcache event value 
that was delivered over netlink for each one:

client->server: c04a (4a=IPCT_RELATED,IPCT_REFRESH,IPCT_PROTOINFO_VOLATILE)
server->client: c049 (49=IPCT_NEW | IPCT_REFRESH,IPCT_PROTOINFO_VOLATILE)
server->client: c049
client->server: c04a

Now I have shown where IPCT_REFRESH and IPCT_PROTINFO_VOLATILE are 
coming from but I don't see why I get IPCT_NEW for the return packets, 
and what could IPCT_RELATED mean for the packets in the original direction?

printk shows that the IPCT_NEW events and IPCT_RELATED events are NOT 
set via __ip_conntrack_confirm which does:
ip_conntrack_event_cache(master_ct(ct) ? IPCT_RELATED : IPCT_NEW, *pskb);
[which WOULD explain where the RELATED and NEW keep coming from, (but 
that should only happen if __ip_conntrack_confirm doesn't find either 
the forward or reverse tuple in the hash)]

What is troubling that is that nowhere else in net or include dirs is 
IPCT_RELATED used actively, so how is IPCT_RELATED getting in the 
skb->nfcache?

So the three questions are
1) should tcp_packet be setting so many event types in skb->nfcache as 
it does, for every packet?
2) should ip_confirm really be being called for every packet like it is?
3) or is the problem in IPCT_RELATED and IPCT_NEW being stuffed in the 
event flags, and what could cause this as it is NOT 
__ip_conntrack_confirm doing it?

Azez
