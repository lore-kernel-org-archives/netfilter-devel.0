Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687491;
	b=k8iljZ+07PoVJOL5M5vGNfzhmOHJ/45P8Ku07RlXGY6tcvsiY9l2FZ8lJXpWfyV8ECVZ
	 /QqWGZg5l9v86oQx7WDZAw5/Srwfy53s4VEA+mLDztVc1vtOFLlV+vRdcDneUA5KP27gv
	 m3GD90uiTcZWqe4nYQx3Xhu/yxN0+eRYaTJq8qgv4pHsy6ea6eUGqduBx461X4+G2Z3Oz
	 bPncz+HC/tqjpSRxqsYemK3Tj4PsZgE0saZPxLdZaWiwepBC063okDz3WCZ71wYxs+xZt
	 is3RWl/kX1Qej4a9kLnN0khL6jRMqCfU5I+G8i1LDz2wAaJploIQsTSPNSj2Jfk+rrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687491;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=vkgH7/1CsUWpFerkD8pe7z4GSs6lcDLx7Deh/tAsIzI=;
	b=qxGu9PWTbcabknwwj6JFREPtyRu3ISb5vSyUgGNv3wDihKkZY6vn7+Zondog0NQyRYHW
	 92oMe0zd2RJVIQHJeQRXSP4RhRUe+BYvArO+EjpS+w/t7Cm6XrflLb8a4mvEjFGiXEeBs
	 B5pmiN4crSB9wVXk1vHgwzA5NIYlepu3x/9Nh7xXwPIatAupPMNRpbVBuouhSkV7gpSKG
	 MlJwuLvXxOA1pqP84S+2JEKBo8Ad0gnPNBB62icIin5dplZtY1XvSNJN835NguyDwWadM
	 oQai5GG9kxdfGQnMlxIxx9SQKODvKbrUSxb/tGD/oYcZavPpfVs+RGNCzTyIw7I53Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAEA606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 16:44:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FAEA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-843c6807307so2976185a34.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 09:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687490; x=1793292290;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vkgH7/1CsUWpFerkD8pe7z4GSs6lcDLx7Deh/tAsIzI=;
        b=zqJ0qc9Ap4/hI7WZfbmGbWVlAX5Xfbn1yAh511KQUDXuP1h6rr1Y77evwx9tg19k0g
         Q+Ub1QvSO9iSwqOU++/D2/ob/aDD+mY3KXy664/RDu9gxSc+gSipocucyD7d5QASpkS3
         9n7WieepTLMRZPwvhUOcvhTHYeWfPlOOurAkS7rGwle6sk7A36DyQAdok4cjjvlniLnD
         zEYQjssbL5keHH+YIaukaRPlMedZSDFl+cXJw1zXRtKEr4FW0/IbEj0ge9onzPu8DgWS
         yJbjCyB4FLIOH0Yli9FKb9de/1KBy2L2wBiuph5uKducySGf2qfKo2/+D76/0Tapt8oY
         mU+w==
X-Forwarded-Encrypted: i=1; AKwUvBzvK1O7AyIBjz5nUOitsfE6ir2CewYBJeL+ORyd8RJZ4u8UKAK6UEfjzA1r+AanFPwmyggM1XteRpe58pyVYs0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIBsB4zXKTvrCOkYjGvXamaQBrabc+nuugDwFQCpjpi2QDiltLF
	EsqOTmhihH/SsE7CafrIr+mwEqNigNtwfUttuiQvB1CtvD4gpLTS7G99BxNMQFJtrjEZLjwSbEG
	fLj4+HISdXbv1z1CgM8bYtvzNL86eKSVx5TKwUpJFXGXYQV2Xk0i8jSybju8=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:150a:b0:52b:7641:33a6 with SMTP id
 5614622812f47-5535a66d1d5mr4259216b6e.14.1792687490640; Thu, 22 Oct 2026
 09:44:50 -0700 (PDT)
Date: Thu, 22 Oct 2026 09:44:50 -0700
In-Reply-To: <6aa9c7f8.a211d2ce.1a5198.02b5.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ada3d82.d1c214cc.659fa.00db.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nf_flow_table_extend_ct_timeout
From: syzbot <syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	edumazet@kernel.org, fw@strlen.de, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, mike.michalo@gmail.com, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    abeacca61eea Merge branch 'net-mlx5-hws-fix-modify-header-..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=111f4d0d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b098695335c89f
dashboard link: https://syzkaller.appspot.com/bug?extid=521f7e7e2b974abde99a
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1491e029580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157d410d580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/22930d0e9391/disk-abeacca6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d2e18d51f288/vmlinux-abeacca6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/69879bb16225/bzImage-abeacca6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_table_extend_ct_timeout+0x1ee/0x2f0 net/netfilter/nf_flow_table_core.c:553, CPU#1: kworker/1:2/123
Modules linked in:
CPU: 1 UID: 0 PID: 123 Comm: kworker/1:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Workqueue: events_power_efficient nf_flow_offload_work_gc
RIP: 0010:nf_flow_table_extend_ct_timeout+0x1ee/0x2f0 net/netfilter/nf_flow_table_core.c:553
Code: 00 00 00 41 83 ff 06 0f 84 9a 00 00 00 41 83 ff 05 0f 85 b0 00 00 00 e8 e0 10 a9 f7 41 bf 30 75 00 00 eb 0f e8 d3 10 a9 f7 90 <0f> 0b 90 41 bf 01 00 00 00 48 c7 c0 80 f2 a0 8f 48 c1 e8 03 42 80
RSP: 0018:ffffc90002dcf930 EFLAGS: 00010293
RAX: ffffffff8a1effad RBX: ffff888027a52900 RCX: ffff88801ffa1f40
RDX: 0000000000000000 RSI: ffffffff912fa640 RDI: 000000000000002f
RBP: 0000000000000737 R08: ffff88801ffa1f40 R09: 0000000000000002
R10: 0000000000000011 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff11004f4a538 R14: ffff888027a52948 R15: 000000000000002f
FS:  0000000000000000(0000) GS:ffff888123bbd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f926bd5bd3c CR3: 000000000fb48000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_flow_offload_gc_step+0x5aa/0x840 net/netfilter/nf_flow_table_core.c:593
 nf_flow_table_iterate+0x13c/0x1f0 net/netfilter/nf_flow_table_core.c:459
 nf_flow_table_gc_run net/netfilter/nf_flow_table_core.c:616 [inline]
 nf_flow_offload_work_gc+0x22/0x70 net/netfilter/nf_flow_table_core.c:624
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
