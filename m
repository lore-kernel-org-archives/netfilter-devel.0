From: "Nishit Shah" <nishit@elitecore.com>
Subject: kernel oops with NAT in 2.6.16.13 kernel
Date: Fri, 6 Oct 2006 13:27:13 +0530
Message-ID: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

Hi,
        During my load testing on kernel 2.6.16.13 i got following kernel
oops. It occures when I enable SNAT or MASQUERADE for all outgoing traffic,
with ACCEPT load testing works fine for me.

Regards,
Nishit Shah.

Oct 06 11:33:28 1160114608 kernel: BUG: soft lockup detected on CPU#0!
Oct 06 11:33:28 1160114608 kernel:
Oct 06 11:33:28 1160114608 kernel: Pid: 1754, comm:           in.telnetd
Oct 06 11:33:28 1160114608 kernel: EIP: 0060:[pg0+944264370/1068717056] CPU:
0
Oct 06 11:33:28 1160114608 kernel: EIP is at __ip_conntrack_find+0x22/0xb0
[ip_conntrack]
Oct 06 11:33:28 1160114608 kernel:  EFLAGS: 00000292    Not tainted
(2.6.16.13-1 #4)
Oct 06 11:33:28 1160114608 kernel: EAX: 00016ac5 EBX: f5e01218 ECX: f5c00000
EDX: f5cb5628
Oct 06 11:33:28 1160114608 kernel: ESI: 000046b9 EDI: f7bf1754 EBP: f5fb6400
DS: 007b ES: 007b
Oct 06 11:33:28 1160114608 kernel: CR0: 8005003b CR2: b7ee7dc4 CR3: 37a05000
CR4: 000006d0
Oct 06 11:33:28 1160114608 kernel:  [pg0+944265669/1068717056]
ip_conntrack_tuple_taken+0x25/0x40 [ip_conntrack]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944312635/1068717056]
ip_nat_used_tuple+0x2b/0x40 [ip_nat]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944318447/1068717056]
tcp_unique_tuple+0xaf/0x120 [ip_nat]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944313566/1068717056]
get_unique_tuple+0xae/0x100 [ip_nat]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944313779/1068717056]
ip_nat_setup_info+0x83/0x210 [ip_nat]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944353635/1068717056]
masquerade_target+0x103/0x110 [ipt_MASQUERADE]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944353376/1068717056]
masquerade_target+0x0/0x110 [ipt_MASQUERADE]
Oct 06 11:33:28 1160114608 kernel:  [pg0+943993598/1068717056]
ipt_do_table+0x2ce/0x360 [ip_tables]
Oct 06 11:33:28 1160114608 kernel:  [pg0+944333715/1068717056]
ip_nat_rule_find+0x43/0xc0 [iptable_nat]
Oct 06 11:33:28 1160114608 kernel:  [_write_unlock_bh+11/32]
_write_unlock_bh+0xb/0x20
Oct 06 11:33:28 1160114608 kernel:  [pg0+944334424/1068717056]
ip_nat_fn+0xe8/0x200 [iptable_nat]
Oct 06 11:33:28 1160114608 kernel:  [_read_unlock_bh+11/32]
_read_unlock_bh+0xb/0x20
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [pg0+944335016/1068717056]
ip_nat_out+0x78/0x110 [iptable_nat]
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [nf_iterate+120/144]
nf_iterate+0x78/0x90
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [nf_hook_slow+110/272]
nf_hook_slow+0x6e/0x110
Oct 06 11:33:28 1160114608 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:28 1160114608 kernel:  [ip_output+700/720]
ip_output+0x2bc/0x2d0
Oct 06 11:33:29 1160114609 kernel:  [ip_finish_output+0/528]
ip_finish_output+0x0/0x210
Oct 06 11:33:29 1160114609 kernel:  [ip_forward+420/720]
ip_forward+0x1a4/0x2d0
Oct 06 11:33:29 1160114609 kernel:  [ip_forward_finish+0/64]
ip_forward_finish+0x0/0x40
Oct 06 11:33:29 1160114609 kernel:  [ip_rcv+624/1264] ip_rcv+0x270/0x4f0
Oct 06 11:33:29 1160114609 kernel:  [ip_rcv_finish+0/624]
ip_rcv_finish+0x0/0x270
Oct 06 11:33:29 1160114609 kernel:  [netif_receive_skb+492/624]
netif_receive_skb+0x1ec/0x270
Oct 06 11:33:29 1160114609 kernel:  [pg0+944029678/1068717056]
e1000_clean_rx_irq+0x1ce/0x5f0 [e1000]
Oct 06 11:33:29 1160114609 kernel:  [ktime_get_ts+97/112]
ktime_get_ts+0x61/0x70
Oct 06 11:33:29 1160114609 kernel:  [pg0+944028203/1068717056]
e1000_clean+0xbb/0x1c0 [e1000]
Oct 06 11:33:29 1160114609 kernel:  [net_rx_action+116/256]
net_rx_action+0x74/0x100
Oct 06 11:33:29 1160114609 kernel:  [__do_softirq+123/144]
__do_softirq+0x7b/0x90
Oct 06 11:33:29 1160114609 kernel:  [do_softirq+38/48] do_softirq+0x26/0x30
Oct 06 11:33:29 1160114609 kernel:  [local_bh_enable+70/128]
local_bh_enable+0x46/0x80
Oct 06 11:33:29 1160114609 kernel:  [_write_unlock_bh+11/32]
_write_unlock_bh+0xb/0x20
Oct 06 11:33:29 1160114609 kernel:  [pg0+944276160/1068717056]
tcp_packet+0x180/0x5d0 [ip_conntrack]
Oct 06 11:33:29 1160114609 kernel:  [local_bh_enable+70/128]
local_bh_enable+0x46/0x80
Oct 06 11:33:29 1160114609 kernel:  [_read_unlock_bh+11/32]
_read_unlock_bh+0xb/0x20
Oct 06 11:33:29 1160114609 kernel:  [pg0+944267281/1068717056]
ip_conntrack_in+0xe1/0x2d0 [ip_conntrack]
Oct 06 11:33:29 1160114609 kernel:  [dst_output+0/32] dst_output+0x0/0x20
Oct 06 11:33:29 1160114609 kernel:  [nf_iterate+120/144]
nf_iterate+0x78/0x90
Oct 06 11:33:29 1160114609 kernel:  [dst_output+0/32] dst_output+0x0/0x20
Oct 06 11:33:29 1160114609 kernel:  [dst_output+0/32] dst_output+0x0/0x20
Oct 06 11:33:29 1160114609 kernel:  [nf_hook_slow+110/272]
nf_hook_slow+0x6e/0x110
Oct 06 11:33:29 1160114609 kernel:  [dst_output+0/32] dst_output+0x0/0x20
Oct 06 11:33:29 1160114609 kernel:  [ip_queue_xmit+1022/1360]
ip_queue_xmit+0x3fe/0x550
Oct 06 11:33:29 1160114609 kernel:  [dst_output+0/32] dst_output+0x0/0x20
Oct 06 11:33:29 1160114609 kernel:  [ip_rcv+624/1264] ip_rcv+0x270/0x4f0
Oct 06 11:33:29 1160114609 kernel:  [ip_rcv_finish+0/624]
ip_rcv_finish+0x0/0x270
Oct 06 11:33:29 1160114609 kernel:  [netif_receive_skb+492/624]
netif_receive_skb+0x1ec/0x270
Oct 06 11:33:29 1160114609 kernel:  [pg0+944029868/1068717056]
e1000_clean_rx_irq+0x28c/0x5f0 [e1000]
Oct 06 11:33:29 1160114609 kernel:  [ktime_get_ts+97/112]
ktime_get_ts+0x61/0x70
Oct 06 11:33:29 1160114609 kernel:  [tcp_cwnd_restart+41/240]
tcp_cwnd_restart+0x29/0xf0
Oct 06 11:33:29 1160114609 kernel:  [tcp_event_data_sent+117/128]
tcp_event_data_sent+0x75/0x80
Oct 06 11:33:29 1160114609 kernel:  [tcp_transmit_skb+799/1184]
tcp_transmit_skb+0x31f/0x4a0
Oct 06 11:33:29 1160114609 kernel:  [pg0+944028203/1068717056]
e1000_clean+0xbb/0x1c0 [e1000]
Oct 06 11:33:29 1160114609 kernel:  [tcp_write_xmit+374/656]
tcp_write_xmit+0x176/0x290
Oct 06 11:33:29 1160114609 kernel:  [__tcp_push_pending_frames+53/176]
__tcp_push_pending_frames+0x35/0xb0
Oct 06 11:33:29 1160114609 kernel:  [tcp_sendmsg+873/3120]
tcp_sendmsg+0x369/0xc30
Oct 06 11:33:29 1160114609 kernel:  [buffered_rmqueue+246/544]
buffered_rmqueue+0xf6/0x220
Oct 06 11:33:29 1160114609 kernel:  [inet_sendmsg+74/96]
inet_sendmsg+0x4a/0x60
Oct 06 11:33:29 1160114609 kernel:  [do_sock_write+161/192]
do_sock_write+0xa1/0xc0
Oct 06 11:33:29 1160114609 kernel:  [sock_aio_write+148/160]
sock_aio_write+0x94/0xa0
Oct 06 11:33:29 1160114609 kernel:  [do_sync_write+209/288]
do_sync_write+0xd1/0x120
Oct 06 11:33:29 1160114609 kernel:  [autoremove_wake_function+0/96]
autoremove_wake_function+0x0/0x60
Oct 06 11:33:29 1160114609 kernel:  [vfs_write+364/384]
vfs_write+0x16c/0x180
Oct 06 11:33:29 1160114609 kernel:  [sys_write+81/128] sys_write+0x51/0x80
Oct 06 11:33:29 1160114609 kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
