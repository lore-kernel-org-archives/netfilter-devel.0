Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F152D6E58
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772904221; cv=none; b=NK73rWfH+WBvsqzn4y9BtWVmepRGjkMGbuuUZtrPxos1tS+XOfhFd+nhTvxD3hgpPkYG7Zfn9tUTQAM4QXIMJF+Xgoi6Z+sWdA1pTr/yJnUSRZW9q1E+ZP/Fa4NhHD+X6Ka3uTikXs219mJHaWgs9HtTuQrkU8oNYk2ydnwZGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772904221; c=relaxed/simple;
	bh=bUVC3M+9aS4TVdzn7DmF9lICYRcjnlu5CVNY3CpKDnk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gTILuiSTA5CSXvWtFybaDqemQO/WyauJ0MI3EovESlb6/pvCuW0p8F7qaDvXCzJBsoM6eIa5KmTZQ8C3ZEKzH9VFiXmBiNI4nL8XD5rd5vsDMrh6ERcOimnvegKZqfLe/uwzo2jIBcIYDaG+FxNoVEDvdVleSXvo/4wZz+mDSdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqY9ibEp; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqY9ibEp"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-829ac4670c4so888887b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 09:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772904220; x=1773509020; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bpS+2u0BYNH6Ov857wbhC+dWAxtUckh3pg1j/eSOHho=;
        b=HqY9ibEpDrsXKEQrcfTsdDyBqtKGKOso5flSVyXHvGT4/K0Grc8OMvj8imFBxLP5EZ
         ZUT84toFSFfgZF4IA6EkwVKBHgffT0z6+6a1aSl8s7ctK5qgXKLt8AVtehIBtAiriq4Q
         Vi2m8dRGBKVvW4AHU0hFeFPe1AFfFe0jIYoM9KYl5iQTfM0W7d75VJ/qTS1+VCAMbH+m
         3RSMTByN9Wla+2QpSDjdplCm1kKOBxLCavjuUnYBq50RFe4aw1Xzwb6OwjbvVQvnbC3n
         SmC/d+QNw5D1aUOuBV2S8mjUxmC7wS6+ymVIxPTJGsY54a1PbRh48V4txq8hJkjgHSQo
         T01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772904220; x=1773509020;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bpS+2u0BYNH6Ov857wbhC+dWAxtUckh3pg1j/eSOHho=;
        b=ZydpRrM53QALiin/hMLWo5I7Hio3eus/wWdkC6j5QJrxqQYAuPJjxbSXqFXYBhJikL
         PJKY8Z5iBazZ3r50VRe1EUyMc/vRwdBeK6SBW4EQL0rhm+LomtE584DvesBwQmi+bQ0X
         LETj2OAC3iPE0XDwIi6QouFM6IGzfffDPHWdecKF2tg8vx+nYneGiZCGxBHHbGsuZC8S
         eS5TjUmrKgbtk6G2YOS0i4L9xKJUOEzTSVe8db0vWkBPdhourDbskHbUvjShycMHw4aI
         Jpks65Bzr9PVLtdEgFJLEj431N1tyiY0QYBq6qgPRnhHSsq4073B37+SzjedX+feqAVd
         x66g==
X-Gm-Message-State: AOJu0Ywooo8HCj6mC/jwHmuG6a25+RaYjTsksW2+agcUiI8/50mWWU1g
	ynhsxm0HQEOrz9Wc2s+hGVTFVR2QrsR4TEWnvvZxpE+2x4Kht8ScA31HtRIM5Q==
X-Gm-Gg: ATEYQzxfmXS7DrJKRLihdCSwa0aGVNvCZ3D0SCJ5R//DstLZLS+XKKu4bo79wzAF5u4
	s664usjsPKZqoFr8el6aY63O+pIdcoDd9tqMLTyy7UKiKNCEqz4q0343dLu+DKovXguyWVl7ziU
	s8niH9UgtNybmDL7a3cArGtzKuqm0Nhk896eTu7uZlXat6HYs0S9OWtG23cmZT/MvMjEqhbhvoL
	aJuDNh2hdu7lgrYyUemzXn0un/NcBOaOdy6aHGCUy+oosSeMM9d7wNe/da+kU4c5ol89ci2xHyH
	LQxEMTjdu6NI2/OneJAHDL7fhdYoMZYQYjM7gEKr1DejZE4kpaex+O6y4PfJwuo6lwCIPKrvKEt
	BL5YAJ3CTCwVrJAEhEG1XUOPfQvQx0Ncv43cEBiCESdtZvSR7rvXuUEQQvcEIuD/RjpWFfs9D+f
	ixleflFvcB7PIt+munTSzGjnEynt1H8FnbZ6Y7d+bg7Q==
X-Received: by 2002:a05:6a00:928a:b0:827:3ed6:9122 with SMTP id d2e1a72fcca58-829a2f6ecd4mr4748015b3a.59.1772904219651;
        Sat, 07 Mar 2026 09:23:39 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48676besm4785780b3a.40.2026.03.07.09.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:23:38 -0800 (PST)
Date: Sun, 8 Mar 2026 02:23:34 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net] netfilter: nfnetlink_cthelper: fix OOB read in
 nfnl_cthelper_dump_table()
Message-ID: <aaxfFhPj1OrsPZu_@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

nfnl_cthelper_dump_table() has a 'goto restart' that jumps to a label
inside the for loop body.  When the "last" helper saved in cb->args[1]
is deleted between dump rounds, every entry fails the (cur != last)
check, so cb->args[1] is never cleared.  The for loop finishes with
cb->args[0] == nf_ct_helper_hsize, and the 'goto restart' jumps back
into the loop body bypassing the bounds check, causing an 8-byte
out-of-bounds read on nf_ct_helper_hash[nf_ct_helper_hsize].

The 'goto restart' block was meant to re-traverse the current bucket
when "last" is no longer found, but it was placed after the for loop
instead of inside it.  Move the block into the for loop body so that
the restart only occurs while cb->args[0] is still within bounds.

KASAN report:

[   42.143286] BUG: KASAN: slab-out-of-bounds in nfnl_cthelper_dump_table+0x9f/0x1b0
[   42.143545] Read of size 8 at addr ffff888104ca3000 by task poc_cthelper/131
[   42.143779]
[   42.143877] CPU: 0 UID: 0 PID: 131 Comm: poc_cthelper Not tainted 7.0.0-rc2+ #6 PREEMPTLAZY
[   42.143884] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   42.143887] Call Trace:
[   42.143892]  <TASK>
[   42.143893]  dump_stack_lvl+0x64/0x80
[   42.143909]  print_report+0xce/0x660
[   42.143923]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   42.143931]  ? __kmalloc_node_track_caller_noprof+0x2a5/0x590
[   42.143942]  ? __virt_addr_valid+0xef/0x1a0
[   42.143953]  ? nfnl_cthelper_dump_table+0x9f/0x1b0
[   42.143955]  kasan_report+0xce/0x100
[   42.143958]  ? nfnl_cthelper_dump_table+0x9f/0x1b0
[   42.143961]  nfnl_cthelper_dump_table+0x9f/0x1b0
[   42.143964]  netlink_dump+0x333/0x880
[   42.143971]  ? __pfx_netlink_dump+0x10/0x10
[   42.143974]  ? netlink_recvmsg+0x27c/0x4b0
[   42.143976]  ? kmem_cache_free+0x100/0x440
[   42.143978]  ? netlink_recvmsg+0x27c/0x4b0
[   42.143981]  netlink_recvmsg+0x3e2/0x4b0
[   42.143984]  ? aa_sk_perm+0x184/0x450
[   42.143995]  ? __pfx_netlink_recvmsg+0x10/0x10
[   42.143998]  ? __pfx_aa_sk_perm+0x10/0x10
[   42.144000]  ? mutex_unlock+0x80/0xd0
[   42.144003]  ? __pfx_netlink_recvmsg+0x10/0x10
[   42.144005]  sock_recvmsg+0xde/0xf0
[   42.144016]  __sys_recvfrom+0x150/0x200
[   42.144019]  ? __pfx___sys_recvfrom+0x10/0x10
[   42.144022]  ? ksys_write+0xe1/0x160
[   42.144026]  ? __pfx_ksys_write+0x10/0x10
[   42.144028]  __x64_sys_recvfrom+0x76/0x90
[   42.144030]  do_syscall_64+0xc3/0x6e0
[   42.144034]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   42.144039] RIP: 0033:0x42349d
[   42.144046] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d cd 0b 09 00 00 41 89 ca 74 20 45 31 c9 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6b c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
[   42.144048] RSP: 002b:00007ffc948602e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
[   42.144054] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000042349d
[   42.144056] RDX: 0000000000004000 RSI: 00007ffc94860320 RDI: 0000000000000004
[   42.144058] RBP: 00007ffc94864330 R08: 0000000000000000 R09: 0000000000000000
[   42.144059] R10: 0000000000000040 R11: 0000000000000246 R12: 00007ffc94864448
[   42.144060] R13: 00007ffc94864458 R14: 00000000004ae868 R15: 0000000000000001
[   42.144062]  </TASK>
[   42.144063]
[   42.150209] Allocated by task 1:
[   42.150307]  kasan_save_stack+0x33/0x60
[   42.150425]  kasan_save_track+0x14/0x30
[   42.150537]  __kasan_kmalloc+0x8f/0xa0
[   42.150651]  __kvmalloc_node_noprof+0x21b/0x700
[   42.150781]  nf_ct_alloc_hashtable+0x65/0xd0
[   42.150907]  nf_conntrack_helper_init+0x21/0x60
[   42.151040]  nf_conntrack_init_start+0x18d/0x300
[   42.151174]  nf_conntrack_standalone_init+0x12/0xc0
[   42.151327]  do_one_initcall+0xaf/0x320
[   42.151441]  kernel_init_freeable+0x2b6/0x4b0
[   42.151583]  kernel_init+0x1f/0x1e0
[   42.151695]  ret_from_fork+0x205/0x450
[   42.151810]  ret_from_fork_asm+0x1a/0x30
[   42.151927]
[   42.151977] The buggy address belongs to the object at ffff888104ca2000
[   42.151977]  which belongs to the cache kmalloc-4k of size 4096
[   42.152325] The buggy address is located 0 bytes to the right of
[   42.152325]  allocated 4096-byte region [ffff888104ca2000, ffff888104ca3000)
[   42.152697]
[   42.152746] The buggy address belongs to the physical page:
[   42.152908] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x104ca0
[   42.153139] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   42.153356] flags: 0x200000000000040(head|node=0|zone=2)
[   42.153514] page_type: f5(slab)
[   42.153617] raw: 0200000000000040 ffff888100042140 dead000000000122 0000000000000000
[   42.153835] raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
[   42.154052] head: 0200000000000040 ffff888100042140 dead000000000122 0000000000000000
[   42.154272] head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
[   42.154498] head: 0200000000000003 ffffea0004132801 00000000ffffffff 00000000ffffffff
[   42.154717] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
[   42.154933] page dumped because: kasan: bad access detected
[   42.155092]
[   42.155141] Memory state around the buggy address:
[   42.155278]  ffff888104ca2f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   42.155482]  ffff888104ca2f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   42.155684] >ffff888104ca3000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   42.155886]                    ^
[   42.155981]  ffff888104ca3080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   42.156183]  ffff888104ca3100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   42.156385] ==================================================================

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d658b1478fa0..d545fa459455 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -601,10 +601,10 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				goto out;
 			}
 		}
-	}
-	if (cb->args[1]) {
-		cb->args[1] = 0;
-		goto restart;
+		if (cb->args[1]) {
+			cb->args[1] = 0;
+			goto restart;
+		}
 	}
 out:
 	rcu_read_unlock();
-- 
2.43.0

