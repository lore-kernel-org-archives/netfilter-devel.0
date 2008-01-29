From: "fenglg" <flg2932946@163.com>
Subject: kernel crash
Date: Tue, 29 Jan 2008 18:32:36 +0800
Message-ID: <479F0419.0057A9.30859@m12-15.163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m5-85.163.com ([202.108.5.85]:60490 "HELO m12-15.163.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753619AbYA2Kqy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:46:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter-devel

I use linux-2.6.18, and there is a bridge with eth0 and eth1. The eth0 and eth1 connetcswitchs which use vlan trunk(802.1q). When i run system some hours, the kernel is crash, anyone can help me. 
 
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010 
 printing eip:              
c030f15d        
*pde = 00000000               
Oops: 0000 [#1]               
PREEMPT SMP           
Modules linked in: ipt_recent_mac ip_nat_ftp ip_conntrack_ftp ip_nat_h323 ip_con                                                                                
ntrack_h323 ip_nat_irc iptable_nat ip_nat ipt_ipp2p ipsec e1000 e100                                                                    
CPU:    0         
EIP:    008 #1)               
EIP is at br_nf_pre_routing_finish+0x1d/0x340                                             
eax: c16e7980   ebx: 00000000   ecx: 00000001   edx: c16e7980                                                             
esi: de4cb020   edi: c0456520   ebp: de8d2000   esp: c03fbce4                                                             
ds: 007b   es: 007b   ss: 0068                              
Process swapper (pid: 0, ti=c03fa000 task=c0371180 task.ti=c03fa000)                                                                    
Stack: 00000002 c02f0f53 db39ae30 db39ae30 00000002 e081854b db39ae30 00000002                                                                              
       00000000 c03fbdd4 df8f3c00 c0459560 de8d2000 00000001 c03fbda0 fff644c4                                                                              
       c03fbdd4 c030f140 e0818703 00000000 c03fbdd4 de8d2000 00000000 c030f140                                                                              
Call Trace:           
 [<c02f0f53>] icmp_packet+0xc3/0xd0                                   
 [<e081854b>] ip_nat_fn+0x7b/0x1f0 [iptable_nat]                                                
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<e0818703>] ip_nat_in+0x43/0xc0 [iptable_nat]                                               
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<c02a3f78>] nf_iterate+0x78/0x90                                  
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<c02a400e>] nf_hook_slow+0x7e/0x120                                     
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<c030a840>] br_handle_frame_finish+0x0/0x130                                              
 [<c030f9e2>] br_nf_pre_routing+0x212/0x400                                           
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340                                                
 [<c02a3f78>] nf_iterate+0x78/0x90                                  
 [<c030a840>] br_handle_frame_finish+0x0/0x130                                              
 [<c030a840>] br_handle_frame_finish+0x0/0x130                                  
 [<c02a400e>] nf_hook_slow+0x7e/0x120
 [<c030a840>] br_handle_frame_finish+0x0/0x130
 [<c030ab80>] br_handle_frame+0x1d0/0x210
 [<c030a840>] br_handle_frame_finish+0x0/0x130
 [<c02854b1>] netif_receive_skb+0x171/0x2e0
 [<c027eb0e>] kfree_skbmem+0x5e/0x90
 [<e0844358>] e1000_clean_rx_irq+0x1b8/0x530 [e1000]
 [<e0843dac>] e1000_clean+0x6c/0x120 [e1000]
 [<c02857c5>] net_rx_action+0x85/0x110
 [<c01202ea>] __do_softirq+0xca/0xf0
 [<c0120345>] do_softirq+0x35/0x40
 [<c0120395>] irq_exit+0x45/0x50
 [<c0105936>] do_IRQ+0x36/0x70
 [<c0103a76>] common_interrupt+0x1a/0x20
 [<c0100db1>] default_idle+0x31/0x60
 [<c0100e82>] cpu_idle+0x82/0xa0
 [<c03ff9c8>] start_kernel+0x1a8/0x200
 [<c03ff330>] unknown_bootoption+0x0/0x1e0
Code: 10 01 e9 7a ff ff ff 8d b4 26 00 00 00 00 55 57 56 53 81 ec c0 00 00 00 8b
 94 24 d4 00 00 00 8b 9a 80 00 00 00 8b 6a 14 8b 72 20 <8b> 43 10 a8 01 74 14 0f
 b6 42 75 24 f8 0c 03 88 42 75 8b 43 10
EIP: [<c030f15d>] br_nf_pre_routing_finish+0x1d/0x340 SS:ESP 0068:c03fbce4
 <0>Kernel panic - not syncing: Fatal exception in interrupt


