From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: netfilter/nftables oops in 4.8
Date: Fri, 18 Nov 2016 09:05:32 +0100
Message-ID: <CAOkSjBiN5X67f4=uSCnvNTnQfpMdLJbThCkiPyzPeuHfuQoaLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38877 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbcKRIF4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2016 03:05:56 -0500
Received: by mail-wm0-f46.google.com with SMTP id f82so20845348wmf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2016 00:05:55 -0800 (PST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com. [74.125.82.42])
        by smtp.gmail.com with ESMTPSA id vr9sm7424421wjc.35.2016.11.18.00.05.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Nov 2016 00:05:53 -0800 (PST)
Received: by mail-wm0-f42.google.com with SMTP id a197so21223780wmd.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2016 00:05:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this happened today in my machine at boot time. I can't reproduce it again.

linux 4.8.5-1 (debian)

[vie nov 18 08:42:18 2016] INFO: task modprobe:641 blocked for more
than 120 seconds.
[vie nov 18 08:42:18 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:42:18 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:42:18 2016] modprobe        D ffff99ddbb3ee400     0
641    106 0x00000000
[vie nov 18 08:42:18 2016]  ffff99ddb90d2d40 ffff99dd76418100
0000000000000001 0000000000000001
[vie nov 18 08:42:18 2016]  ffff99ddbbe04000 ffff99ddbbe03c68
ffffffffaaedc3a4 ffff99ddb90d2d40
[vie nov 18 08:42:18 2016]  00000000ffffffff ffffffffaaedc3a8
ffffffffaa9eb4e1 ffffffffaaedc3a0
[vie nov 18 08:42:18 2016] Call Trace:
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:42:18 2016]  [<ffffffffc0aaf000>] ? 0xffffffffc0aaf000
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:42:18 2016]  [<ffffffffaa8e2535>] ?
register_pernet_subsys+0x15/0x40
[vie nov 18 08:42:18 2016]  [<ffffffffc0aa60c6>] ?
nf_ct_frag6_init+0x76/0xa0 [nf_defrag_ipv6]
[vie nov 18 08:42:18 2016]  [<ffffffffc0aaf006>] ?
nf_defrag_init+0x6/0x1000 [nf_defrag_ipv6]
[vie nov 18 08:42:18 2016]  [<ffffffffaa40218c>] ? do_one_initcall+0x4c/0x180
[vie nov 18 08:42:18 2016]  [<ffffffffaa5c4f2d>] ? __vunmap+0x6d/0xc0
[vie nov 18 08:42:18 2016]  [<ffffffffaa57aeb8>] ? do_init_module+0x5b/0x1ed
[vie nov 18 08:42:18 2016]  [<ffffffffaa502e70>] ? load_module+0x2330/0x29f0
[vie nov 18 08:42:18 2016]  [<ffffffffaa4ff8a0>] ? __symbol_put+0x60/0x60
[vie nov 18 08:42:18 2016]  [<ffffffffaa6021c8>] ? vfs_read+0x118/0x130
[vie nov 18 08:42:18 2016]  [<ffffffffaa503776>] ? SYSC_finit_module+0xc6/0xf0
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
[vie nov 18 08:42:18 2016] INFO: task (ostnamed):644 blocked for more
than 120 seconds.
[vie nov 18 08:42:18 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:42:18 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:42:18 2016] (ostnamed)      D ffff99ddbfa98180     0
644      1 0x00000004
[vie nov 18 08:42:18 2016]  ffff99ddb9077100 ffff99ddbc902ec0
0000000000000003 0000000000000001
[vie nov 18 08:42:18 2016]  ffff99ddbc238000 ffff99ddbc237dd8
ffffffffc080b5a4 ffff99ddb9077100
[vie nov 18 08:42:18 2016]  00000000ffffffff ffffffffc080b5a8
ffffffffaa9eb4e1 ffffffffc080b5a0
[vie nov 18 08:42:18 2016] Call Trace:
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:42:18 2016]  [<ffffffffc0a5f863>] ?
nft_register_afinfo+0x23/0x50 [nf_tables]
[vie nov 18 08:42:18 2016]  [<ffffffffc080e119>] ?
nf_tables_ipv4_init_net+0xe9/0x110 [nf_tables_ipv4]
[vie nov 18 08:42:18 2016]  [<ffffffffaa8e2189>] ? ops_init+0x39/0x100
[vie nov 18 08:42:18 2016]  [<ffffffffaa8e22d5>] ? setup_net+0x85/0x130
[vie nov 18 08:42:18 2016]  [<ffffffffaa8e2b74>] ? copy_net_ns+0x74/0x100
[vie nov 18 08:42:18 2016]  [<ffffffffaa49b9c6>] ?
create_new_namespaces+0x116/0x1c0
[vie nov 18 08:42:18 2016]  [<ffffffffaa49bbd5>] ?
unshare_nsproxy_namespaces+0x55/0xa0
[vie nov 18 08:42:18 2016]  [<ffffffffaa47ba07>] ? SyS_unshare+0x1e7/0x390
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
[vie nov 18 08:42:18 2016] INFO: task (t-daemon):1004 blocked for more
than 120 seconds.
[vie nov 18 08:42:18 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:42:18 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:42:18 2016] (t-daemon)      D ffff99ddbfa98180     0
1004      1 0x00000004
[vie nov 18 08:42:18 2016]  ffff99ddba1bcf00 ffff99ddbc902ec0
0000000000000000 0000000001e52a00
[vie nov 18 08:42:18 2016]  ffff99ddb9468000 ffff99ddb9467e70
ffffffffaaedc3a4 ffff99ddba1bcf00
[vie nov 18 08:42:18 2016]  00000000ffffffff ffffffffaaedc3a8
ffffffffaa9eb4e1 ffffffffaaedc3a0
[vie nov 18 08:42:18 2016] Call Trace:
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:42:18 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:42:18 2016]  [<ffffffffaa8e2b69>] ? copy_net_ns+0x69/0x100
[vie nov 18 08:42:18 2016]  [<ffffffffaa49b9c6>] ?
create_new_namespaces+0x116/0x1c0
[vie nov 18 08:42:18 2016]  [<ffffffffaa49bbd5>] ?
unshare_nsproxy_namespaces+0x55/0xa0
[vie nov 18 08:42:18 2016]  [<ffffffffaa47ba07>] ? SyS_unshare+0x1e7/0x390
[vie nov 18 08:42:18 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
[vie nov 18 08:44:19 2016] INFO: task modprobe:641 blocked for more
than 120 seconds.
[vie nov 18 08:44:19 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:44:19 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:44:19 2016] modprobe        D ffff99ddbb3ee400     0
641    106 0x00000000
[vie nov 18 08:44:19 2016]  ffff99ddb90d2d40 ffff99dd76418100
0000000000000001 0000000000000001
[vie nov 18 08:44:19 2016]  ffff99ddbbe04000 ffff99ddbbe03c68
ffffffffaaedc3a4 ffff99ddb90d2d40
[vie nov 18 08:44:19 2016]  00000000ffffffff ffffffffaaedc3a8
ffffffffaa9eb4e1 ffffffffaaedc3a0
[vie nov 18 08:44:19 2016] Call Trace:
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:44:19 2016]  [<ffffffffc0aaf000>] ? 0xffffffffc0aaf000
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:44:19 2016]  [<ffffffffaa8e2535>] ?
register_pernet_subsys+0x15/0x40
[vie nov 18 08:44:19 2016]  [<ffffffffc0aa60c6>] ?
nf_ct_frag6_init+0x76/0xa0 [nf_defrag_ipv6]
[vie nov 18 08:44:19 2016]  [<ffffffffc0aaf006>] ?
nf_defrag_init+0x6/0x1000 [nf_defrag_ipv6]
[vie nov 18 08:44:19 2016]  [<ffffffffaa40218c>] ? do_one_initcall+0x4c/0x180
[vie nov 18 08:44:19 2016]  [<ffffffffaa5c4f2d>] ? __vunmap+0x6d/0xc0
[vie nov 18 08:44:19 2016]  [<ffffffffaa57aeb8>] ? do_init_module+0x5b/0x1ed
[vie nov 18 08:44:19 2016]  [<ffffffffaa502e70>] ? load_module+0x2330/0x29f0
[vie nov 18 08:44:19 2016]  [<ffffffffaa4ff8a0>] ? __symbol_put+0x60/0x60
[vie nov 18 08:44:19 2016]  [<ffffffffaa6021c8>] ? vfs_read+0x118/0x130
[vie nov 18 08:44:19 2016]  [<ffffffffaa503776>] ? SYSC_finit_module+0xc6/0xf0
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
[vie nov 18 08:44:19 2016] INFO: task (ostnamed):644 blocked for more
than 120 seconds.
[vie nov 18 08:44:19 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:44:19 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:44:19 2016] (ostnamed)      D ffff99ddbfa98180     0
644      1 0x00000004
[vie nov 18 08:44:19 2016]  ffff99ddb9077100 ffff99ddbc902ec0
0000000000000003 0000000000000001
[vie nov 18 08:44:19 2016]  ffff99ddbc238000 ffff99ddbc237dd8
ffffffffc080b5a4 ffff99ddb9077100
[vie nov 18 08:44:19 2016]  00000000ffffffff ffffffffc080b5a8
ffffffffaa9eb4e1 ffffffffc080b5a0
[vie nov 18 08:44:19 2016] Call Trace:
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:44:19 2016]  [<ffffffffc0a5f863>] ?
nft_register_afinfo+0x23/0x50 [nf_tables]
[vie nov 18 08:44:19 2016]  [<ffffffffc080e119>] ?
nf_tables_ipv4_init_net+0xe9/0x110 [nf_tables_ipv4]
[vie nov 18 08:44:19 2016]  [<ffffffffaa8e2189>] ? ops_init+0x39/0x100
[vie nov 18 08:44:19 2016]  [<ffffffffaa8e22d5>] ? setup_net+0x85/0x130
[vie nov 18 08:44:19 2016]  [<ffffffffaa8e2b74>] ? copy_net_ns+0x74/0x100
[vie nov 18 08:44:19 2016]  [<ffffffffaa49b9c6>] ?
create_new_namespaces+0x116/0x1c0
[vie nov 18 08:44:19 2016]  [<ffffffffaa49bbd5>] ?
unshare_nsproxy_namespaces+0x55/0xa0
[vie nov 18 08:44:19 2016]  [<ffffffffaa47ba07>] ? SyS_unshare+0x1e7/0x390
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
[vie nov 18 08:44:19 2016] INFO: task (t-daemon):1004 blocked for more
than 120 seconds.
[vie nov 18 08:44:19 2016]       Not tainted 4.8.0-1-amd64 #1
[vie nov 18 08:44:19 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[vie nov 18 08:44:19 2016] (t-daemon)      D ffff99ddbfa98180     0
1004      1 0x00000004
[vie nov 18 08:44:19 2016]  ffff99ddba1bcf00 ffff99ddbc902ec0
0000000000000000 0000000001e52a00
[vie nov 18 08:44:19 2016]  ffff99ddb9468000 ffff99ddb9467e70
ffffffffaaedc3a4 ffff99ddba1bcf00
[vie nov 18 08:44:19 2016]  00000000ffffffff ffffffffaaedc3a8
ffffffffaa9eb4e1 ffffffffaaedc3a0
[vie nov 18 08:44:19 2016] Call Trace:
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb4e1>] ? schedule+0x31/0x80
[vie nov 18 08:44:19 2016]  [<ffffffffaa9eb77a>] ?
schedule_preempt_disabled+0xa/0x10
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed1f4>] ?
__mutex_lock_slowpath+0xb4/0x130
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ed28b>] ? mutex_lock+0x1b/0x30
[vie nov 18 08:44:19 2016]  [<ffffffffaa8e2b69>] ? copy_net_ns+0x69/0x100
[vie nov 18 08:44:19 2016]  [<ffffffffaa49b9c6>] ?
create_new_namespaces+0x116/0x1c0
[vie nov 18 08:44:19 2016]  [<ffffffffaa49bbd5>] ?
unshare_nsproxy_namespaces+0x55/0xa0
[vie nov 18 08:44:19 2016]  [<ffffffffaa47ba07>] ? SyS_unshare+0x1e7/0x390
[vie nov 18 08:44:19 2016]  [<ffffffffaa9ef8f6>] ?
system_call_fast_compare_end+0xc/0x96
