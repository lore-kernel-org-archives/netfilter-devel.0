From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/12] netfilter: xt_bpf: add overflow checks
Date: Wed, 13 Dec 2017 19:45:16 +0100
Message-ID: <20171213184520.8193-9-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753734AbdLMSph (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 13:45:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B3A04174D12
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 19:45:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A50B3DA86B
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 19:45:34 +0100 (CET)
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jann Horn <jannh@google.com>

Check whether inputs from userspace are too long (explicit length field too
big or string not null-terminated) to avoid out-of-bounds reads.

As far as I can tell, this can at worst lead to very limited kernel heap
memory disclosure or oopses.

This bug can be triggered by an unprivileged user even if the xt_bpf module
is not loaded: iptables is available in network namespaces, and the xt_bpf
module can be autoloaded.

Triggering the bug with a classic BPF filter with fake length 0x1000 causes
the following KASAN report:

==================================================================
BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0x84/0xf0
Read of size 32768 at addr ffff8801eff2c494 by task test/4627

CPU: 0 PID: 4627 Comm: test Not tainted 4.15.0-rc1+ #1
[...]
Call Trace:
 dump_stack+0x5c/0x85
 print_address_description+0x6a/0x260
 kasan_report+0x254/0x370
 ? bpf_prog_create+0x84/0xf0
 memcpy+0x1f/0x50
 bpf_prog_create+0x84/0xf0
 bpf_mt_check+0x90/0xd6 [xt_bpf]
[...]
Allocated by task 4627:
 kasan_kmalloc+0xa0/0xd0
 __kmalloc_node+0x47/0x60
 xt_alloc_table_info+0x41/0x70 [x_tables]
[...]
The buggy address belongs to the object at ffff8801eff2c3c0
                which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 212 bytes inside of
                2048-byte region [ffff8801eff2c3c0, ffff8801eff2cbc0)
[...]
==================================================================

Fixes: e6f30c731718 ("netfilter: x_tables: add xt_bpf match")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_bpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index 041da0d9c06f..1f7fbd3c7e5a 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -27,6 +27,9 @@ static int __bpf_mt_check_bytecode(struct sock_filter *insns, __u16 len,
 {
 	struct sock_fprog_kern program;
 
+	if (len > XT_BPF_MAX_NUM_INSTR)
+		return -EINVAL;
+
 	program.len = len;
 	program.filter = insns;
 
@@ -55,6 +58,9 @@ static int __bpf_mt_check_path(const char *path, struct bpf_prog **ret)
 	mm_segment_t oldfs = get_fs();
 	int retval, fd;
 
+	if (strnlen(path, XT_BPF_PATH_MAX) == XT_BPF_PATH_MAX)
+		return -EINVAL;
+
 	set_fs(KERNEL_DS);
 	fd = bpf_obj_get_user(path, 0);
 	set_fs(oldfs);
-- 
2.11.0

