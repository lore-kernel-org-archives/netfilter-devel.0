Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACF1181
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 00:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718755882; cv=none; b=SoLbbi+g5ifBA4waHnyV0O75rb+w48xuIJ0QakgK7RLqXKI8yrsqT9A7yAHXvFZuv4zQ8DeMiMAuO8kLboVz7W305QM42wLf/NGQIrFneN6Y9dRXbgb/Hf+v6Eg5H/to1Lj6/VFnFQEq4q8/blzU+0eXKt1urxWKyGHXhOEB2tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718755882; c=relaxed/simple;
	bh=zUk4PJQj040+altTZQi2P9xGOdiRD/LpLPND1/EIfQE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Se6NnpUNZj6zItNrEteKht5fwFpL7G1N0mihSPNIih4NPWsKqmweml1TZbHnQ3YCy/fH0vCFe1gul+/oYSXSt0BqNtQ3U5NglY5Nszkb1hTlaS9Cmig4SMErDTAAGQWL5vCyiPjIJ3PmPWDBXjQ7oRkbTFaGCwgvc72rYrGDziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7eb84511dbfso732572939f.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 17:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718755880; x=1719360680;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXevxKNM8dWqLihLY7avM1/no8pefWJwTC3rupvj+TI=;
        b=IIOhF/egr7NRSqOs1X4sQdAybmBNORqgkrLo6uXZT67d3Gn5x0b0t1DIdU82cdseYr
         5ls1/rMlRE4zuhtzpZPVHpB9BQabJHydnjn5wy7TPVpQtyb/opTKKRbVdlUTYx2zyV9D
         D+OF0QAnY7KYyobBRVbVh7RvhhcPmnsPVzXNSRSqQfgsqNaiZfcTq+L3kxWiBRt+H2C8
         R7YXT3CcToy3TxZI9qkKN8mYaPfhuFfCKtZUlDEeBGSF+xfhacIgNCQgkesmyEKE0SS2
         2lNgVsskVUlLWIkXNXhl02LbNHd6f16OnLXtlfd9djF48GsduuCWtVPtVmzQxYcBwcmA
         NSGg==
X-Forwarded-Encrypted: i=1; AJvYcCXXmU9iPrTJYezcCaNODXmlBb3ecEWyx5aIzQG+bG6/gPVzjJYeTlaBVFlRkh1GibzqDWlYf+vuraJ1hp9JVRwnhkjiJ0F2qIxJxo37reJK
X-Gm-Message-State: AOJu0YxJnab6F2q7SQydFGmGaDGVAlk7+LGEUaStPM4Fm3Vx98YTKU06
	hvMqPUbgD8i1iurds1BOPsX+TQ/W8/QIBTK1HYIuXliw7Aabc3FR2VL/JvSPYA34gYPNn2bTBqW
	JkZJUfIUOyOW4lLbbYHFzXoK27/t4BmQJaW5m3Cyd0XsD4c6XIZB8sAE=
X-Google-Smtp-Source: AGHT+IFHaOVDQCA7cLz/diVjEC310AujbXQfgMqkJKgZXogK4WkdNQ3r+IwuHk/Nn//3yAdo/EWp8nQiCEwifxVbQ02O5y7z2sMT
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:890c:b0:4b9:ad20:521d with SMTP id
 8926c6da1cb9f-4b9ad205468mr30266173.1.1718755880145; Tue, 18 Jun 2024
 17:11:20 -0700 (PDT)
Date: Tue, 18 Jun 2024 17:11:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b123a6061b33099c@google.com>
Subject: [syzbot] [netfilter?] net-next test error: WARNING: suspicious RCU
 usage in corrupted
From: syzbot <syzbot+6c048081aec46ad4ddf5@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4314175af496 Merge branch 'net-smc-IPPROTO_SMC'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14f4852e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7266aeba025a54a4
dashboard link: https://syzkaller.appspot.com/bug?extid=6c048081aec46ad4ddf5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/48b3722e2009/disk-4314175a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2297abec79e7/vmlinux-4314175a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1e99b4419b68/bzImage-4314175a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6c048081aec46ad4ddf5@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.10.0-rc3-syzkaller-00696-g4314175af496 #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_core.c:1200 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/u8:3/51:
 #0: ffff888015edd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015edd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90000bb7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90000bb7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8f5db650 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594

stack backtrace:
CPU: 0 PID: 51 Comm


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
