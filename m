From: Thomas Woerner <twoerner@redhat.com>
Subject: kernel crash in nf_nat_move_storage
Date: Wed, 30 Jan 2008 12:42:55 +0100
Message-ID: <47A062BF.1010008@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090608040700080108050408"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYA3Lm7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:42:59 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0UBgv0c026886
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 06:42:57 -0500
Received: from pobox.stuttgart.redhat.com (pobox.stuttgart.redhat.com [172.16.2.10])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0UBguiY023582
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 06:42:56 -0500
Received: from pizzo.stuttgart.redhat.com (pizzo.stuttgart.redhat.com [10.32.5.30])
	by pobox.stuttgart.redhat.com (8.13.1/8.13.1) with ESMTP id m0UBgtW9008509
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 06:42:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090608040700080108050408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Using port forwarding from port 80 to 21 with nf_conntrack_ftp loaded 
results in a kernel crash, when connecting to port 80 from a remote
host. This seems to be a problem for kernels > 2.6.18 including 2.6.24.

Steps to Reproduce:

host1> iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT 
--to :21
host1> iptables -t filter -A INPUT -i eth0 -m state --state NEW -m tcp 
-p tcp --dport 21 -j ACCEPT
host1> modprobe ip_conntrack_ftp
host2> telnet host1 80

Attached is the kernel crash log for kernel 2.6.23.9-85.fc8PAE. I was 
told that this kernel crash dump is incomplete, but it took several 
attempts to get a log with more that 5 lines over serial console. The 
kernel seems to die too fast.

Thanks,
Thomas

-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/

--------------090608040700080108050408
Content-Type: text/plain;
 name="kernel-oups"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-oups"

sh-3.2# BUG: unable to handle kernel NULL pointer dereference at virtual addres4
printing eip: f8fcb087 *pdpt = 0000000037c82001 <1>*pde = 000000013f75d067 
Oops: 0000 [#1] SMP 
Modules linked in: nf_conntrack_ftp ipt_REJECT xt_state iptable_filter xt_tcpudd
CPU:    1
EIP:    0060:[<f8fcb087>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23.9-85.fc8PAE #1)
EIP is at nf_nat_move_storage+0x23/0x69 [nf_nat]
eax: 00000004   ebx: f7e13d04   ecx: f7e13d00   edx: f7e13d00
esi: f7e13d10   edi: 00000000   ebp: f751b000   esp: c078bc84
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c078b000 task=f7c02c20 task.ti=c38f1000)
Stack: f7885ea0 f8fcb064 00000001 f920c5dc 00000000 0000004c 00000028 00000000 
       00000000 f921d2c0 f751b000 f76418c0 f920a7a5 f9208d73 c078bce8 f8fce1e0 
       00000000 f8fcb9dd f751b000 00000000 f751b000 00000000 00000001 00000000 
Call Trace:
 [<f8fcb064>] nf_nat_move_storage+0x0/0x69 [nf_nat]
 [<f920c5dc>] __nf_ct_ext_add+0x128/0x1bc [nf_conntrack]
 [<f920a7a5>] nf_ct_helper_ext_add+0x9/0x15 [nf_conntrack]
 [<f9208d73>] nf_conntrack_alter_reply+0x73/0x96 [nf_conntrack]
 [<f8fcb9dd>] nf_nat_setup_info+0x3f3/0x54e [nf_nat]
 [<f92000ea>] ipt_dnat_target+0x0/0x14c [iptable_nat]
 [<f920022e>] ipt_dnat_target+0x144/0x14c [iptable_nat]
 [<f920c09d>] tcp_packet+0x9bc/0x9eb [nf_conntrack]
 [<c046760b>] __alloc_pages+0x64/0x2a2
 [<f92000ea>] ipt_dnat_target+0x0/0x14c [iptable_nat]
 [<f8fd759e>] ipt_do_table+0x3f0/0x482 [ip_tables]
 [<f9208ca8>] nf_conntrack_alloc+0x16d/0x1c5 [nf_conntrack]
 [<f920b3d6>] tcp_new+0xd1/0x1a4 [nf_conntrack]
 [<f920c4f8>] __nf_ct_ext_add+0x44/0x1bc [nf_conntrack]
 [<f9200257>] nf_nat_rule_find+0x21/0x5c [iptable_nat]
 [<f920040d>] nf_nat_fn+0x165/0x189 [iptable_nat]
 [<f920048e>] nf_nat_in+0x29/0x9c [iptable_nat]
 [<c05dab54>] ip_rcv_finish+0x0/0x291
 [<c05d5b9c>] nf_iterate+0x38/0x6a
 [<c05dab54>] ip_rcv_finish+0x0/0x291
 [<c05d5d07>] nf_hook_slow+0x4d/0xb5
 [<c05dab54>] ip_rcv_finish+0x0/0x291
 [<c05db261>] ip_rcv+0x20b/0x4ba
 [<c05dab54>] ip_rcv_finish+0x0/0x291
 [<c05be718>] netif_receive_skb+0x2e1/0x346
 [<f8e00e7d>] nv_napi_poll+0x48c/0x61e [forcedeth]
 [<c05c085c>] net_rx_action+0x9a/0x196
 [<c0432d62>] __do_softirq+0x66/0xd3
 [<c04073d5>] do_softirq+0x6c/0xce
 [<c04455e5>] tick_do_update_jiffies64+0x15/0xa8
 [<c04410ff>] ktime_get+0xf/0x2b
 [<c045c9f1>] handle_fasteoi_irq+0x0/0xa6
 [<c0432c25>] irq_exit+0x38/0x6b
 [<c04074d6>] do_IRQ+0x9f/0xb9
 [<c0403ddf>] default_idle+0x0/0x55
 [<c0405b6f>] common_interrupt+0x23/0x28
 [<c0403ddf>] default_idle+0x0/0x55
 [<c0422297>] native_safe_halt+0x2/0x3
 [<c0403e18>] default_idle+0x39/0x55
 [<c040340b>] cpu_idle+0xab/0xcc
 =======================
Code: 64 0f fe ff ff 31 c0 c3 57 56 89 d6 53 8b 90 ec 00 00 00 85 d2 74 0f 8a 4 
EIP: [<f8fcb087>] nf_nat_move_storage+0x23/0x69 [nf_nat] SS:ESP 0068:c078bc84
Kernel panic - not syncing: Fatal exception in interrupt

--------------090608040700080108050408--
