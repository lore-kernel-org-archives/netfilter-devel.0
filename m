Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE741364A4;
	Thu, 25 Jul 2024 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721935745; cv=none; b=VTfJGxkku70pGCYfyKKr4a97EAql8NqvTm0UGNigg2eCU4twRS/8xHSPJZQLkLQZxmJdJ+RJP6lzzop89mX1Ct+dI0pJ3r6uYlrlC07rokw83UOAZ7YO89ykrHhcIKoXMxkpSed93ErnigWkVNThRzVhHkVuAz9NFnfWpk5tZ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721935745; c=relaxed/simple;
	bh=Q/znnOJhdo0wsH6GA8DmbIibs4se7mo44cJMi4y7YvE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzEjE+4Mz1dOkX3WW/VU1npGVzOY3QOpaD+AeFodt4o8c8Yie4qo0d5JINjkeNfpCKPCrWX9qlOM1wXcqY4tdEx+rMVr9Q6zDiL0K3n+qWTtXlpe2B4oruYXNPCi0ew+gS//HwvBA1IB6iR8VZa9O/ExUrvlrdvmTT4CJJnhCNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=enZzmWV/; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="enZzmWV/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721935745; x=1753471745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0OpIpcRPTGgj6LUxUrMr4YJlXHwdHkGgf0VGsfHvBro=;
  b=enZzmWV/UglT299FOUy9VBWREQ1OXPka4CunJi2gXW+XXmTgtRm1YG0I
   yu0z1McktDbsXeaRpPssPOax76K6roFZmPQZ4gT4ucSYJjI7eRtEXCoDy
   goOBZPtOuBwmA3/mIAJr68w/S0CIfxu58QkJcq0f46J2nurw0os2EMvPY
   o=;
X-IronPort-AV: E=Sophos;i="6.09,236,1716249600"; 
   d="scan'208";a="15012923"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 19:29:02 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:32421]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.122:2525] with esmtp (Farcaster)
 id 5a9f12ee-c6b0-47ff-ba02-5fd4d076505e; Thu, 25 Jul 2024 19:29:00 +0000 (UTC)
X-Farcaster-Flow-ID: 5a9f12ee-c6b0-47ff-ba02-5fd4d076505e
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:29:00 +0000
Received: from 88665a182662.ant.amazon.com (10.88.167.203) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:28:57 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>
CC: Florian Westphal <fw@strlen.de>, Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>, Takahiro Kawahara
	<takawaha@amazon.co.jp>
Subject: [PATCH v1 nf 1/2] netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().
Date: Thu, 25 Jul 2024 12:28:20 -0700
Message-ID: <20240725192822.4478-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240725192822.4478-1-kuniyu@amazon.com>
References: <20240725192822.4478-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWA003.ant.amazon.com (10.13.139.105) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

We had a report that iptables-restore sometimes triggered null-ptr-deref
at boot time. [0]

The problem is that iptable_nat_table_init() is exposed to user space
before the kernel fully initialises netns.

In the small race window, a user could call iptable_nat_table_init()
that accesses net_generic(net, iptable_nat_net_id), which is available
only after registering iptable_nat_net_ops.

Let's call register_pernet_subsys() before xt_register_template().

[0]:
bpfilter: Loaded bpfilter_umh pid 11702
Started bpfilter
BUG: kernel NULL pointer dereference, address: 0000000000000013
 PF: supervisor write access in kernel mode
 PF: error_code(0x0002) - not-present page
PGD 0 P4D 0
PREEMPT SMP NOPTI
CPU: 2 PID: 11879 Comm: iptables-restor Not tainted 6.1.92-99.174.amzn2023.x86_64 #1
Hardware name: Amazon EC2 c6i.4xlarge/, BIOS 1.0 10/16/2017
RIP: 0010:iptable_nat_table_init (net/ipv4/netfilter/iptable_nat.c:87 net/ipv4/netfilter/iptable_nat.c:121) iptable_nat
Code: 10 4c 89 f6 48 89 ef e8 0b 19 bb ff 41 89 c4 85 c0 75 38 41 83 c7 01 49 83 c6 28 41 83 ff 04 75 dc 48 8b 44 24 08 48 8b 0c 24 <48> 89 08 4c 89 ef e8 a2 3b a2 cf 48 83 c4 10 44 89 e0 5b 5d 41 5c
RSP: 0018:ffffbef902843cd0 EFLAGS: 00010246
RAX: 0000000000000013 RBX: ffff9f4b052caa20 RCX: ffff9f4b20988d80
RDX: 0000000000000000 RSI: 0000000000000064 RDI: ffffffffc04201c0
RBP: ffff9f4b29394000 R08: ffff9f4b07f77258 R09: ffff9f4b07f77240
R10: 0000000000000000 R11: ffff9f4b09635388 R12: 0000000000000000
R13: ffff9f4b1a3c6c00 R14: ffff9f4b20988e20 R15: 0000000000000004
FS:  00007f6284340000(0000) GS:ffff9f51fe280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000013 CR3: 00000001d10a6005 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? show_trace_log_lvl (arch/x86/kernel/dumpstack.c:259)
 ? show_trace_log_lvl (arch/x86/kernel/dumpstack.c:259)
 ? xt_find_table_lock (net/netfilter/x_tables.c:1259)
 ? __die_body.cold (arch/x86/kernel/dumpstack.c:478 arch/x86/kernel/dumpstack.c:420)
 ? page_fault_oops (arch/x86/mm/fault.c:727)
 ? exc_page_fault (./arch/x86/include/asm/irqflags.h:40 ./arch/x86/include/asm/irqflags.h:75 arch/x86/mm/fault.c:1470 arch/x86/mm/fault.c:1518)
 ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
 ? iptable_nat_table_init (net/ipv4/netfilter/iptable_nat.c:87 net/ipv4/netfilter/iptable_nat.c:121) iptable_nat
 xt_find_table_lock (net/netfilter/x_tables.c:1259)
 xt_request_find_table_lock (net/netfilter/x_tables.c:1287)
 get_info (net/ipv4/netfilter/ip_tables.c:965)
 ? security_capable (security/security.c:809 (discriminator 13))
 ? ns_capable (kernel/capability.c:376 kernel/capability.c:397)
 ? do_ipt_get_ctl (net/ipv4/netfilter/ip_tables.c:1656)
 ? bpfilter_send_req (net/bpfilter/bpfilter_kern.c:52) bpfilter
 nf_getsockopt (net/netfilter/nf_sockopt.c:116)
 ip_getsockopt (net/ipv4/ip_sockglue.c:1827)
 __sys_getsockopt (net/socket.c:2327)
 __x64_sys_getsockopt (net/socket.c:2342 net/socket.c:2339 net/socket.c:2339)
 do_syscall_64 (arch/x86/entry/common.c:51 arch/x86/entry/common.c:81)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
RIP: 0033:0x7f62844685ee
Code: 48 8b 0d 45 28 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 8b 15 09
RSP: 002b:00007ffd1f83d638 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffd1f83d680 RCX: 00007f62844685ee
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000004 R08: 00007ffd1f83d670 R09: 0000558798ffa2a0
R10: 00007ffd1f83d680 R11: 0000000000000246 R12: 00007ffd1f83e3b2
R13: 00007f628455baa0 R14: 00007ffd1f83d7b0 R15: 00007f628457a008
 </TASK>
Modules linked in: iptable_nat(+) bpfilter rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache veth xt_state xt_connmark xt_nat xt_statistic xt_MASQUERADE xt_mark xt_addrtype ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compat nf_tables nfnetlink overlay nls_ascii nls_cp437 vfat fat ghash_clmulni_intel aesni_intel ena crypto_simd ptp cryptd i8042 pps_core serio button sunrpc sch_fq_codel configfs loop dm_mod fuse dax dmi_sysfs crc32_pclmul crc32c_intel efivarfs
CR2: 0000000000000013

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Takahiro Kawahara <takawaha@amazon.co.jp>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/netfilter/iptable_nat.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 4d42d0756fd7..a5db7c67d61b 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -145,25 +145,27 @@ static struct pernet_operations iptable_nat_net_ops = {
 
 static int __init iptable_nat_init(void)
 {
-	int ret = xt_register_template(&nf_nat_ipv4_table,
-				       iptable_nat_table_init);
+	int ret;
 
+	/* net->gen->ptr[iptable_nat_net_id] must be allocated
+	 * before calling iptable_nat_table_init().
+	 */
+	ret = register_pernet_subsys(&iptable_nat_net_ops);
 	if (ret < 0)
 		return ret;
 
-	ret = register_pernet_subsys(&iptable_nat_net_ops);
-	if (ret < 0) {
-		xt_unregister_template(&nf_nat_ipv4_table);
-		return ret;
-	}
+	ret = xt_register_template(&nf_nat_ipv4_table,
+				   iptable_nat_table_init);
+	if (ret < 0)
+		unregister_pernet_subsys(&iptable_nat_net_ops);
 
 	return ret;
 }
 
 static void __exit iptable_nat_exit(void)
 {
-	unregister_pernet_subsys(&iptable_nat_net_ops);
 	xt_unregister_template(&nf_nat_ipv4_table);
+	unregister_pernet_subsys(&iptable_nat_net_ops);
 }
 
 module_init(iptable_nat_init);
-- 
2.30.2

