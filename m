From: Patrick McHardy <kaber@trash.net>
Subject: Re: Corruption on mangle/INPUT when MARKing packets
Date: Mon, 06 Jan 2003 17:26:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E19AE4F.5020908@trash.net>
References: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr> <20030106125230.GE9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Costa Tsaousis <costa@tsaousis.gr>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030106125230.GE9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Sat, Jan 04, 2003 at 03:47:21AM +0200, Costa Tsaousis wrote:
>
>  
>
>>During a few experiments I made I believe I have found a bug in
>>iptables. 
>>
>>To reproduce the bug, type:
>>
>># /etc/init.d/iptables stop
>># iptables -t mangle -A INPUT -p icmp -j MARK --set-mark 1
>>
>>Now, this host will be unpingable.
>>    
>>
>
>
>This is really strange.  I can perfectly reproduce the bug, but I cannot
>see how this happens.  the whole net/ipv4/icmp.c code doesn't do
>anything with the nfmark of the original skb.
>
>I'll have to investigate this further. Stay tuned.
> 
>Thanks for reporting the bug...
>
I think the problem lies within ip_route_me_harder. It is called on 
mangled packets in the INPUT chain
and changes skb->dst with new route after setting key.src = 0 if it's 
not a local address.
icmp_reply uses skb->dst to determine destination address: daddr = 
ipc.addr = rt->rt_src;

These log messages show i'm probably right:
PREROUTING IN=eth0 OUT= MAC=00:e0:7d:74:ab:cd:00:e0:7d:74:ab:cc:08:00 
SRC=192.168.0.1 DST=192.168.0.23 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 
DF PROTO=ICMP TYPE=8 CODE=0 ID=39444 SEQ=0
INPUT IN=eth0 OUT= MAC=00:e0:7d:74:ab:cd:00:e0:7d:74:ab:cc:08:00 
SRC=192.168.0.1 DST=192.168.0.23 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 
DF PROTO=ICMP TYPE=8 CODE=0 ID=39444 SEQ=0
OUTPUT IN= OUT=lo SRC=192.168.0.23 DST=192.168.0.23 LEN=84 TOS=0x00 
PREC=0x00 TTL=64 ID=17880 PROTO=ICMP TYPE=0 CODE=0 ID=39444 SEQ=0
^^^^ note SRC and DST are both the local ip
POSTROUTING IN= OUT=lo SRC=192.168.0.23 DST=192.168.0.23 LEN=84 TOS=0x00 
PREC=0x00 TTL=64 ID=17880 PROTO=ICMP TYPE=0 CODE=0 ID=39444 SEQ=0
PREROUTING IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 
SRC=192.168.0.23 DST=192.168.0.23 LEN=84 TOS=0x00 PREC=0x00 TTL=64 
ID=17880 PROTO=ICMP TYPE=0 CODE=0 ID=39444 SEQ=0
INPUT IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 
SRC=192.168.0.23 DST=192.168.0.23 LEN=84 TOS=0x00 PREC=0x00 TTL=64 
ID=17880 PROTO=ICMP TYPE=0 CODE=0 ID=39444 SEQ=0

Regards,
Patrick
