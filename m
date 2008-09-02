From: David P Olshefski <olshef@us.ibm.com>
Subject: Re: crash in ebtables 2.0.8-2
Date: Tue, 2 Sep 2008 12:35:46 -0400
Message-ID: <OF3C594B6C.8BB42C38-ON852574B8.005B1042-852574B8.005B2AB3@us.ibm.com>
References: <OFFFED554A.21EFA010-ON852574AA.004C56D5-852574AA.004C7C94@us.ibm.com> <48BBE8DD.6000909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57265 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYIBQhG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:37:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82Gb3ng005864
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 12:37:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82GZleh226676
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 12:35:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82GZl0f003846
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Sep 2008 12:35:47 -0400
In-Reply-To: <48BBE8DD.6000909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yep, I found the bug, and discovered it was fixed in a newer release.

Sorry to waste your time.

Dave O.



Patrick McHardy <kaber@trash.net> 
09/01/2008 09:06 AM

To
David P Olshefski/Watson/IBM@IBMUS
cc
netfilter-devel@vger.kernel.org
Subject
Re: crash in ebtables 2.0.8-2






David P Olshefski wrote:
> Not sure if my first email made it thru....I am getting a crash in 
> ebtables after instantiating about 140 rules:
> 
> 
> Aug 18 19:50:59 cso190 kernel: Ebtables v2.0 registered 
> Aug 18 19:52:31 cso190 kernel: Unable to handle kernel paging request at 

> ffffc2000006600c RIP: 
> Aug 18 19:52:31 cso190 kernel:  [<ffffffff88288d2a>] 
> :ebtables:translate_table+0x62a/0x1060 
> Aug 18 19:52:31 cso190 kernel: PGD 1140067 PUD 103f067 PMD 103e067 PTE 0 

> Aug 18 19:52:31 cso190 kernel: Oops: 0000 [1] SMP 
> Aug 18 19:52:31 cso190 kernel: CPU 0 
> Aug 18 19:52:31 cso190 kernel: Modules linked in: ebt_arpreply ebt_arp 
> ebt_ip ebtable_nat ebtables ipt_MASQUERADE iptable_nat ip_nat xt_state 
> ocfs2_dlmfs ip_conntrack ocfs2_dlm nfnetlink ocfs2_nodemanager 
ipt_REJECT 
> xt_tcpudp configfs iptable_filter ip_tables x_tables ib_srp rdma_ucm 
> ib_sdp rdma_cm iw_cm ib_addr bridge llc ipmi_devintf ipmi_si ib_uverbs 
> ipmi_msghandler ib_umad ib_ipath mlx4_ib mlx4_core ib_ipoib ib_cm ib_sa 
> button battery ac dm_mod ib_mthca ib_mad ib_core mptctl 8250_pnp 8250 
> serial_core fan sg thermal processor mptsas mptscsih mptbase 
> scsi_transport_sas sd_mod scsi_mod 
> Aug 18 19:52:31 cso190 kernel: Pid: 8513, comm: ebtables Not tainted 
> 2.6.18.8-xen #6 
> Aug 18 19:52:31 cso190 kernel: RIP: e030:[<ffffffff88288d2a>] 
> [<ffffffff88288d2a>] :ebtables:translate_table+0x62a/0x1060 


This appears to be an ancient kernel. Could you retry with 2.6.26
please?


