From: Amin Azez <azez@ufomechanic.net>
Subject: Re: missing conntrack protocol on updates
Date: Mon, 13 Jun 2005 16:09:48 +0100
Message-ID: <42ADA1BC.9080706@ufomechanic.net>
References: <42A033E9.3020907@ufomechanic.net> <42A23449.5020708@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42A23449.5020708@eurodev.net>
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

[sorry for the delay in responding I've been away]

Pablo Neira wrote:
> Hi Amin,
> 
> Amin Azez wrote:
> 
>> Of course as I am using a custom conntrack kernel module which also 
>> dumps out the mac addresses the fault could be here, I wondered if you 
>> would leave that grep running for a while to see if the fault is a 
>> general one?
> 
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2118 
>> src=192.168.0.233 dst=192.168.0.252 sport=2118 dport=80 timeout=432000 
>> orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
>> src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2128 
>> src=192.168.0.233 dst=192.168.0.252 sport=2128 dport=80 timeout=432000 
>> orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
>> src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2133 
>> src=192.168.0.233 dst=192.168.0.252 sport=2133 dport=80 timeout=432000 
>> orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
>> src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2134 
>> src=192.168.0.233 dst=192.168.0.252 sport=2134 dport=80 timeout=432000 
>> orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
>> src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
> 
> 
> This seems related to you hack. All those update messages tell me that 
> you are sending a netlink event message for every IPCT_PROTINFO_VOLATILE 
> event, aren't you? 

As the dport addresses are all different I'm not sure how you conclude this.

> Maybe you're doing something similar, 

I'm not deliberately sending a message for every 
IPCT_PROTOINFO_VOLATILE, although - good guess - I will be wanting to 
get more frequent updates for long lived connections.

> I'd need to see the code anyway.

I'll send patches to conntrack and to kernel 2.6.12 seperately.

> If my guess is correct, such loss of messages is related to the nature 
> of the netlink sockets. Netlink is a unreliable protocol. Under *heavy* 
> loads and if the messages are sent from interrupt context it will be 
> likely to drop messages for spamming events.

Aye, I've been able to do this, but never drop only part of a message, 
usually the entire netlink packet is dropped, so its interesting that 
only the protocol part is missing.

Amin
