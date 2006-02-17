From: speedy@carboncode.com
Subject: Badness in local_bh_enable at kernel/softirq.c:140
Date: Thu, 16 Feb 2006 22:34:56 -0700
Message-ID: <4C2831BB-5FE5-4D78-AF64-D4CCF83B13DA@carboncode.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

I am running on Linux Kernel 2.6.12.4 and ip_conntrack version 2.1

I have a Sangoma S518 DSL PCI card, and a quad tulip ethernet NIC in  
an SMP environment.

I have IP forwarding, enabled and everything seems to work fine,  
except when I receive from the outside Internet connection, to an IP  
behind the tulip interface I get the error bellow.

I'm wondering if anyone has some suggestions as to where the problem  
is, and what I might try to change.

Thank you,

Donnie

Feb 16 22:37:31 localhost kernel: Badness in local_bh_enable at  
kernel/softirq.c:140
Feb 16 22:37:31 localhost kernel:  [local_bh_enable+128/144]  
local_bh_enable+0x80/0x90
Feb 16 22:37:31 localhost kernel:  [pg0+950698485/1069659136]  
destroy_conntrack+0xe5/0x100 [ip_conntrack]
Feb 16 22:37:31 localhost kernel:  [__delay+18/32] __delay+0x12/0x20
Feb 16 22:37:31 localhost kernel:  [__kfree_skb+182/320] __kfree_skb 
+0xb6/0x140
Feb 16 22:37:31 localhost kernel:  [pg0+949924588/1069659136]  
adsl_output+0x20c/0x320 [wanpipe]
Feb 16 22:37:31 localhost kernel:  [qdisc_restart+350/512]  
qdisc_restart+0x15e/0x200
Feb 16 22:37:31 localhost kernel:  [dev_queue_xmit+511/672]  
dev_queue_xmit+0x1ff/0x2a0
Feb 16 22:37:31 localhost kernel:  [neigh_connected_output+144/224]  
neigh_connected_output+0x90/0xe0
Feb 16 22:37:31 localhost kernel:  [ip_finish_output+255/560]  
ip_finish_output+0xff/0x230
Feb 16 22:37:31 localhost kernel:  [ip_finish_output2+0/464]  
ip_finish_output2+0x0/0x1d0
Feb 16 22:37:31 localhost kernel:  [ip_forward+391/768] ip_forward 
+0x187/0x300
Feb 16 22:37:31 localhost kernel:  [ip_forward_finish+0/96]  
ip_forward_finish+0x0/0x60
Feb 16 22:37:31 localhost kernel:  [ip_rcv+940/1376] ip_rcv+0x3ac/0x560
Feb 16 22:37:31 localhost kernel:  [ip_rcv_finish+0/672] ip_rcv_finish 
+0x0/0x2a0
Feb 16 22:37:31 localhost kernel:  [pg0+945315490/1069659136]  
tulip_interrupt+0x302/0x9e0 [tulip]
Feb 16 22:37:31 localhost kernel:  [netif_receive_skb+518/656]  
netif_receive_skb+0x206/0x290
Feb 16 22:37:31 localhost kernel:  [process_backlog+153/304]  
process_backlog+0x99/0x130
Feb 16 22:37:31 localhost kernel:  [net_rx_action+147/400]  
net_rx_action+0x93/0x190
Feb 16 22:37:31 localhost kernel:  [__do_softirq+214/240] __do_softirq 
+0xd6/0xf0
Feb 16 22:37:31 localhost kernel:  [do_softirq+53/64] do_softirq 
+0x35/0x40
Feb 16 22:37:31 localhost kernel:  [do_IRQ+30/48] do_IRQ+0x1e/0x30
Feb 16 22:37:31 localhost kernel:  [common_interrupt+26/32]  
common_interrupt+0x1a/0x20
Feb 16 22:37:31 localhost kernel:  [default_idle+0/48] default_idle 
+0x0/0x30
Feb 16 22:37:31 localhost kernel:  [default_idle+35/48] default_idle 
+0x23/0x30
Feb 16 22:37:31 localhost kernel:  [cpu_idle+112/128] cpu_idle+0x70/0x80
Feb 16 22:37:31 localhost kernel:  [start_kernel+407/480] start_kernel 
+0x197/0x1e0
Feb 16 22:37:31 localhost kernel:  [unknown_bootoption+0/480]  
unknown_bootoption+0x0/0x1e0
