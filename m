From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 13:16:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F97B874.CB12C184@fy.chalmers.se>
References: <3F964F9D.D5C69498@fy.chalmers.se> <20031023090238.GE1418@sunbeam.de.gnumonks.org> <3F97A4C5.982725B0@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F63790D90465FC909A2F83D5"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, coreteam@netfilter.org,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------F63790D90465FC909A2F83D5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> > > Question. Should I pursue the issue further?
> >
> > yes, please.  Especially a means of reproduction without running
> > proprietary software (and thus being repruducable for me) would be very
> > helpful.
> 
> Would eth0:1 be sufficient?

It's perfectly reproducible with eth0:1. In other words I

- take up eth0:1 with private ip address, e.g. 192.168.60.1 on computer
running 2.6 with 'ipchains -A forward -s 192.168.0.0/255.255.0.0 -d
0.0.0.0/0.0.0.0 -j MASQ';
- on another computer take up eth0:1 with e.g. 192.168.60.2 and 'route
add host some.host 192.168.60.1';
- on that other computer run attached script as './conn.pl some.host 80
2345';
- wait till port translation expires at first computer;
- run attached script as './conn.pl some.host 80 2345' once again;
- collect attached console.dump;

A.
--------------F63790D90465FC909A2F83D5
Content-Type: application/x-perl;
 name="conn.pl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conn.pl"

#!/usr/bin/env perl

use Socket;

$remote = shift || 'localhost';
$rport  = shift || 2345;  # some port...
$lport  = shift || 0;

$ifaddr=INADDR_ANY;	#inet_aton('192.168.155.1');

socket (SOCK, PF_INET, SOCK_STREAM, 0)		|| die "socket: $!";
setsockopt (SOCK,SOL_SOCKET,SO_LINGER,pack("II",1,0));
setsockopt (SOCK,SOL_SOCKET,SO_REUSEADDR,pack("I",1));

bind (SOCK, sockaddr_in($lport, $ifaddr))	|| die "bind: $!";
printf "lport %d\n",unpack_sockaddr_in (getsockname(SOCK));

$iaddr   = inet_aton($remote)			|| die "no host: $remote";
connect(SOCK, sockaddr_in($rport, $iaddr))	|| die "connect: $!";

--------------F63790D90465FC909A2F83D5
Content-Type: text/plain; charset=us-ascii;
 name="console.dump"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="console.dump"

Unable to handle kernel paging request at virtual address 00100108
 printing eip:
e08787e1
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<e08787e1>]    Tainted: PF 
EFLAGS: 00013203
EIP is at find_appropriate_src+0x3d/0xa0 [ipchains]
eax: e084dcf0   ebx: 00100100   ecx: dd3cdd44   edx: 0000059e
esi: 00000000   edi: dd3cdcd8   ebp: dd3cdc50   esp: dd3cdc40
ds: 007b   es: 007b   ss: 0068
Process X (pid: 1257, threadinfo=dd3cc000 task=dd3b5940)
Stack: dd3cdce8 dd3cdd08 dd3cdcd8 0000059e dd3cdc90 e0878a83 dd3cdcd8 dd3cdd44 
       dd3cdce8 c80e4ea4 dd3cdd08 e08817e0 dd3cdcd8 c80e4e2c c80e4e2c dd3cdc9c 
       e0876099 dd3cdcd8 c80e4e2c e0881580 dd3cdd18 e0878c2d dd3cdd08 dd3cdcd8 
Call Trace:
 [<e0878a83>] get_unique_tuple+0x33/0x190 [ipchains]
 [<e0876099>] invert_tuplepr+0x1d/0x28 [ipchains]
 [<e0878c2d>] ip_nat_setup_info+0x4d/0x2a0 [ipchains]
 [<e0875ff3>] ip_conntrack_in+0x18f/0x218 [ipchains]
 [<c02300c3>] __ip_route_output_key+0x23/0xe4
 [<e08780b8>] gcc2_compiled.+0x168/0x1f0 [ipchains]
 [<e0877735>] fw_in+0x1f9/0x228 [ipchains]
 [<c0229f70>] nf_iterate+0x44/0xa4
 [<c0232c44>] ip_forward_finish+0x0/0x4c
 [<c022a30a>] nf_hook_slow+0x8e/0x124
 [<c0232c44>] ip_forward_finish+0x0/0x4c
 [<c0232bfc>] ip_forward+0x1ec/0x234
 [<c0232c44>] ip_forward_finish+0x0/0x4c
 [<c0231c89>] ip_rcv_finish+0x1bd/0x204
 [<c022a348>] nf_hook_slow+0xcc/0x124
 [<c02318da>] ip_rcv+0x3ae/0x3f0
 [<c0231acc>] ip_rcv_finish+0x0/0x204
 [<c0220fe0>] netif_receive_skb+0x13c/0x18c
 [<c022109f>] process_backlog+0x6f/0x100
 [<c02211a2>] net_rx_action+0x72/0x11c
 [<c01202be>] do_softirq+0x4e/0xa0
 [<c010d251>] do_IRQ+0x115/0x130
 [<c010ba08>] common_interrupt+0x18/0x20

Code: 8b 53 08 0f b7 47 0e 31 f6 66 39 42 1e 75 2e 8b 07 39 42 10 
 <0>Kernel panic: Fatal exception in interrupt
In interrupt handler - not syncing

--------------F63790D90465FC909A2F83D5--
