From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: BUG nf_conntrack_ffff880863c50000: Objects remaining on kmem_cache_close()
Date: Wed, 08 Feb 2012 15:45:21 +0100
Message-ID: <4F328A81.4050607@univ-nantes.fr>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080401060604080204060707"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls1.univ-nantes.fr ([193.52.101.145]:38335 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2BHOzK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:55:10 -0500
Received: from localhost (debian [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 3D94B94E1F
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2012 15:45:22 +0100 (CET)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtp-tls1.d101.univ-nantes.fr [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 2i3BQ1ZXn3GO for <netfilter-devel@vger.kernel.org>;
	Wed,  8 Feb 2012 15:45:22 +0100 (CET)
Received: from [172.20.13.5] (antares.cri.univ-nantes.prive [172.20.13.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 1E4B194E10
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2012 15:45:22 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080401060604080204060707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I'm seeing bug in a host with a 3.2.1 kernel.
This host is running both kvm and lxc guest.
It seems that it happened just after the restart of a lxc guest.

However, it doesn't seem to affect any guest.

I was just wondering if this was problematic, and if so, what should I 
do to debug this further.

Regards.

-- 
Jean-Philippe Menil - Pôle réseau Service IRTS
DSI Université de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09


--------------080401060604080204060707
Content-Type: text/plain;
 name="bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bug.txt"

Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285125] =============================================================================
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285173] BUG nf_conntrack_ffff880863c50000: Objects remaining on kmem_cache_close()
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285223] -----------------------------------------------------------------------------
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285224] 
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285291] INFO: Slab 0xffffea000fecf280 objects=26 used=1 fp=0xffff8803fb3ca4e0 flags=0x200000000004080
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285339] Pid: 5, comm: kworker/u:0 Not tainted 3.2.1-dsiun-120113 #55
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285366] Call Trace:
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285393]  [<ffffffff811194c0>] ? slab_err+0x80/0x90
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285419]  [<ffffffff8111c6c9>] ? kmem_cache_destroy+0x169/0x3b0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285449]  [<ffffffff8111c6ec>] ? kmem_cache_destroy+0x18c/0x3b0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285487]  [<ffffffffa049f753>] ? nf_conntrack_cleanup+0xd3/0x130 [nf_conntrack]
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285545]  [<ffffffff812f7b48>] ? ops_exit_list.isra.1+0x38/0x70
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285574]  [<ffffffff812f8260>] ? net_drop_ns+0x40/0x40
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285600]  [<ffffffff812f8360>] ? cleanup_net+0x100/0x1a0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285643]  [<ffffffff810635c6>] ? process_one_work+0x106/0x460
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285670]  [<ffffffff8106486c>] ? worker_thread+0x14c/0x330
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285697]  [<ffffffff81064720>] ? manage_workers.isra.30+0x210/0x210
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285736]  [<ffffffff8106905e>] ? kthread+0x7e/0x90
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285763]  [<ffffffff813aee34>] ? kernel_thread_helper+0x4/0x10
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285790]  [<ffffffff81068fe0>] ? kthread_worker_fn+0x190/0x190
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285817]  [<ffffffff813aee30>] ? gs_change+0x13/0x13
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285843] INFO: Object 0xffff8803fb3ca000 @offset=0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285869] SLUB nf_conntrack_ffff880863c50000: kmem_cache_destroy called for cache that still has objects.
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285916] Pid: 5, comm: kworker/u:0 Not tainted 3.2.1-dsiun-120113 #55
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285943] Call Trace:
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285964]  [<ffffffff8111c7a8>] ? kmem_cache_destroy+0x248/0x3b0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.285991]  [<ffffffff8111c863>] ? kmem_cache_destroy+0x303/0x3b0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286020]  [<ffffffffa049f753>] ? nf_conntrack_cleanup+0xd3/0x130 [nf_conntrack]
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286064]  [<ffffffff812f7b48>] ? ops_exit_list.isra.1+0x38/0x70
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286092]  [<ffffffff812f8260>] ? net_drop_ns+0x40/0x40
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286117]  [<ffffffff812f8360>] ? cleanup_net+0x100/0x1a0
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286144]  [<ffffffff810635c6>] ? process_one_work+0x106/0x460
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286227]  [<ffffffff8106486c>] ? worker_thread+0x14c/0x330
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286253]  [<ffffffff81064720>] ? manage_workers.isra.30+0x210/0x210
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286281]  [<ffffffff8106905e>] ? kthread+0x7e/0x90
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286306]  [<ffffffff813aee34>] ? kernel_thread_helper+0x4/0x10
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286333]  [<ffffffff81068fe0>] ? kthread_worker_fn+0x190/0x190
Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.286360]  [<ffffffff813aee30>] ? gs_change+0x13/0x13



--------------080401060604080204060707--
