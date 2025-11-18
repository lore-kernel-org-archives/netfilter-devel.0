Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDE51DB125;
	Tue, 18 Nov 2025 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504263; cv=none; b=sAsrBxZhc5vsxuJblAKM7xq/ROkMpSMg7qkDTtTR+E3Fm3crav+0c4nyWA2P3BXgVXkTVFBU0jEEguQj8KQMi7phUDcVL45d8EE3cFVXQO0ZGidWi8WFJGeyFp0wenl0LfagTceclAicW8NLthmvsB0UT+FH/UM2e8eXeyMS5k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504263; c=relaxed/simple;
	bh=jOJS+/ezwREemcEEx7dR18vNFfjo7nevM7zxr8Is32M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WfV169MNyHhLgxWuTHVPhZ8QFeHNqO9ztEn7yRLDUfWiHPrvDegmTVgHY5Po8zu0qLfYs5eEHrjQpUN3YUfM3CqOl896D9voOAX4gk7uKJwpGuCuCWz0b9KNz5h6us3GoSNs3MhohPcHPiglvUNKfNb4wF8tYrALUoGcVh6LuLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FYNaeccX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FYNaeccX"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 4F650211FEC8; Tue, 18 Nov 2025 14:17:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4F650211FEC8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1763504255;
	bh=ta8n24HsIyNWtbZuConceyQiNS4SCa7esiW2FKuxcCw=;
	h=Date:From:To:Cc:Subject:From;
	b=FYNaeccXEPTSU4du6U61U0NS140+9wjZBTixkw0hGk+MkVPBEv8xNIyerYPWt+Tbj
	 Y/+x5eU+nHCP+Pje78cO9ASMfYcQE+iPJDFwkSE0uvEk6Rbr0Qkj3ZdhqOCz+J3uQ+
	 gKST0Eicb2GnVC7wYb/HezShZ0vKZd8c/SQDP+4A=
Date: Tue, 18 Nov 2025 14:17:35 -0800
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: netdev@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Soft lock-ups caused by iptables
Message-ID: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)

Hi,

I am able to consistly repro several cpu soft lock-ups that seem to all
end up in either in nft_chain_validate(), nft_match_validate(), or
nft_match_validate(), see below for examples. Also, this doesn't seem
to be a recent regression since I am able to repro it as far back as
v5.15.184. The repro steps are rather convoluted (involving a config
with a ~40k iptables rules and 2 vCPUs) so I am happy to test any
patches. You can find the config I used to build the 6.18 kernel at [1].

[1] https://raw.githubusercontent.com/microsoft/azurelinux/refs/heads/3.0-dev/SPECS/kernel-hwe/config

Trace #1:
 watchdog: BUG: soft lockup - CPU#1 stuck for 27s! [iptables-nft-re:37547]
 Modules linked in: ipt_REJECT nf_reject_ipv4 xt_REDIRECT xt_connmark ip_set_hash_ipport ip_set_hash_net ip_set_list_set xt_statistic xt_nfacct nfnetlink_acct xt_mark xt_MASQUERADE xt_addrtype xt_nat xt_set ip_set_hash_ip ip_set xt_comment tls mptcp_diag xsk_diag vsock_diag tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag nf_conntrack_netlink nft_masq nft_nat nft_fib_ipv4 nft_fib nft_chain_nat cfg80211 8021q garp mrp binfmt_misc xt_conntrack xt_owner nft_compat nf_tables mlx5_ib ib_uverbs ib_core mlx5_core mousedev intel_rapl_msr hid_generic mlxfw intel_rapl_common hid_hyperv hyperv_fb evdev hid sch_fq_codel dm_multipath nf_nat ebt_ip nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc fuse drm dmi_sysfs autofs4
 CPU: 1 UID: 0 PID: 37547 Comm: iptables-nft-re Not tainted 6.18.0-rc6+ #1 PREEMPT(none) 
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 08/23/2024
 RIP: 0010:nft_chain_validate+0xcb/0x110 [nf_tables]
 Code: 10 eb c3 49 8b 07 8b 40 10 49 01 c7 4d 39 fd 74 b5 49 8b 07 48 8b 48 48 48 85 c9 74 e9 4c 89 fe 48 89 df e8 57 35 61 f6 85 c0 <79> d7 5b 41 5c 41 5d 41 5e 41 5f 5d e9 af a8 47 f5 65 48 8b 05 b4
 RSP: 0018:ffffd11885f3b428 EFLAGS: 00000246
 RAX: 0000000000000000 RBX: ffffd11885f3b640 RCX: 0000000000000002
 RDX: 0000000000000002 RSI: 000000000000001f RDI: 0000000000000000
 RBP: ffffd11885f3b450 R08: 0000000000000000 R09: 000000000003abc8
 R10: 000000000000000f R11: 0000000000000007 R12: ffff89bc4c3eb100
 R13: ffff89bc4c3eb1e0 R14: ffff89bc4baf0190 R15: ffff89bc4c3eb1a0
 FS:  00007e16cbfa8080(0000) GS:ffff89bef78f5000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007e16cbea2008 CR3: 00000002477e1000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_table_validate+0x6b/0xb0 [nf_tables]
  nf_tables_validate+0x8b/0xa0 [nf_tables]
  nf_tables_commit+0x1df/0x1eb0 [nf_tables]
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? kvfree+0x31/0x40
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? nf_tables_newrule+0x9e2/0xc70 [nf_tables]
  nfnetlink_rcv_batch+0x2b0/0x9d0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __nla_validate_parse+0x5a/0xcd0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? apparmor_capable+0xbb/0x1a0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? security_capable+0x82/0x190
  nfnetlink_rcv+0x120/0x160
  netlink_unicast+0x282/0x3d0
  ? __build_skb+0x52/0x60
  netlink_sendmsg+0x20c/0x440
  ____sys_sendmsg+0x35f/0x390
  ? srso_alias_return_thunk+0x5/0xfbef5
  ___sys_sendmsg+0x85/0xd0
  ? security_capable+0x82/0x190
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? _raw_spin_unlock_bh+0x21/0x30
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? release_sock+0x91/0xb0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? sk_setsockopt+0x1ac/0x17b0
  ? aa_sk_perm+0x99/0x220
  __sys_sendmsg+0x77/0xe0
  ? audit_reset_context+0x24a/0x320
  __x64_sys_sendmsg+0x21/0x30
  x64_sys_call+0x1b5f/0x20f0
  do_syscall_64+0x72/0x7c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? count_memcg_events+0xbd/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? handle_mm_fault+0xc0/0x300
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_user_addr_fault+0x205/0x6c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? irqentry_exit+0x3f/0x50
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? exc_page_fault+0x7f/0x170
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7e16cc0d5034
 Code: 15 e9 6d 0d 00 f7 d8 64 89 02 b8 ff ff ff ff eb bf 0f 1f 44 00 00 f3 0f 1e fa 80 3d 15 f0 0d 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
 RSP: 002b:00007ffd99bb52f8 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 00007ffd99bb9ea0 RCX: 00007e16cc0d5034
 RDX: 0000000000000000 RSI: 00007ffd99bb63a0 RDI: 0000000000000003
 RBP: 00007ffd99bb69a0 R08: 0000000000000004 R09: 00007e16cc24a440
 R10: 00007ffd99bb638c R11: 0000000000000202 R12: 00000000006a7000
 R13: 00007ffd99bb5300 R14: 0000000000000001 R15: 00007ffd99bb5310
  </TASK>

Trace #2:
 watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [iptables-nft-re:40308]
 Modules linked in: ipt_REJECT nf_reject_ipv4 xt_REDIRECT xt_connmark ip_set_hash_ipport ip_set_hash_net ip_set_list_set xt_statistic xt_nfacct nfnetlink_acct xt_mark xt_MASQUERADE xt_addrtype xt_nat xt_set ip_set_hash_ip ip_set xt_comment tls mptcp_diag xsk_diag vsock_diag tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag nf_conntrack_netlink nft_masq nft_nat nft_fib_ipv4 nft_fib nft_chain_nat cfg80211 8021q garp mrp binfmt_misc xt_conntrack xt_owner nft_compat nf_tables mlx5_ib ib_uverbs ib_core mlx5_core mousedev intel_rapl_msr hid_generic mlxfw intel_rapl_common hid_hyperv hyperv_fb evdev hid sch_fq_codel dm_multipath nf_nat ebt_ip nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc fuse drm dmi_sysfs autofs4
 CPU: 0 UID: 0 PID: 40308 Comm: iptables-nft-re Tainted: G             L      6.18.0-rc6+ #1 PREEMPT(none) 
 Tainted: [L]=SOFTLOCKUP
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 08/23/2024
 RIP: 0010:nft_match_validate+0xa/0xd0 [nft_compat]
 Code: 91 f5 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 <48> 89 e5 41 56 41 55 41 54 53 48 8b 06 48 89 fb 4c 8b a8 80 00 00
 RSP: 0018:ffffd11885ef3138 EFLAGS: 00000286
 RAX: ffff89bc4bd909c0 RBX: ffffd11885ef3360 RCX: ffffffffc07f33c0
 RDX: 0000000000000002 RSI: ffff89bc474633a0 RDI: ffffd11885ef3360
 RBP: ffffd11885ef3170 R08: 0000000000000000 R09: 000000000003abc8
 R10: 000000000000000b R11: 0000000000000003 R12: ffff89bc47463300
 R13: ffff89bc474633e0 R14: ffff89bc308e8310 R15: ffff89bc474633a0
 FS:  00007231af246080(0000) GS:ffff89bef77f5000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007231af140000 CR3: 000000022fea0000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  ? nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_table_validate+0x6b/0xb0 [nf_tables]
  nf_tables_validate+0x8b/0xa0 [nf_tables]
  nf_tables_commit+0x1df/0x1eb0 [nf_tables]
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? kvfree+0x31/0x40
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? nf_tables_newrule+0x9e2/0xc70 [nf_tables]
  nfnetlink_rcv_batch+0x2b0/0x9d0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __nla_validate_parse+0x5a/0xcd0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? apparmor_capable+0xbb/0x1a0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? security_capable+0x82/0x190
  nfnetlink_rcv+0x120/0x160
  netlink_unicast+0x282/0x3d0
  ? __build_skb+0x52/0x60
  netlink_sendmsg+0x20c/0x440
  ____sys_sendmsg+0x35f/0x390
  ? srso_alias_return_thunk+0x5/0xfbef5
  ___sys_sendmsg+0x85/0xd0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? apparmor_capable+0xbb/0x1a0
  __sys_sendmsg+0x77/0xe0
  __x64_sys_sendmsg+0x21/0x30
  x64_sys_call+0x1b5f/0x20f0
  do_syscall_64+0x72/0x7c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? audit_reset_context+0x24a/0x320
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __audit_syscall_exit+0xbf/0x100
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? syscall_exit_work+0x120/0x160
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x1eb/0x7c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? apparmor_capable+0xbb/0x1a0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? security_capable+0x82/0x190
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? _raw_spin_unlock_bh+0x21/0x30
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? release_sock+0x91/0xb0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? sk_setsockopt+0x1ac/0x17b0
  ? aa_sk_perm+0x99/0x220
  ? _raw_spin_lock_irq+0x1/0x40
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? audit_reset_context+0x24a/0x320
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __audit_syscall_exit+0xbf/0x100
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? syscall_exit_work+0x120/0x160
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x1eb/0x7c0
  ? handle_mm_fault+0xc0/0x300
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_user_addr_fault+0x205/0x6c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? irqentry_exit+0x3f/0x50
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? exc_page_fault+0x7f/0x170
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7231af373034
 Code: 15 e9 6d 0d 00 f7 d8 64 89 02 b8 ff ff ff ff eb bf 0f 1f 44 00 00 f3 0f 1e fa 80 3d 15 f0 0d 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
 RSP: 002b:00007ffeec7cf3b8 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 00007ffeec7d3f60 RCX: 00007231af373034
 RDX: 0000000000000000 RSI: 00007ffeec7d0460 RDI: 0000000000000003
 RBP: 00007ffeec7d0a60 R08: 0000000000000004 R09: 00007231af4e8440
 R10: 00007ffeec7d044c R11: 0000000000000202 R12: 00000000006a7000
 R13: 00007ffeec7cf3c0 R14: 0000000000000001 R15: 00007ffeec7cf3d0
  </TASK>

Trace #3:
 watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [iptables-restor:54374]
 Modules linked in: ipt_REJECT nf_reject_ipv4 xt_REDIRECT xt_connmark ip_set_hash_ipport ip_set_hash_net ip_set_list_set xt_statistic xt_nfacct nfnetlink_acct xt_mark xt_MASQUERADE xt_addrtype xt_nat xt_set ip_set_hash_ip ip_set xt_comment tls mptcp_diag xsk_diag vsock_diag tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag nf_conntrack_netlink nft_masq nft_nat nft_fib_ipv4 nft_fib nft_chain_nat cfg80211 8021q garp mrp binfmt_misc xt_conntrack xt_owner nft_compat nf_tables mlx5_ib ib_uverbs ib_core mlx5_core mousedev intel_rapl_msr hid_generic mlxfw intel_rapl_common hid_hyperv hyperv_fb evdev hid sch_fq_codel dm_multipath nf_nat ebt_ip nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc fuse drm dmi_sysfs autofs4
 CPU: 0 UID: 0 PID: 54374 Comm: iptables-restor Tainted: G             L      6.18.0-rc6+ #1 PREEMPT(none) 
 Tainted: [L]=SOFTLOCKUP
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 08/23/2024
 RIP: 0010:nft_immediate_validate+0x4/0x50 [nf_tables]
 Code: b6 56 19 0f b6 f0 48 89 e5 e8 98 34 fe ff 31 c0 5d e9 eb eb 45 f5 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <0f> 1f 44 00 00 80 7e 18 00 75 0b 8b 46 08 83 c0 04 83 f8 01 76 07
 RSP: 0018:ffffd118889b3260 EFLAGS: 00000286
 RAX: ffffffffc0aac6e0 RBX: ffffd118889b3480 RCX: ffffffffc0ca5530
 RDX: 0000000000000002 RSI: ffff89bc532966f8 RDI: ffffd118889b3480
 RBP: ffffd118889b3290 R08: 0000000000000000 R09: 000000000003abc8
 R10: 000000000000000b R11: 0000000000000003 R12: ffff89bc53296600
 R13: ffff89bc53296718 R14: ffff89bc528ec390 R15: ffff89bc532966f8
 FS:  000073e411a74040(0000) GS:ffff89bef77f5000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000073e410d42002 CR3: 000000022fe1e000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  ? nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_table_validate+0x6b/0xb0 [nf_tables]
  nf_tables_validate+0x8b/0xa0 [nf_tables]
  nf_tables_commit+0x1df/0x1eb0 [nf_tables]
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? kvfree+0x31/0x40
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? nf_tables_newrule+0x9e2/0xc70 [nf_tables]
  nfnetlink_rcv_batch+0x2b0/0x9d0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __nla_validate_parse+0x5a/0xcd0
  ? sysvec_hyperv_stimer0+0x93/0xa0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? security_capable+0x82/0x190
  nfnetlink_rcv+0x120/0x160
  netlink_unicast+0x282/0x3d0
  netlink_sendmsg+0x20c/0x440
  ____sys_sendmsg+0x35f/0x390
  ? srso_alias_return_thunk+0x5/0xfbef5
  ___sys_sendmsg+0x85/0xd0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? audit_reset_context+0x24a/0x320
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __audit_syscall_exit+0xbf/0x100
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? syscall_exit_work+0x120/0x160
  ? do_syscall_64+0x1eb/0x7c0
  __sys_sendmsg+0x77/0xe0
  ? __entry_text_end+0xdb76/0x101c79
  __x64_sys_sendmsg+0x21/0x30
  x64_sys_call+0x1b5f/0x20f0
  do_syscall_64+0x72/0x7c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __alloc_frozen_pages_noprof+0x165/0x330
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? mod_memcg_lruvec_state+0xc6/0x1d0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __lruvec_stat_mod_folio+0x8f/0xe0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? set_ptes.isra.0+0x3b/0x80
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? _raw_spin_unlock+0x12/0x30
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_anonymous_page+0x111/0x880
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? ___pte_offset_map+0x20/0x160
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __handle_mm_fault+0xae2/0xfb0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? count_memcg_events+0xbd/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? handle_mm_fault+0xc0/0x300
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_user_addr_fault+0x205/0x6c0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? irqentry_exit+0x3f/0x50
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? exc_page_fault+0x7f/0x170
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x73e411b7fbc0
 Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 80 3d 21 fa 0c 00 00 74 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
 RSP: 002b:00007fffec444358 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 00007fffec448fb0 RCX: 000073e411b7fbc0
 RDX: 0000000000000000 RSI: 00007fffec445460 RDI: 0000000000000003
 RBP: 00007fffec445ae0 R08: 0000000000000004 R09: 0000000000000000
 R10: 00007fffec44544c R11: 0000000000000202 R12: 0000000004a1d000
 R13: 00007fffec448fd8 R14: 0000000000000007 R15: 00007fffec444360
  </TASK>
