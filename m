From: David P Olshefski <olshef@us.ibm.com>
Subject: crash in ebtables 2.0.8-2
Date: Tue, 19 Aug 2008 09:55:21 -0400
Message-ID: <OFFFED554A.21EFA010-ON852574AA.004C56D5-852574AA.004C7C94@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54451 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbYHSNzn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:55:43 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7JDtd2X005654
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:55:39 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7JDtQ7L185712
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:55:26 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7JDtPZd000431
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:55:25 -0400
Received: from d01ml604.pok.ibm.com (d01ml604.pok.ibm.com [9.56.227.90])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m7JDtP3o000426
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 09:55:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not sure if my first email made it thru....I am getting a crash in 
ebtables after instantiating about 140 rules:


Aug 18 19:50:59 cso190 kernel: Ebtables v2.0 registered 
Aug 18 19:52:31 cso190 kernel: Unable to handle kernel paging request at 
ffffc2000006600c RIP: 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff88288d2a>] 
:ebtables:translate_table+0x62a/0x1060 
Aug 18 19:52:31 cso190 kernel: PGD 1140067 PUD 103f067 PMD 103e067 PTE 0 
Aug 18 19:52:31 cso190 kernel: Oops: 0000 [1] SMP 
Aug 18 19:52:31 cso190 kernel: CPU 0 
Aug 18 19:52:31 cso190 kernel: Modules linked in: ebt_arpreply ebt_arp 
ebt_ip ebtable_nat ebtables ipt_MASQUERADE iptable_nat ip_nat xt_state 
ocfs2_dlmfs ip_conntrack ocfs2_dlm nfnetlink ocfs2_nodemanager ipt_REJECT 
xt_tcpudp configfs iptable_filter ip_tables x_tables ib_srp rdma_ucm 
ib_sdp rdma_cm iw_cm ib_addr bridge llc ipmi_devintf ipmi_si ib_uverbs 
ipmi_msghandler ib_umad ib_ipath mlx4_ib mlx4_core ib_ipoib ib_cm ib_sa 
button battery ac dm_mod ib_mthca ib_mad ib_core mptctl 8250_pnp 8250 
serial_core fan sg thermal processor mptsas mptscsih mptbase 
scsi_transport_sas sd_mod scsi_mod 
Aug 18 19:52:31 cso190 kernel: Pid: 8513, comm: ebtables Not tainted 
2.6.18.8-xen #6 
Aug 18 19:52:31 cso190 kernel: RIP: e030:[<ffffffff88288d2a>] 
[<ffffffff88288d2a>] :ebtables:translate_table+0x62a/0x1060 
Aug 18 19:52:31 cso190 kernel: RSP: e02b:ffff8800701c5d68  EFLAGS: 
00010286 
Aug 18 19:52:31 cso190 kernel: RAX: 0000000000000000 RBX: 0000000000000000 
RCX: 0000000000000000 
Aug 18 19:52:31 cso190 kernel: RDX: 0000000000002fa0 RSI: ffff8800701c5dfc 
RDI: 0000000000000019 
Aug 18 19:52:31 cso190 kernel: RBP: ffff8800701c5df8 R08: 0000000000000000 
R09: 0000000000000000 
Aug 18 19:52:31 cso190 kernel: R10: ffff8800701c5df8 R11: 0000000000000000 
R12: 0000000000000038 
Aug 18 19:52:31 cso190 kernel: R13: 0000000000000000 R14: ffffc20000065fa0 
R15: ffffc2000003d000 
Aug 18 19:52:31 cso190 kernel: FS:  00002b1cbd743080(0000) 
GS:ffffffff8061b000(0000) knlGS:0000000000000000 
Aug 18 19:52:31 cso190 kernel: CS:  e033 DS: 0000 ES: 0000 
Aug 18 19:52:31 cso190 kernel: Process ebtables (pid: 8513, threadinfo 
ffff8800701c4000, task ffff88007f0b0860) 
Aug 18 19:52:31 cso190 kernel: Stack:  0000000000000000 000000008072f440 
0000000000000000 00002fa000000002 
Aug 18 19:52:31 cso190 kernel:  0000000000000041 0000000000000001 
ffffc20000063000 ffffc20000065fa0 
Aug 18 19:52:31 cso190 kernel:  0000000000000034 00000000000000d2 
0000000000000000 0000000000000e00 
Aug 18 19:52:31 cso190 kernel: Call Trace: 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff88289bdc>] 
:ebtables:do_ebt_set_ctl+0x1ac/0x8b0 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff8021ba89>] 
do_page_fault+0xc89/0x1060 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff8048f5e9>] nf_sockopt+0xe9/0x130 

Aug 18 19:52:31 cso190 kernel:  [<ffffffff8048f656>] 
nf_setsockopt+0x16/0x20 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff8049bf84>] 
ip_setsockopt+0x74/0xa0 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff8046ae16>] 
sys_setsockopt+0xa6/0xf0 
Aug 18 19:52:31 cso190 kernel:  [<ffffffff8020a724>] system_call+0x68/0x6d 

Aug 18 19:52:31 cso190 kernel:  [<ffffffff8020a6bc>] system_call+0x0/0x6d 
Aug 18 19:52:31 cso190 kernel: 
Aug 18 19:52:31 cso190 kernel: 
Aug 18 19:52:31 cso190 kernel: Code: 41 8b 4e 6c 89 4c 24 2c 41 8b 5e 68 
89 5c 24 44 41 8b 06 85 
Aug 18 19:52:31 cso190 kernel: RIP  [<ffffffff88288d2a>] 
:ebtables:translate_table+0x62a/0x1060 
Aug 18 19:52:31 cso190 kernel:  RSP <ffff8800701c5d68> 
Aug 18 19:52:31 cso190 kernel: CR2: ffffc2000006600c 

David  O. 
olshef@us.ibm.com
