From: Joe Stringer <joe@ovn.org>
Subject: Kernel crash on helper module unload
Date: Wed, 4 May 2016 15:46:20 -0700
Message-ID: <CAPWQB7H6jt-TnsFH+dxNRAosPYYZmoKCc+C+b=pR+p4CxmtzvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jarno Rajahalme <jarno@ovn.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44223 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbcEDWqp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 May 2016 18:46:45 -0400
Received: from mfilter30-d.gandi.net (mfilter30-d.gandi.net [217.70.178.161])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 7469C1720A1
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 00:46:43 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([IPv6:::ffff:217.70.183.196])
	by mfilter30-d.gandi.net (mfilter30-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id SiGbbKUIuvuK for <netfilter-devel@vger.kernel.org>;
	Thu,  5 May 2016 00:46:41 +0200 (CEST)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com [209.85.218.48])
	(Authenticated sender: joe@ovn.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6E39D17209D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 00:46:41 +0200 (CEST)
Received: by mail-oi0-f48.google.com with SMTP id v145so83453952oie.0
        for <netfilter-devel@vger.kernel.org>; Wed, 04 May 2016 15:46:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I've noticed that you can crash the kernel by running FTP traffic
through to a netns, then removing the FTP helper module from the host.
Repro involves setting automatic helpers (default up until nf-next),
running an FTP client in one netns through to a server in another
netns with linux bridge providing L2 connectivity in between. If you
remove the namespaces after running traffic, then the netns cleanup +
hook unregistration is deferred to a workqueue. If you can unload the
FTP helper module before this code triggers, then the work item will
attempt to destroy helpers that were provided by the (now unloaded)
module. This piece fails, causing the BUG.

I've boiled it down to a repro script here:
https://gist.github.com/joestringer/465328172ee8960242142572b0ffc6e1

The FTP server used within is a simple python application here,
requires pyftpdlib:
https://github.com/openvswitch/ovs/blob/v2.5.0/tests/test-l7.py

Other dependencies are standard things like conntrack, ip, bridge-utils, wget.

In regards to affected kernels, I looked back as far as 3.13 and I can
still reproduce the issue with the above script.

Here's the kernel backtrace:

[  136.808116] BUG: spinlock lockup suspected on CPU#0, kworker/u256:30/160
[  136.808294]  lock: 0xffff880069fd6400, .magic: dead4ead, .owner:
kworker/u256:30/160, .owner_cpu: 0
[  136.808533] CPU: 0 PID: 160 Comm: kworker/u256:30 Tainted: G      D
W       4.6.0-rc4-nn-fw-sct1+ #32
[  136.808765] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[  136.809026]  0000000000000000 ffff880064f5f588 ffffffff813b62be
ffff880064f5a340
[  136.809372]  ffff880069fd6400 ffff880064f5f5a8 ffffffff8117f836
ffff880069fd6400
[  136.809720]  000000008ea72658 ffff880064f5f5d8 ffffffff810c16da
ffff880069fd6400
[  136.810057] Call Trace:
[  136.810174]  [<ffffffff813b62be>] dump_stack+0x67/0x99
[  136.810314]  [<ffffffff8117f836>] spin_dump+0x90/0x95
[  136.810452]  [<ffffffff810c16da>] do_raw_spin_lock+0x9a/0x130
[  136.810597]  [<ffffffff817a5d7d>] _raw_spin_lock+0x5d/0x80
[  136.810745]  [<ffffffff817a02c7>] ? __schedule+0xc7/0xd00
[  136.810885]  [<ffffffff817a02c7>] __schedule+0xc7/0xd00
[  136.811023]  [<ffffffff8117f9b1>] ? printk+0x4d/0x4f
[  136.811159]  [<ffffffff817a0f3c>] schedule+0x3c/0x90
[  136.811296]  [<ffffffff8106b22d>] do_exit+0xb3d/0xc50
[  136.811433]  [<ffffffff810d0449>] ? kmsg_dump+0x109/0x180
[  136.811574]  [<ffffffff8101fea9>] oops_end+0x89/0xc0
[  136.811711]  [<ffffffff8105323e>] no_context+0x10e/0x380
[  136.811850]  [<ffffffff810535c3>] __bad_area_nosemaphore+0x113/0x210
[  136.811999]  [<ffffffff810536d4>] bad_area_nosemaphore+0x14/0x20
[  136.812144]  [<ffffffff8105377e>] __do_page_fault+0x9e/0x500
[  136.812286]  [<ffffffff81002038>] ? trace_hardirqs_off_thunk+0x1b/0x1d
[  136.812437]  [<ffffffff81053bec>] do_page_fault+0xc/0x10
[  136.812580]  [<ffffffff817a86b2>] page_fault+0x22/0x30
[  136.812719]  [<ffffffff8108d340>] ? kthread_data+0x10/0x20
[  136.812860]  [<ffffffff81086e9e>] wq_worker_sleeping+0xe/0x90
[  136.813004]  [<ffffffff817a0a51>] __schedule+0x851/0xd00
[  136.813144]  [<ffffffff813895b3>] ? put_io_context_active+0xa3/0xc0
[  136.813292]  [<ffffffff817a0f3c>] schedule+0x3c/0x90
[  136.813428]  [<ffffffff8106adc8>] do_exit+0x6d8/0xc50
[  136.813571]  [<ffffffff8101fea9>] oops_end+0x89/0xc0
[  136.813707]  [<ffffffff8105323e>] no_context+0x10e/0x380
[  136.813847]  [<ffffffff810535c3>] __bad_area_nosemaphore+0x113/0x210
[  136.813996]  [<ffffffff810536d4>] bad_area_nosemaphore+0x14/0x20
[  136.814141]  [<ffffffff8105377e>] __do_page_fault+0x9e/0x500
[  136.814282]  [<ffffffff81002038>] ? trace_hardirqs_off_thunk+0x1b/0x1d
[  136.814433]  [<ffffffff81053bec>] do_page_fault+0xc/0x10
[  136.814571]  [<ffffffff817a86b2>] page_fault+0x22/0x30
[  136.814715]  [<ffffffffa00bc797>] ? nf_ct_helper_destroy+0x97/0x170
[nf_conntrack]
[  136.814937]  [<ffffffffa00bc83f>] ?
nf_ct_helper_destroy+0x13f/0x170 [nf_conntrack]
[  136.815163]  [<ffffffffa00bc73c>] ? nf_ct_helper_destroy+0x3c/0x170
[nf_conntrack]
[  136.815388]  [<ffffffffa00b6c9c>] nf_ct_delete+0x3c/0x1e0 [nf_conntrack]
[  136.815544]  [<ffffffffa00bc9f0>] ?
nf_conntrack_helper_fini+0x30/0x30 [nf_conntrack]
[  136.815768]  [<ffffffffa00b75c8>] nf_ct_iterate_cleanup+0x258/0x270
[nf_conntrack]
[  136.815990]  [<ffffffffa00bcf0f>]
nf_ct_l3proto_pernet_unregister+0x2f/0x60 [nf_conntrack]
[  136.816219]  [<ffffffffa00370e9>] ipv4_net_exit+0x19/0x50 [nf_conntrack_ipv4]
[  136.816377]  [<ffffffff81668fa8>] ops_exit_list.isra.4+0x38/0x60
[  136.816523]  [<ffffffff8166a35e>] cleanup_net+0x1be/0x290
[  136.816664]  [<ffffffff81085b2c>] process_one_work+0x1dc/0x660
[  136.816808]  [<ffffffff81085ab1>] ? process_one_work+0x161/0x660
[  136.816953]  [<ffffffff810860db>] worker_thread+0x12b/0x4a0
[  136.817095]  [<ffffffff81085fb0>] ? process_one_work+0x660/0x660
[  136.817240]  [<ffffffff8108ca22>] kthread+0xf2/0x110
[  136.817376]  [<ffffffff817a6c02>] ret_from_fork+0x22/0x40
[  136.817515]  [<ffffffff8108c930>] ? kthread_create_on_node+0x220/0x220

It seems like there are a couple of mitigations in the nf-next
pipeline at the moment. Firstly, if automatic helpers are turned off
then the namespace will not automatically add the FTP helper to
connections within the namespace. This decreases the likelihood of
hitting this issue, but you can still hit it if you re-enable the
automatic helpers.

Secondly, Florian's work to merge the conntrack tables across
namespaces seems to fix the issue at least with the above script.
While the basic repro script is unable to trigger the issue with those
patches, I wonder if a similar issue may persist due to the lack of
refcounting on helpers from rules. ie could we reproduce the issue by
explicitly setting FTP helper targets even on the latest code?

Cheers,
Joe
