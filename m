From: Amin Azez <azez@ufomechanic.net>
Subject: solved Re: missing conntrack protocol on updates
Date: Thu, 16 Jun 2005 17:11:34 +0100
Message-ID: <42B1A4B6.8090209@ufomechanic.net>
References: <42A033E9.3020907@ufomechanic.net> <42A23449.5020708@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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


I had mistakenly thought that ctnetlink_fill_info was the only place 
that constructed conntrack netlink packets but now I see that I had 
missed out ctnetlink_conntrack_event which tries to optimize away the 
protocol information if it has not changed but always outputs the tuple.

This seems a mistake because the tuple identifies the conntrack by IP 
and port and protocol, and as there is no medium term conntrack ID 
available the protocol will also be needed to trace the conntrack 
updates as.

Sam

Pablo Neira wrote:

> Hi Amin,
>
> Amin Azez wrote:
>
>> Of course as I am using a custom conntrack kernel module which also 
>> dumps out the mac addresses the fault could be here, I wondered if 
>> you would leave that grep running for a while to see if the fault is 
>> a general one?
>
> >
>
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2118 
>> src=192.168.0.233 dst=192.168.0.252 sport=2118 dport=80 
>> timeout=432000 orig_packets=1 orig_bytes=52 reply_packets=1 
>> reply_bytes=52 src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2128 
>> src=192.168.0.233 dst=192.168.0.252 sport=2128 dport=80 
>> timeout=432000 orig_packets=1 orig_bytes=52 reply_packets=1 
>> reply_bytes=52 src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2133 
>> src=192.168.0.233 dst=192.168.0.252 sport=2133 dport=80 
>> timeout=432000 orig_packets=1 orig_bytes=52 reply_packets=1 
>> reply_bytes=52 src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>> [UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2134 
>> src=192.168.0.233 dst=192.168.0.252 sport=2134 dport=80 
>> timeout=432000 orig_packets=1 orig_bytes=52 reply_packets=1 
>> reply_bytes=52 src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
>
>
> This seems related to you hack. All those update messages tell me that 
> you are sending a netlink event message for every 
> IPCT_PROTINFO_VOLATILE event, aren't you? Maybe you're doing something 
> similar, I'd need to see the code anyway.
