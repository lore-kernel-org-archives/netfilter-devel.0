Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820CE25634
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2024 18:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719599903; cv=none; b=J4ht9FU5RBf/2aTH9+PaS5fhph5CbvuQgEL6W8ig5fADMP6Lc7sh50ZaOBg7yIyd7RqhG0c2AblEai1MmhTOMgRfeDJRtRVaF7CSTP6zNwYHzZuQ5fO9qIFWQYcAXu1qOXXyovvt5dAyxwh/+tP7ZUDj1fHzbwFNr1XmE5R4lss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719599903; c=relaxed/simple;
	bh=WAgvqGSSMUhPpGWuEaYRvYoyRrVFQyKjhyHF8lm3m3s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b/xjaEzCN7lHf+nm0xX9XND5DW7ajKrq7o+Qqqo4Ui9oIiemSg47bDD27rdslO6D13RBzvp/7e20HS6eIAMn0PguWb2tl4L4nzkgRTCzyUOf5qjSABItOeNlMellaPoiMZ8oIzy8xLx7nz+FdtORUeTfZkGc6TSZGEKrGHjr/cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-376229f07a8so10477945ab.3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2024 11:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719599902; x=1720204702;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uAQwFq9UPZbXFZDZdCFdcQuDs/7IHMkcXpTnMEOHaSI=;
        b=N86voCct0uMNvyDQMJLJzVK5MWaAyUtEnieol3euuTZ3xmJlilUtpuqB3VUEGEg2ic
         SYU+WEpeUq5ek1FZhPu2ClL1xwvJyBxWHghQZM/WrKaj9Eq81EtZy++mRMEE6xv8Dppd
         uBmVu8ZYNmk6Q1yDw/zGeEG9rEjVlQrYveO3GLwY3seiqn5MG5BG6F6zmHFchOc+FWmU
         sW3Nglxr8JKvapsOT1NH+/CzyecYQw2iqPJbQHiyBm13perHxckHywAB2zgZ9o3W+tSB
         9jwrXZ6sKRR2DjaWyBwhlQbgy63ODnOWCDyaQ0UkOROtfoOKONYoNDDtrhlG9vlzfOrI
         lYoA==
X-Forwarded-Encrypted: i=1; AJvYcCUjUkUoMRA7SA591Ia5OMw1VNB9nNkXovavNFcsIjR/7MRrpzy2374wDVa/n48ElxUgq7cvsRTeBp8JxEldIkopSFNsOfxvgnd0bTKLa40F
X-Gm-Message-State: AOJu0YziwQztc2pQjLuqQrZ5FV4swgxYrMleiYaRhX6avKm1ecLFWuja
	K1kv4KT8GtqxJEldKIrZib4qnNV93bcDEg+ps5uZICWYAK5Bhn+r2ZStBUzX0lpbiekkhRWwk6c
	xEY0zDb/sk9dzhVMLyDuJyjRauo62W7qXL3raElzlTlGWGK4ZFLp73lw=
X-Google-Smtp-Source: AGHT+IFyojeDoOQfAz+WpFDP13ym2ekViaAZ2Ap6ROc1rvqVHqXy6e4NW0dc11phb0kwVSPqpMSaRAWLrRTi/u2q8ChreueD8oNh
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168a:b0:375:ae47:ba62 with SMTP id
 e9e14a558f8ab-3763f5c900emr15343485ab.1.1719599901745; Fri, 28 Jun 2024
 11:38:21 -0700 (PDT)
Date: Fri, 28 Jun 2024 11:38:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004cb7a6061bf78daf@google.com>
Subject: [syzbot] [netfilter?] bpf test error: WARNING: suspicious RCU usage
 in corrupted
From: syzbot <syzbot+784a3db26e5409459be4@syzkaller.appspotmail.com>
To: ast@kernel.org, coreteam@netfilter.org, daniel@iogearbox.net, 
	davem@davemloft.net, edumazet@google.com, kadlec@netfilter.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7e9f79428372 xdp: Remove WARN() from __xdp_reg_mem_model()
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=16956dea980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1437ab35b9d90e65
dashboard link: https://syzkaller.appspot.com/bug?extid=784a3db26e5409459be4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ca96920a98d8/disk-7e9f7942.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/24f81a5f5d0b/vmlinux-7e9f7942.xz
kernel image: https://storage.googleapis.com/syzbot-assets/31b888945299/bzImage-7e9f7942.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+784a3db26e5409459be4@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.10.0-rc3-syzkaller-00138-g7e9f79428372 #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_core.c:1200 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler


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
