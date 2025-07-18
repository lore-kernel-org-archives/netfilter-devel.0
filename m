Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CF3299947
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Jul 2025 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752831298; cv=none; b=uMTYo/Rf/rZgSXzn4PMKoGJlYaxMMJCQTkJlhiBPd0qt2+Me980jswQZvxHTuwxmBYfEx5tx5NmniS2wppLSigiBCm2iyr3z+3EXSNINBRtWb3FcWV/3fty5IlsnCRx0L5cjVe+v3oveDzt3tAUWL+H2J31N0BaIf04+VwdvoiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752831298; c=relaxed/simple;
	bh=In76ejbVsnJ3DYl/H7NOvQXz0Kiuui/zYgJE/SJL1hw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SDQAODrs7UliY9Cmw3P9Z8iceVCPCeRWy/EvetZ+zYX26s87SeTsZtfh7b+iiEJTUy7CXJtOkIWtMksD45AT24pNEAtmZbq4s/v+MD70G3dWQNeqRHm5DM8AdxpzcmKs3p9rehJZRj6WdfzlOL+zvCSgoh67NQGIt0uVFZ9GBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x6rjaCNC; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x6rjaCNC"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso1871450a12.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Jul 2025 02:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752831296; x=1753436096; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEUXanSk/lXqWOUTPRN6hrJkEQ1TUmjVhyKGJodxo8A=;
        b=x6rjaCNC7xM6RBMnZV69BsCbfvAlA5t5mMVcBCrdoukq02IamehM0pejclkhfy2leV
         /vHacfP6nAGo+M2G+c3Cq9k1Og7PSOFh6Yrm21OVWhX8t1ZiwPBe1CMb7UpoMSdykvRJ
         f4BKkcgkJI4VGn5mGhLYSPizUeHGieP+BbRD2ieC5CtMBHcG/RKcQ0A8vWMLFNbkINj8
         v20Fma7w6YhZv/PvN3HmfIKRomYn6dONghkqP5tdlbkthto5BNl2sjXvea+w/XxVD0bD
         q5PRnTlK1K3t4Vy02lNcbjj3xxeFwoO4l/uCZkzj+l5d/DhJ6W61FcbPvvEh1Qy3hsXU
         nicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752831296; x=1753436096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEUXanSk/lXqWOUTPRN6hrJkEQ1TUmjVhyKGJodxo8A=;
        b=cZn4D41n/yxDEBIdbV/wDN1Kbekls/U9rj1lsN1I8gLyfqYEElTzUn+C4VtmZ3H3wp
         qI8ZKXcOEfnI0/JxcTtYnYhx5AYs10pm7eoehGUs5TB/jgc9M4yUwoDa/iazLfq0WXT8
         UX51GlPP5QYB19fWOGjbekyvLb2se08+XO4qNUZtsr/hWdHnb7YYMbMy/K6kqAHZgmaz
         4NNyoWUQpwhFdIepjokTaRlXTYavUlajn+u9exslswYcSBjlEs5ttAu1II6L/qhp/rk4
         PEYpJGlwzWCOKMvp8kENRaTSmh2QpIcgd9+R6QGID1u58grthNwHhzs/Nov+OR3xJCrb
         jj/g==
X-Forwarded-Encrypted: i=1; AJvYcCVrR/36A60MMwEqiePDmfx11riGMMvhl8ZU0wvE2Sf/PMVBgopPCtW2U6xepDTXxdBtmNK3QlrT52c3zoey83Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ex6S4z06VIHTrbu/2VOe5s1FsLHQeypA/PK9DoyTVnNoMz7T
	IQdVQdnoMvjWjEuPntfkPgP18uB/bR5ZhJJXgjdLokq6GhL8rE1XFTnX4t4v6IynPTEhubz/w6c
	D14AARdxuXQVJEGXf3uqoYWudKOwvV0UGw2rz2AcTmvJuIuG77lWl0NT5
X-Gm-Gg: ASbGncv3kb41pLdaGez501KWJzwGvlOIM3Ok0coYpPz16XvfhyBUy1o+3h6bp/Kz7Dw
	uumzNP2s8sMZH+kRB2jXrRsHI2krZLawX2YLECtLFvpr25PJJ5c3N2ExropYGKD5TFqCvQR5fbv
	zNLEsp1gJV7U1gL5GCRpwn9rh+nwNP/SiyXzaoZQBy7ERHOLvpIEk8/HHoE04xDT0Px0tohLTHz
	HNqSKHm3m7eaT5v1CczRNRD6GEDFvYaDCV1OXJ8OnyZyXAF
X-Google-Smtp-Source: AGHT+IFKqB6DXXguCrI/TmVaiHLkF77aJUkDw44S18s+xh9LVJhxl44Lj5LU50yzjWHxoc80DqN94Gh4MFkk2XfFYog=
X-Received: by 2002:a17:90b:4a4a:b0:312:db8:dbd1 with SMTP id
 98e67ed59e1d1-31c9f398d51mr11321563a91.5.1752831295512; Fri, 18 Jul 2025
 02:34:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68799e14.a00a0220.3af5df.0025.GAE@google.com>
In-Reply-To: <68799e14.a00a0220.3af5df.0025.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 18 Jul 2025 11:34:43 +0200
X-Gm-Features: Ac12FXzL206M1MgBb_pbelQCObIF7YNmgHUJNlHPEEBtiKipG293LSvBZQCgOaU
Message-ID: <CANp29Y4Y=az02pTZpCRVbz-d2v3cebwfm6V_MitKWgeZxxZwwQ@mail.gmail.com>
Subject: Re: [syzbot] [netfilter?] KASAN: slab-out-of-bounds Read in nfacct_mt_checkentry
To: syzbot <syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 18, 2025 at 3:06=E2=80=AFAM syzbot
<syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5d5d62298b8b Merge tag 'x86_urgent_for_v6.16_rc6' of git:=
/..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D1655418c58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db309c907eaab2=
9da
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4ff165b9251e4d2=
95690
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D156787d4580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D136787d458000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/621a2e2bbe6e/dis=
k-5d5d6229.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1822022cd8cb/vmlinu=
x-5d5d6229.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/10cee653a6cd/b=
zImage-5d5d6229.xz
>
> The issue was bisected to:
>
> commit 6001a930ce0378b62210d4f83583fc88a903d89d
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Mon Feb 15 11:28:07 2021 +0000
>
>     netfilter: nftables: introduce table ownership
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D133e518c58=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D10be518c58=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D173e518c58000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in string_nocheck lib/vsprintf.c:639 [inli=
ne]
> BUG: KASAN: slab-out-of-bounds in string+0x231/0x2b0 lib/vsprintf.c:721
> Read of size 1 at addr ffff88801eac95c8 by task syz-executor183/5851
>
> CPU: 0 UID: 0 PID: 5851 Comm: syz-executor183 Not tainted 6.16.0-rc5-syzk=
aller-00276-g5d5d62298b8b #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 05/07/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x230 mm/kasan/report.c:480
>  kasan_report+0x118/0x150 mm/kasan/report.c:593
>  string_nocheck lib/vsprintf.c:639 [inline]
>  string+0x231/0x2b0 lib/vsprintf.c:721
>  vsnprintf+0x739/0xf00 lib/vsprintf.c:2874
>  vprintk_store+0x3c7/0xd00 kernel/printk/printk.c:2279
>  vprintk_emit+0x21e/0x7a0 kernel/printk/printk.c:2426
>  _printk+0xcf/0x120 kernel/printk/printk.c:2475
>  nfacct_mt_checkentry+0xd2/0xe0 net/netfilter/xt_nfacct.c:41
>  xt_check_match+0x3d1/0xab0 net/netfilter/x_tables.c:523
>  __nft_match_init+0x63a/0x840 net/netfilter/nft_compat.c:520
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3493 [inline]
>  nf_tables_newrule+0x178c/0x2890 net/netfilter/nf_tables_api.c:4324
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:525 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:648 [inline]
>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:666
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x759/0x8e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:712 [inline]
>  __sock_sendmsg+0x219/0x270 net/socket.c:727
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2566
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
>  __sys_sendmsg net/socket.c:2652 [inline]
>  __do_sys_sendmsg net/socket.c:2657 [inline]
>  __se_sys_sendmsg net/socket.c:2655 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa7bbf1c6a9
> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff7139c908 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fff7139cad8 RCX: 00007fa7bbf1c6a9
> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007fa7bbf8f610 R08: 0000000000000002 R09: 00007fff7139cad8
> R10: 0000000000000009 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fff7139cac8 R14: 0000000000000001 R15: 0000000000000001
>  </TASK>
>
> Allocated by task 5851:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4328 [inline]
>  __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4340
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  nf_tables_newrule+0x1506/0x2890 net/netfilter/nf_tables_api.c:4306
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:525 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:648 [inline]
>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:666
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x759/0x8e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:712 [inline]
>  __sock_sendmsg+0x219/0x270 net/socket.c:727
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2566
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
>  __sys_sendmsg net/socket.c:2652 [inline]
>  __do_sys_sendmsg net/socket.c:2657 [inline]
>  __se_sys_sendmsg net/socket.c:2655 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88801eac9580
>  which belongs to the cache kmalloc-cg-96 of size 96
> The buggy address is located 0 bytes to the right of
>  allocated 72-byte region [ffff88801eac9580, ffff88801eac95c8)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1eac=
9
> flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000000 ffff88801a449640 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0=
), ts 2776913905, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
>  prep_new_page mm/page_alloc.c:1712 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>  alloc_slab_page mm/slub.c:2451 [inline]
>  allocate_slab+0x8a/0x3b0 mm/slub.c:2619
>  new_slab mm/slub.c:2673 [inline]
>  ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
>  __slab_alloc mm/slub.c:3949 [inline]
>  __slab_alloc_node mm/slub.c:4024 [inline]
>  slab_alloc_node mm/slub.c:4185 [inline]
>  __do_kmalloc_node mm/slub.c:4327 [inline]
>  __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4340
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  __register_sysctl_table+0x72/0x1340 fs/proc/proc_sysctl.c:1380
>  user_namespace_sysctl_init+0x25/0x150 kernel/ucount.c:355
>  do_one_initcall+0x233/0x820 init/main.c:1274
>  do_initcall_level+0x137/0x1f0 init/main.c:1336
>  do_initcalls+0x69/0xd0 init/main.c:1352
>  kernel_init_freeable+0x3d9/0x570 init/main.c:1584
>  kernel_init+0x1d/0x1d0 init/main.c:1474
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88801eac9480: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>  ffff88801eac9500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> >ffff88801eac9580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>                                               ^
>  ffff88801eac9600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88801eac9680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/68799e14.a00a0220.3af5df.0025.GAE%40google.com.
