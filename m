From: "Jorge Bastos" <mysql.jorge@decimal.pt>
Subject: PPTP Problem with 2.6.20-rc1 >=
Date: Sat, 20 Jan 2007 11:54:51 -0000
Message-ID: <087801c73c89$cb5e00b0$0301a8c0@hercules.decimalint.pt>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

As Patrick asked me to do, i'm reporting this to this list, below is the 
complete report i did to the users list, and the info patrick told me to 
add.

nf_contrack, and below theres nf_conntrack_expect, i did a grep to show only 
the lines that we need.
As soon you have a feedback tell me something to the list :P

Jorge


cisne:/proc/net# cat nf_conntrack|grep -i 192.168.1.3
ipv4     2 tcp      6 431984 ESTABLISHED src=192.168.1.3 dst=84.91.32.190 
sport=2521 dport=1723 packets=6 bytes=608 src=84.91.32.190 dst=195.23.114.78 
sport=1723 dport=2521 packets=8 bytes=580 [ASSURED] mark=0 secmark=0 use=3
ipv4     2 gre      47 598 timeout=600, stream_timeout=18000 src=192.168.1.3 
dst=84.91.32.190 srckey=0x4000 dstkey=0x280 packets=5 bytes=285 [UNREPLIED] 
src=84.91.32.190 dst=195.23.114.78 srckey=0x280 dstkey=0x4000 packets=0 
bytes=0 mark=0 secmark=0 use=1


nf_conntrack_expect:

cisne:/proc/net# cat nf_conntrack_expect|grep -i 192.168.1.3
288 l3proto = 2 proto=47 src=192.168.1.3 dst=84.91.32.190 srckey=0x8000 
dstkey=0x300
253 l3proto = 2 proto=47 src=192.168.1.3 dst=84.91.32.190 srckey=0x4000 
dstkey=0x280


Pablo Neira Ayuso wrote:
> JFYI: Someone is reporting a problem with the pptp thing in
> netfilter-users, unfortunately I'm not familiar with those bits.

Thanks Pablo. Jorge, can you please resend your report to
netfilter-devel and include output of /proc/net/nf_conntrack (the
GRE and PPtP-sessions) and /proc/net/nf_conntrack_expect?
Thanks.

>
>
>
> ------------------------------------------------------------------------
>
> Subject:
> PPTP Problem with 2.6.20-rc1 >=
> From:
> "Jorge Bastos" <mysql.jorge@decimal.pt>
> Date:
> Tue, 16 Jan 2007 18:37:32 -0000
> To:
> <netfilter@lists.netfilter.org>
>
> To:
> <netfilter@lists.netfilter.org>
>
> Hi,
> I just updated kernel to 2.6.20-rc5, and i can't make pptp connections
> anymore, is just stoped in the AUTH step, hanging up witout sucess.
>
> My cenario is:
>
> My private network => linux router (this machine) => ISP
>
> I can see that diferent modules are used now, before i used:
> ---
> ip_nat_pptp
> ip_conntrack_pptp
> ---
>
> Now there's new modules with new names, like:
> nf_nat_pptp
> nf_conntrack_pptp
>
> Are they the same with diferent names?
> Thanks,
> Jorge
>
> Below there the modules i have loaded:
>
> ---
> ipt_REJECT              3584  2
> xt_tcpudp               3200  38
> nf_nat_pptp             3712  0
> nf_conntrack_pptp       6656  1 nf_nat_pptp
> nf_conntrack_proto_gre     4992  1 nf_conntrack_pptp
> nf_nat_proto_gre        2820  1 nf_nat_pptp
> nf_nat_ftp              3328  0
> nf_conntrack_ftp        8320  1 nf_nat_ftp
> nf_nat_irc              2688  0
> nf_conntrack_irc        6168  1 nf_nat_irc
> ipt_MASQUERADE          3456  1
> iptable_nat             7300  1
> nf_nat                 15404  6
> nf_nat_pptp,nf_nat_proto_gre,nf_nat_ftp,nf_nat_irc,ipt_MASQUERADE,iptable_nat
>
> nf_conntrack_ipv4      15372  2 iptable_nat
> nf_conntrack           54488  11
> nf_nat_pptp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_nat_ftp,nf_conntrack_ftp,nf_nat_irc,nf_conntrack_irc,ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4
>
> nfnetlink               5656  2 nf_conntrack_ipv4,nf_conntrack
> iptable_filter          2688  1
> ip_tables              10952  2 iptable_nat,iptable_filter
> x_tables               12548  5
> ipt_REJECT,xt_tcpudp,ipt_MASQUERADE,iptable_nat,ip_tables
>
>
> And dmesg show's me:
>
> ip_tables: (C) 2000-2006 Netfilter Core Team
> Netfilter messages via NETLINK v0.30.
> nf_conntrack version 0.5.0 (1024 buckets, 8192 max)
>
>
> ---
>
