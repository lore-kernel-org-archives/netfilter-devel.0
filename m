From: Patrick McHardy <kaber@trash.net>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Fri, 31 Aug 2007 10:45:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708311044490.32663@x2>
References: <46CE8C05.5060202@nj.cpsecure.com>
	<200708290914.l7T9E934019648@toshiba.co.jp>
	<46D5BFB5.6000206@trash.net> <46D61A10.6010405@nj.cpsecure.com>
	<46D66874.1050405@trash.net> <46D6927F.1010406@nj.cpsecure.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D6927F.1010406@nj.cpsecure.com>
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

On Thu, 30 Aug 2007, Dong_Wei wrote:

>>> And we can't avoid this issue on 2.4, because no code deal with the 
>>> special case.
>> 
>> 
>> Thats correct. Is there a problem with this behaviour?
>
> As we know, ip_conntrack has a hash_size to control the ip_conntrack record 
> size. and if tcp in ESTABLISH, and ip_conntrack will keep it for 5 DAYs.
>
> For exsample, a NAT server can handle 8000 connections, and if sometime, NAT 
> server need reboot(6000 conntrack in ESTBLISHED state now). Also we set 
> ip_conntrack allowing pickup ESTABLISHED tcp connection, when NAT server 
> available again, ip_conntrack will take 6000 conntracks for the original 
> connections. but actully these connections are INVALID for the web server, 
> because the source ip is the private IPs,such as 192.168.0.1. and web server 
> will not answer the client's request. But still the NAT server will keep the 
> 6000 conntrack for 5 DAYs. And just 2000 conntracks can be used for the 
> clients. If more than 2000 client want connect to some websites, some 
> ip_conntrack will be droped.


You can drop ACK packets in state NEW to avoid connection pickup.
