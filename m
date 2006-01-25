From: "KdF" <dkiba@yandex.ru>
Subject: Re: REDIRECT in kernel >= 2.6.15 broken???
Date: Wed, 25 Jan 2006 18:21:24 +0300 (MSK)
Message-ID: <43D79774.000008.00501@tide.yandex.ru>
References: <43D74B7D.000002.25194@pantene.yandex.ru>
	<43D74D68.5090808@trash.net>
	<43D75B4A.000005.27248@mfront8.yandex.ru>
	<43D7617C.20102@trash.net>
Reply-To: dkiba@yandex.ru
Mime-Version: 1.0
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43D7617C.20102@trash.net>
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

>KdF wrote:
>>>>Packets get forwarded as usual without any attempt to be redirected.

>My guess is that its related to invalid hardware checksums.
>Please check if you have hw checksumming enabled on the underlying
>eth device, if so load the ipt_LOG module and execute
>"echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid"

I've also tried to build kernel with network debug activated, and here is some output:

Jan 21 22:45:01 ac kernel: nf_hook: Verdict = QUEUE.
Jan 21 22:45:07 ac last message repeated 34 times
Jan 21 22:45:07 ac kernel: ppp21: hw csum failure.
Jan 21 22:45:07 ac kernel:  [<c03b16f1>] __skb_checksum_complete+0x73/0x79
Jan 21 22:45:07 ac kernel:  [<c0414b41>] icmp_error+0x12e/0x1b9
Jan 21 22:45:07 ac kernel:  [<c03cec66>] nfqnl_enqueue_packet+0x1c/0x191
Jan 21 22:45:07 ac kernel:  [<c03aea8a>] kfree_skbmem+0x5e/0x83
Jan 21 22:45:07 ac kernel:  [<c0414a13>] icmp_error+0x0/0x1b9
Jan 21 22:45:07 ac kernel:  [<c04121b9>] ip_conntrack_in+0x2d5/0x343
Jan 21 22:45:07 ac kernel:  [<c03da2f6>] ip_forward_finish+0x0/0x46
Jan 21 22:45:07 ac kernel:  [<c03ccda7>] nf_iterate+0x6f/0xaa
Jan 21 22:45:07 ac kernel:  [<c03d8c04>] ip_rcv_finish+0x0/0x2b8
Jan 21 22:45:07 ac kernel:  [<c03cce4d>] nf_hook_slow+0x6b/0x120
Jan 21 22:45:07 ac kernel:  [<c03d8c04>] ip_rcv_finish+0x0/0x2b8
Jan 21 22:45:07 ac kernel:  [<c03d8643>] ip_rcv+0x1a5/0x569
Jan 21 22:45:07 ac kernel:  [<c03d8c04>] ip_rcv_finish+0x0/0x2b8
Jan 21 22:45:07 ac kernel:  [<c03b4343>] netif_receive_skb+0x147/0x1c3
Jan 21 22:45:07 ac kernel:  [<c03b4441>] process_backlog+0x82/0x103
Jan 21 22:45:07 ac kernel:  [<c03b4539>] net_rx_action+0x77/0xfe
Jan 21 22:45:07 ac kernel:  [<c01266a7>] __do_softirq+0xbf/0xd5
Jan 21 22:45:07 ac kernel:  [<c01266ef>] do_softirq+0x32/0x34
Jan 21 22:45:07 ac kernel:  [<c010526a>] do_IRQ+0x1e/0x24
Jan 21 22:45:07 ac kernel:  [<c01036c6>] common_interrupt+0x1a/0x20
Jan 21 22:45:07 ac kernel:  [<c0100f76>] mwait_idle+0x2f/0x34
Jan 21 22:45:07 ac kernel:  [<c0100df6>] cpu_idle+0x72/0x7b
Jan 21 22:45:07 ac kernel:  [<c058882f>] start_kernel+0x15c/0x175
Jan 21 22:45:07 ac kernel:  [<c05882a2>] unknown_bootoption+0x0/0x1ac
Jan 21 22:45:07 ac kernel: nf_hook: Verdict = QUEUE.
Jan 21 22:45:12 ac last message repeated 36 times
Jan 21 22:45:12 ac kernel: ppp21: hw csum failure.
Jan 21 22:45:12 ac kernel:  [<c03b16f1>] __skb_checksum_complete+0x73/0x79
<output cut>

After i have activated 
"echo 255 >/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid "
there appeared some log records:

Jan 25 17:11:37 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.199.1 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16755 DF PROTO=TCP SPT=1150 DPT=80 SEQ=148450654 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:37 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.199.1 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16756 DF PROTO=TCP SPT=1153 DPT=80 SEQ=1636629096 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:37 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.199.1 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16757 DF PROTO=TCP SPT=1151 DPT=80 SEQ=1907181470 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:37 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.214.31 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16758 DF PROTO=TCP SPT=1154 DPT=80 SEQ=272143579 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:42 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=193.69.116.12 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16769 DF PROTO=TCP SPT=1145 DPT=80 SEQ=3101067246 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:43 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.199.1 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16770 DF PROTO=TCP SPT=1152 DPT=80 SEQ=2343788830 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:43 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.199.1 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16771 DF PROTO=TCP SPT=1153 DPT=80 SEQ=1636629096 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:43 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=195.0.210.195 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16772 DF PROTO=TCP SPT=1149 DPT=80 SEQ=3865813092 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 
Jan 25 17:11:48 ac kernel: printk: 3 messages suppressed.
Jan 25 17:11:48 ac kernel: ip_ct_tcp: invalid packet ignored IN= OUT= SRC=192.168.138.138 DST=213.180.204.11 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=16778 DF PROTO=TCP SPT=1155 DPT=80 SEQ=1884322362 ACK=0 WINDOW=65535 RES=0x00 SYN URGP=0 OPT (020405A001010402) 

Is this problem in pppd, pppoe or in underlying interface, and how can i track it? Maybe queue overflow problem that i have described in another post today also relates to this?
