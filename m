From: "Cheng,Yu-Chin" <jenny@wiscore.com>
Subject: Executing NAT and iptables on SUMSUNG S3C4510B
Date: Thu, 09 Jan 2003 18:08:23 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1D4A17.5040309@wiscore.com>
References: <3E1D44E7.4040205@msa.hinet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jenny Cheng wrote:

> 
>Dear all:
> 
>   I have some problems in executing kernel 2.4.19 image with NAT and 
>iptables supported on  SAMSUNG S3C4510b.
> 
>   Please see the following information  and give me some ideas.
>   Kernel  about NETWORK configure options and system message.
>
>#
>CONFIG_PACKET=y
>
># CONFIG_PACKET_MMAP is not set
>CONFIG_NETLINK_DEV=y
>CONFIG_NETFILTER=y
>CONFIG_NETFILTER_DEBUG=y
>CONFIG_FILTER=y
>CONFIG_UNIX=y
>CONFIG_INET=y
># CONFIG_IP_MULTICAST is not set
># CONFIG_IP_ADVANCED_ROUTER is not set
># CONFIG_IP_PNP is not set
># CONFIG_NET_IPIP is not set
># CONFIG_NET_IPGRE is not set
># CONFIG_INET_ECN is not set
># CONFIG_SYN_COOKIES is not set
>
>#
>#   IP: Netfilter Configuration
>#
>CONFIG_IP_NF_CONNTRACK=y
>CONFIG_IP_NF_FTP=y
>CONFIG_IP_NF_IRC=y
>CONFIG_IP_NF_IPTABLES=y
># CONFIG_IP_NF_MATCH_LIMIT is not set
>CONFIG_IP_NF_MATCH_MAC=y
># CONFIG_IP_NF_MATCH_MARK is not set
>CONFIG_IP_NF_MATCH_MULTIPORT=y
>CONFIG_IP_NF_MATCH_TOS=y
># CONFIG_IP_NF_MATCH_AH_ESP is not set
># CONFIG_IP_NF_MATCH_LENGTH is not set
># CONFIG_IP_NF_MATCH_TTL is not set
>CONFIG_IP_NF_MATCH_TCPMSS=y
># CONFIG_IP_NF_MATCH_STATE is not set
>CONFIG_IP_NF_FILTER=y
># CONFIG_IP_NF_TARGET_REJECT is not set
>CONFIG_IP_NF_NAT=y
>CONFIG_IP_NF_NAT_NEEDED=y
>CONFIG_IP_NF_TARGET_MASQUERADE=y
>CONFIG_IP_NF_TARGET_REDIRECT=y
>CONFIG_IP_NF_NAT_LOCAL=y
>CONFIG_IP_NF_NAT_IRC=y
>CONFIG_IP_NF_NAT_FTP=y
>CONFIG_IP_NF_MANGLE=m
># CONFIG_IP_NF_TARGET_TOS is not set
># CONFIG_IP_NF_TARGET_MARK is not set
>CONFIG_IP_NF_TARGET_LOG=y
>CONFIG_IP_NF_TARGET_ULOG=y
># CONFIG_IP_NF_TARGET_TCPMSS is not set
>CONFIG_IP_NF_ARPTABLES=y
>CONFIG_IP_NF_ARPFILTER=y
># CONFIG_VLAN_8021Q is not set
># CONFIG_IPX is not set
># CONFIG_ATALK is not set
>
>
>Unhandled fault: alignment exception (13) at 0x00000001
>fault-common.c(97): start_code=0xfc0040, start_stack=0xfdff78)
>Internal error: Oops: 0
>CPU: 0
>pc : [<000bfbbc>]    lr : [<00000006>]    Not tainted
>sp : 00e039f0  ip : 00000000  fp : 00e03a54
>r10: 00167ee2  r9 : 00000006  r8 : 00000000
>r7 : 00000006  r6 : 00162534  r5 : 00162500  r4 : 00162544
>r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00167ede
>Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
>Control: 0
>Process dhcpcd (pid: 11, stackpage=00e03000)
>Stack:
>00e039e0: 00000006 000bfbbc 60000013 ffffffff  00000000 00000000 
>00166260 00167e
>e8
>00e03a00: 00167ede 00162420 000deea0 000d6fad  00162500 00167ed0 
>00000000 000dee
>a0
>00e03a20: 00000000 00000001 00e03ab0 000e0d90  00e03aac 00000001 
>000fffe4 000000
>00
>00e03a40: 00072f9c 00e03ab0 00e03a6c 00e03a58  000c1e30 000bf960 
>000e0d3c 000000
>00
>00e03a60: 00e03a9c 00e03a70 0007a80c 000c1e10  00072f9c 00000002 
>00000001 000000
>00
>00e03a80: 000deea0 00072f9c 00000000 00000000  00e03adc 00e03aa0 
>0007ace4 0007a7
>c0
>00e03aa0: 000deea0 00e03aac 00072f9c 000e0d90  00166260 00000004 
>00167ee2 001662
>60
>00e03ac0: 000deea0 00167ed0 00000806 000def18  00e03b18 00e03ae0 
>000a6a58 0007ab
>b0
>00e03ae0: 000deea0 00072f9c 00000001 6e00a8c0  00000000 00f720a0 
>b600a8c0 000dee
>a0
>00e03b00: 00000000 00000000 6e00a8c0 00e03b50  00e03b1c 000a6414 
>000a6844 b600a8
>c0
>00e03b20: 00000000 000def18 00000000 00f720a0  000e8d60 001661c0 
>000e8d68 00087a
>78
>00e03b40: 00000000 00e03b70 00e03b54 00077314  000a6340 00f73120 
>001661c0 00f731
>20
>00e03b60: 00f720a0 00e03ba0 00e03b74 00077c54  00077240 000e00b4 
>00e03bcc 00f731
>20
>00e03b80: 001661c0 00000000 000deea0 00087a78  00000000 00e03bbc 
>00e03ba4 00087b
>48
>00e03ba0: 00077bd8 00000001 00000004 00000002  00e03bfc 00e03bc0 
>0007ad30 00087a
>88
>00e03bc0: 000deea0 00e03bcc 00087a78 0010007c  001661c0 00000001 
>00000003 000000
>02
>00e03be0: 000deea0 00087a5c 00000000 00000000  00e03c14 00e03c00 
>0008657c 0007ab
>b0
>00e03c00: 000deea0 00087a78 00e03c24 00e03c18  00087a74 00086524 
>00e03c64 00e03c
>28
>00e03c20: 0007ad30 00087a6c 000deea0 00e03c34  00087a5c 00100074 
>001661c0 001508
>10
>00e03c40: 001661c0 00174a00 00000404 00f73120  00000000 00150824 
>00e03ca8 00e03c
>68
>00e03c60: 00087214 0007abb0 000deea0 00087a5c  00000000 00e03d0c 
>000a7d88 000000
>00
>00e03c80: 000003e8 00000000 00e03cbc 00e03cd4  00000000 6e00a8c0 
>00e03d0c 00e03d
>08
>00e03ca0: 00e03cac 000a7fd4 00086ec4 00e03cd4  00f73120 00000040 
>00174a00 00f731
>20
>00e03cc0: 6e00a8c0 b600a8c0 00000000 00000000  00000000 6e00a8c0 
>00e03ce4 000000
>00
>00e03ce0: 00166120 00f73080 001013c0 00000001  00000000 00000000 
>000deea0 00e03d
>74
>00e03d00: 00e03d0c 000a882c 000a7e38 00166120  00000000 000003e8 
>00000000 000000
>00
>00e03d20: 09c12855 00000001 00e03d84 00166120  00000008 00000000 
>00000000 000000
>02
>00e03d40: 00000260 00000000 0000004c 00166120  00f73080 001013c0 
>00000001 000000
>00
>00e03d60: 00000000 000deea0 00e03d90 00e03d78  000a8cb8 000a87e0 
>00166120 000000
>00
>00e03d80: 00000004 00e03db4 00e03d94 00083920  000a8b54 00000001 
>00000001 000000
>02
>00e03da0: 00000000 000837fc 00e03df4 00e03db8  0007ad30 0008380c 
>00000000 00e03d
>c4
>00e03dc0: 000837fc 00100064 00166120 00150020  000deea0 00166120 
>00000000 00083a
>00
>00e03de0: 00000000 000deea0 00e03e0c 00e03df8  0008353c 0007abb0 
>00000000 000837
>fc
>00e03e00: 00e03e3c 00e03e10 00083c28 000834e8  000deea0 00000001 
>00000000 000000
>02
>00e03e20: 00000000 00000001 00000000 00000002  00e03e7c 00e03e40 
>0007ad30 00083a
>10
>00e03e40: 00000000 00e03e4c 00083a00 0010005c  00166120 00000005 
>00166120 001661
>20
>00e03e60: 00100ba0 000deea0 000da260 0000012c  00e03ea8 00e03e80 
>00083794 0007ab
>b0
>00e03e80: 00000000 00083a00 00000000 00166120  000deea0 00000008 
>000ffd80 00e03e
>dc
>00e03ea0: 00e03eac 000739dc 00083558 0000012b  0000012a 000da150 
>00000001 000e8d
>60
>00e03ec0: fffffffb 000da140 000e8d60 60000093  00e03f04 00e03ee0 
>00023a7c 000737
>cc
>00e03ee0: 00000000 00000011 20000000 000e1ab0  000e1890 00e03f34 
>00e03f30 00e03f
>08
>00e03f00: 00017588 00023a0c 00e03f68 03ff4034  00033180 00032de0 
>20000013 ffffff
>ff
>00e03f20: 00fdfea4 00e03f8c 00e03f34 00016960  00017454 00155000 
>00000241 000001
>b6
>00e03f40: 0000d300 00000241 00000241 000001b6  00155000 00016dc0 
>00000005 00fdfe
>a4
>00e03f60: 00e03f8c 00e03f90 00e03f7c 00033180  00032de0 20000013 
>ffffffff 000000
>05
>00e03f80: 00e03fac 00e03f90 00033180 00032de0  00fcfd60 00000241 
>ffffffff 00e020
>00
>00e03fa0: 00000000 00e03fb0 00016c20 0003314c  00fcfd60 0001df5c 
>00fcfd60 000002
>41
>00e03fc0: 000001b6 000001b6 00fcfd60 00000241  ffffffff 00000000 
>00fcfd60 000000
>04
>00e03fe0: 00fdfea4 00fdfd48 00000241 00fdfd34  00fc9dc0 00fc9d74 
>20000010 00fcfd
>60
>Backtrace:
>Function entered at [<000bf950>] from [<000c1e30>]
>                                  ^^^^^^^^ arpt_do_table
>Function entered at [<000c1e00>] from [<0007a80c>]
>                                  ^^^^^^^^ arpt_hook
>Function entered at [<0007a7b0>] from [<0007ace4>]
>                                  ^^^^^^^^ nf_iterate
>Function entered at [<0007aba0>] from [<000a6a58>]
>                                  ^^^^^^^^ nf_hook_slow
>Function entered at [<000a6834>] from [<000a6414>]
>                                   ^^^^^^^^ arp_send
>Function entered at [<000a6330>] from [<00077314>]
>                                  ^^^^^^^^ arp_solicit
>Function entered at [<00077230>] from [<00077c54>]
>                                   ^^^^^^^^ __neigh_event_send
> r7 = 00F720A0  r6 = 00F73120  r5 = 001661C0  r4 = 00F73120
>Function entered at [<00077bc8>] from [<00087b48>]
>                                  ^^^^^^^^^ neigh_resolve_output
>Function entered at [<00087a78>] from [<0007ad30>]
>                                   ^^^^^^^^ ip_finish_output2
> r6 = 00000002  r5 = 00000004  r4 = 00000001
>Function entered at [<0007aba0>] from [<0008657c>]
>                                ^^^^^^^^^^ nf_hook_slow
>Function entered at [<00086514>] from [<00087a74>]
>                               ^^^^^^^^^^ ip_output
>Function entered at [<00087a5c>] from [<0007ad30>]
>                              ^^^^^^^^^^ output_maybe_reroute
>Function entered at [<0007aba0>] from [<00087214>]
>                               ^^^^^^^^^^ nf_iterate
>Function entered at [<00086eb4>] from [<000a7fd4>]
>                                 ^^^^^^^^^ ip_build_xmit
>Function entered at [<000a7e28>] from [<000a882c>]
>                                  ^^^^^^^^^ icmp_reply
>Function entered at [<000a87d0>] from [<000a8cb8>]
>                                   ^^^^^^^^ icmp_echo
>Function entered at [<000a8b44>] from [<00083920>]
>                                  ^^^^^^^^^ icmp_rcv
> r6 = 00000004  r5 = 00000000  r4 = 00166120
>Function entered at [<000837fc>] from [<0007ad30>]
>                                   ^^^^^^^^ ip_local_deliver_finish
> r8 = 000837FC  r7 = 00000000  r6 = 00000002  r5 = 00000001
> r4 = 00000001
>Function entered at [<0007aba0>] from [<0008353c>]
>                                  ^^^^^^^^^ nf_iterate
>Function entered at [<000834d8>] from [<00083c28>]
>                                  ^^^^^^^^^ ip_local_deliver
>Function entered at [<00083a00>] from [<0007ad30>]
>                                   ^^^^^^^^ ip_rcv_finish
> r6 = 00000002  r5 = 00000000  r4 = 00000001
>Function entered at [<0007aba0>] from [<00083794>]
>                                   ^^^^^^^ nf_iterate
>Function entered at [<00083548>] from [<000739dc>]
>                                  ^^^^^^^^^ ip_rcv
> r8 = 000FFD80  r7 = 00000008  r6 = 000DEEA0  r5 = 00166120
> r4 = 00000000
>Function entered at [<000737bc>] from [<00023a7c>]
>                                  ^^^^^^^^^ net_rx_action
>Function entered at [<000239fc>] from [<00017588>]
>                                   ^^^^^^^^ do_softirq
>Function entered at [<00017444>] from [<00016960>]
>                                  ^^^^^^^^^ do_IRQ
>Function entered at [<00032dd0>] from [<00033180>]
>                                  ^^^^^^^^^ filp_open
> r4 = 00000005
>Function entered at [<0003313c>] from [<00016c20>]
>                                   ^^^^^^^^ sys_open      ^^^^^^ 
>ret_fast_syscall
> r7 = 00E02000  r6 = FFFFFFFF  r5 = 00000241  r4 = 00FCFD60
>Code: e51b0054 e5952008 (e5903000) e5951000 e0033002
>Kernel panic: Aiee, killing interrupt handler
> 
>In interrupt handler - not syncing
>
>*Best Regards
>Jenny
>*
>
>
>  
>
