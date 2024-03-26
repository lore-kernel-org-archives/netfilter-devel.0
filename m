Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343A2129A9A;
	Tue, 26 Mar 2024 04:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711426598; cv=none; b=UnyuNVBbrQg64zfXdjIWUfhuoYCGTX3uBmrTRI+2T9mkKCdYLQKKLTY6H87fnL/YEnhf4O0d42F54yNbZOH34c1eqywMQD9Jeqz0FOK92bi2/xa6ITDi9KJMMesNGfTXYiub1NMHZ9kJUbSal0s8+9f5YO3rhWp54K+zgwedR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711426598; c=relaxed/simple;
	bh=CSVejvEYOedfyonLgBa1G5pnuLOA66hTYhglClj35J8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H4pRQp//0qL1Z1keYE0jwQzuswFcmrSVNt4noGEEOF8raXhTo7/2OM7LQ5+r9HjjMENq/PuhtGiF/1zeAI1QN/SnIxSFySV4qot19o3YNUyIu2ETe3wEko5xQeWtbeTtObVPQ13NfbS6SUhgZHVYm9mdCq0lP53RrnfOMvHEmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=nUxXMYRT; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nUxXMYRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1711426597; x=1742962597;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YFx2se4bn9E56Ag+u1F7rtLy6zyMfAzjo4PoVE0Mmcw=;
  b=nUxXMYRT2WFaqK9WNc74aBcyNXS+lcpblAN6p2RrXWQZ7VSifXYamW7L
   iGFWvOjBYCvMs2OZVTybNb3v4HcmVo9N4Y0c/XA96enNWyr+cqtfjaFTh
   a+Ar646x9j1x0fAzW1KiXcMSrg6DTVwYUNRmbwoD66XuZv8L6zxiI/+dE
   g=;
X-IronPort-AV: E=Sophos;i="6.07,155,1708387200"; 
   d="scan'208";a="335178185"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 04:16:30 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:11300]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.88:2525] with esmtp (Farcaster)
 id 610b1168-5c11-4beb-8700-7c740ef800bb; Tue, 26 Mar 2024 04:16:28 +0000 (UTC)
X-Farcaster-Flow-ID: 610b1168-5c11-4beb-8700-7c740ef800bb
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 26 Mar 2024 04:16:28 +0000
Received: from 88665a182662.ant.amazon.com.com (10.187.171.62) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 26 Mar 2024 04:16:25 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>
CC: Florian Westphal <fw@strlen.de>, Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>, syzkaller
	<syzkaller@googlegroups.com>
Subject: [PATCH v1 nf] netfilter: arptables: Select NETFILTER_FAMILY_ARP when building arp_tables.c
Date: Mon, 25 Mar 2024 21:15:52 -0700
Message-ID: <20240326041552.19888-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

syzkaller started to report a warning below [0] after consuming the
commit 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only
builds").

The change accidentally removed the dependency on NETFILTER_FAMILY_ARP
from IP_NF_ARPTABLES.

If NF_TABLES_ARP is not enabled on Kconfig, NETFILTER_FAMILY_ARP will
be removed and some code necessary for arptables will not be compiled.

  $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
  CONFIG_NETFILTER_FAMILY_ARP=y
  # CONFIG_NF_TABLES_ARP is not set
  CONFIG_IP_NF_ARPTABLES=y

  $ make olddefconfig

  $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
  # CONFIG_NF_TABLES_ARP is not set
  CONFIG_IP_NF_ARPTABLES=y

So, when nf_register_net_hooks() is called for arptables, it will
trigger the splat below.

Now IP_NF_ARPTABLES is only enabled by IP_NF_ARPFILTER, so let's
restore the dependency on NETFILTER_FAMILY_ARP in IP_NF_ARPFILTER.

[0]:
WARNING: CPU: 0 PID: 242 at net/netfilter/core.c:316 nf_hook_entry_head+0x1e1/0x2c0 net/netfilter/core.c:316
Modules linked in:
CPU: 0 PID: 242 Comm: syz-executor.0 Not tainted 6.8.0-12821-g537c2e91d354 #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:nf_hook_entry_head+0x1e1/0x2c0 net/netfilter/core.c:316
Code: 83 fd 04 0f 87 bc 00 00 00 e8 5b 84 83 fd 4d 8d ac ec a8 0b 00 00 e8 4e 84 83 fd 4c 89 e8 5b 5d 41 5c 41 5d c3 e8 3f 84 83 fd <0f> 0b e8 38 84 83 fd 45 31 ed 5b 5d 4c 89 e8 41 5c 41 5d c3 e8 26
RSP: 0018:ffffc90000b8f6e8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff83c42164
RDX: ffff888106851180 RSI: ffffffff83c42321 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 000000000000000a
R10: 0000000000000003 R11: ffff8881055c2f00 R12: ffff888112b78000
R13: 0000000000000000 R14: ffff8881055c2f00 R15: ffff8881055c2f00
FS:  00007f377bd78800(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000496068 CR3: 000000011298b003 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __nf_register_net_hook+0xcd/0x7a0 net/netfilter/core.c:428
 nf_register_net_hook+0x116/0x170 net/netfilter/core.c:578
 nf_register_net_hooks+0x5d/0xc0 net/netfilter/core.c:594
 arpt_register_table+0x250/0x420 net/ipv4/netfilter/arp_tables.c:1553
 arptable_filter_table_init+0x41/0x60 net/ipv4/netfilter/arptable_filter.c:39
 xt_find_table_lock+0x2e9/0x4b0 net/netfilter/x_tables.c:1260
 xt_request_find_table_lock+0x2b/0xe0 net/netfilter/x_tables.c:1285
 get_info+0x169/0x5c0 net/ipv4/netfilter/arp_tables.c:808
 do_arpt_get_ctl+0x3f9/0x830 net/ipv4/netfilter/arp_tables.c:1444
 nf_getsockopt+0x76/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt+0x17d/0x1c0 net/ipv4/ip_sockglue.c:1777
 tcp_getsockopt+0x99/0x100 net/ipv4/tcp.c:4373
 do_sock_getsockopt+0x279/0x360 net/socket.c:2373
 __sys_getsockopt+0x115/0x1e0 net/socket.c:2402
 __do_sys_getsockopt net/socket.c:2412 [inline]
 __se_sys_getsockopt net/socket.c:2409 [inline]
 __x64_sys_getsockopt+0xbd/0x150 net/socket.c:2409
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x4f/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0x7f377beca6fe
Code: 1f 44 00 00 48 8b 15 01 97 0a 00 f7 d8 64 89 02 b8 ff ff ff ff eb b8 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 8b 15 c9
RSP: 002b:00000000005df728 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000004966e0 RCX: 00007f377beca6fe
RDX: 0000000000000060 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000042938a R08: 00000000005df73c R09: 00000000005df800
R10: 00000000004966e8 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000496068 R14: 0000000000000003 R15: 00000000004bc9d8
 </TASK>

Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 8f6e950163a7..1b991b889506 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -329,6 +329,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	select NETFILTER_FAMILY_ARP
 	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
-- 
2.30.2

