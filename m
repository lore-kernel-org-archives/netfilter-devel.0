Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456EC469820
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168526; cv=none; b=NQwklK4sRJWtvJ28e9t2+B/eHs5t5fjfd/jx0bXjQWcthd76AWbUnmI769csGC//7Ej1ZF40ko3sW8chpRzWiG8DTOoLIUHLfB/0GfYeoIrsZWriSJnCVKq9/uo9Gty0qBTQBP8Mgpw4qI9dw7Q0t04g9QcDS03ODTZq5A0R+tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168526; c=relaxed/simple;
	bh=49RE9ZySiM0hlB2dXMyMC/WqyJvQW5XHQp1rycm7IPQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=CWfDnWk8mxsxDBq6s++HuqLNe223GEFFqOsjHKnq/SwjKXvMT2R+Il50R3Tsu+kmprodkip0uk/VUn/YMei/yuoH2BD7ZJcReJCAu42Wu4VPFsNyOtAhhetulmCIq6+OC+YCLYvqtrzhbKGEj9T9F01QiCTmuIDlBEsyLcagRo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b2f2b8d88fso246926b6e.2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 09:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792168524; x=1792773324;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mv0fThH5KPgHw7GdolyIZp4u+8Y4tu3XyuKFX7LGIt0=;
        b=FXtv9hT4vjUISQCW9GaRNwXqmRWkC5RZbrriHhYTvY8brUFwEPt4sjfUbHrCiGVEq1
         xfZ6hEZJ8H+SNNdtOilSoHYER7CczQ6vydcO/B0PYcp0EiX43j5WAgCOJhLjFkTiH9FD
         Yl53OTaSfo3f5dpkqbFHeiY8y/cIZf/xdPbaPl5WZQ5+AYO4VvaacLKzliuVuQo89rL+
         Fg+ya1P85DFHtOscucNLnbqqUTikOEMZ/0z/f3Ji2ZXawI/ArptWntx6MwtEBsqxlDZ+
         pe/65Df5haVTAAjmV8Gqr1+A+lwkWOXp7eqjUvLkhd+ySLifYe7k9sHMCGLS13fQVCq+
         bXAg==
X-Gm-Message-State: AFq9FYLTetHKvMS0CjBFlqyXz5InaGvd1TbkKBTTfdiRqZQscUe77Nq7
	h2DqIwA6ZE+035s09LcTA/d5FyKy7XZKAbaF4Of/UoT6sQvLU4iw0vPC5dbpOU4997m0da18QHm
	hnzvoGdJLq+wzSh/blHyAODGRb1HyEgX0RDiKmZyb7VFLYleBgy3sLLB0e0g=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3501:b0:4cb:f21c:a794 with SMTP id
 5614622812f47-53cd0565b15mr139743b6e.28.1792168524004; Fri, 16 Oct 2026
 09:35:24 -0700 (PDT)
Date: Fri, 16 Oct 2026 09:35:23 -0700
In-Reply-To: <20261016085202.1670076-1-pablo@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad2524b.7952420f.283480.034b.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: flowtable: do not hw offload flows in
 teardown state
From: syzbot ci <syzbot+ci7bb2fa863bfbfbe4@syzkaller.appspotmail.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: do not hw offload flows in teardown state
https://lore.kernel.org/all/20261016085202.1670076-1-pablo@netfilter.org
* [PATCH nf-next] netfilter: flowtable: do not hw offload flows in teardown state

and found the following issue:
WARNING in nf_conntrack_cleanup_net_list

Full report is available here:
https://ci.syzbot.org/series/ea5f346a-b1ba-462a-a812-0b29a292b49e

***

WARNING in nf_conntrack_cleanup_net_list

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      a5e7d8e446af9803e37a3b6a4d416fb41178348f
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/90f3437c-11cd-439b-8d1a-bb938b62b48e/config

------------[ cut here ]------------
conntrack cleanup blocked for 60s
WARNING: net/netfilter/nf_conntrack_core.c:2504 at nf_conntrack_cleanup_net_list+0x21f/0x360, CPU#0: kworker/u8:0/12
Modules linked in:
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nf_conntrack_cleanup_net_list+0x21f/0x360
Code: 4c 89 ef e8 63 bd 37 f8 4d 8b 7d 00 4d 39 ef 74 69 e8 f5 eb c6 f7 45 31 e4 e9 a5 fe ff ff e8 e8 eb c6 f7 48 8d 3d 41 56 88 07 <67> 48 0f b9 3a eb c0 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c da fe ff
RSP: 0018:ffffc900001178b0 EFLAGS: 00010293
RAX: ffffffff8a011228 RBX: dffffc0000000000 RCX: ffff888102eb8000
RDX: 0000000000000000 RSI: ffffffffffffffc9 RDI: ffffffff91896870
RBP: 0000000000000021 R08: ffff888116ce7c03 R09: 1ffff11022d9cf80
R10: dffffc0000000000 R11: ffffed1022d9cf81 R12: 000000010002f152
R13: ffffc90000117a50 R14: ffffc90000117a50 R15: 000000010002f189
FS:  0000000000000000(0000) GS:ffff88818c4d4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6e7bd28ae0 CR3: 00000000132ca000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ops_undo_list+0x4b4/0x8d0
 cleanup_net+0x572/0x810
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
