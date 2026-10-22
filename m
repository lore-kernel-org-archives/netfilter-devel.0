Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792688552;
	b=DR+LDaGJXc1YhpunmyJACNBb4FHrKcEH2v+i1Rl1gNhvhpNfs2qZBAaMilwla4nGYx7p
	 BrtcaU4pSgkXNDWjXjrNHzkgZg1CRF73vpb1lUggkN8YAgsR2ARCCNBjxDQr3ddUEvEwF
	 zMToi2z8H9Ej7wfh49UixsAlN2YoF8YzzXBblA7P0Sq3cKjw7qLj4u4dFFAO+eb60ln4W
	 Lnh4Z6dpgIz6/SoKdMK8FzyhXhYkG6p2egSBQlVqirLoj+C93b/YyYFl363WKaa3/8N/e
	 YbUKVlxx+KNe2nOPHA598BQqzxBlPSUoXF2u7M39Thiy2paZm598jSn/3Fv5xzdPcBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688552;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=kSWxRjaE/IbCSPMaNuU9AixW3+O1lzhb2zsYAgN97Mw=;
	b=VcVbjYfa26ZjeLKBgokv2HnfnNNKLbP33TLZ1AhViMA/8aPpbQ+i7/ZJnrimgelxw86p
	 GX/KvSIAZZnIGi/6Ei/6DeBINlAehSC39LfjRPpwSSOf77E8hb4nDuSp8rgV6TiJxOJdE
	 OYeKu05Y8vn9hVRHJtzZ7tlG5kNTuxqmT8ieMGZ5TUoppe/I86zdzcFdePHMMGoF63lQV
	 23CIemw9XsKOzgKDTQmxG6rJqA8cksECdXU3CTlStPbekIqVrQFUIPpIREaqjgZ8kx7ex
	 cY6i7pxq/Llx+dub77ycWpdCgGSe8qPsX+P5CD7jSetUTPAPpMBfAuLktAxkUUOfBog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bL2KxbVP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.178
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C4606A31B
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C26C4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bL2KxbVP
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5eadef147ffso69414e0c.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 10:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792688551; cv=none;
        d=google.com; s=arc-20260327;
        b=rExHNvIF6SRD2ggC2VjX9O2aZCjw5yul2BJxYbYMLBS5I2VEDfDaX+ARyX5GLjp3p4
         65eE7jAej5Bbo6tzt53kE9Ltb5kU2XzuVmILGryKIw3TEv2PwALo02CF3W0uZ0l5Dvb5
         arXYk9bPzTYDccXO1Y2LTyspKFozb40D4+zMJe+L40TQwKyVwUbgLIrmNp33Zhv3at8Z
         PcCEm77D6fn9OJsovVgNLott/kqrddb5XOwUsrBjGm5QY2zZIbhTQnc7PbANfbSE0CM7
         V2twSs9xGPuhdg31SzxQhSOUe/YT5IhGFXhUzj7XyOcKCDX84EANs+w9ThoJaWc8Vdty
         jioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kSWxRjaE/IbCSPMaNuU9AixW3+O1lzhb2zsYAgN97Mw=;
        fh=XJcvRQ+ZHqtiV0eIYNwEavqRV8Ao7RFYxyhzAV1lVnw=;
        b=DLyj9SBteDCevxJEvBMzERMbljAdUnawTQCpfiQXit3d9elErdPtBRI8XMY27BU/pl
         RVgHra+UUh5Adk9S3tUlXnCKfXYO8bPoUBTRdo/87m4MkhjX9gmr6pA54UrOuR83ijzV
         Dbcu+Y9gQ9VzMESXPZa/O088ymEuPbCd6A4KpB0sgsPLsNkY/ld5EpOk/krXuecW+nJ/
         wXLsWpkD9sZT5+ALpPVTLK1qyBLeDCCwQ42FHvBdvd5PXnBbhZymYj8dZ826aNrAag9k
         FQQlih01WYCMj/O8LCS8V13ZkN1szJkXs/3ubz3++LA0U/lfgpC49s7l4SNKjs/NteJ3
         DIYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792688551; x=1793293351; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSWxRjaE/IbCSPMaNuU9AixW3+O1lzhb2zsYAgN97Mw=;
        b=bL2KxbVP9vJXHCaLh07m4xx/lCLFALTPsNyJ2XYD8QvTEBVm+8P8ssFZj3w0RKWQE8
         gxTxQ6OqJYdkrO8jB9C0p3oyjqyWGfFuV0I8D4EG3DxE+e/9MbTWn5JvjowPqYMzlyBG
         J3QmLYIwFbmohWkRIEX1dVxFy0RJlgXctETERcOfbImA2sz1EpNjy6plK+tLpjm1+2D/
         d3NK9es0sgtr/2QleNIMSh2s0AaL53i6Z0ARxkxKOfl8VmNOBqwteUDGzls8INyddhHv
         d0aMT0xVBKLoidLyyzmufwhIkIZBo1MezEgYkxHxy0fEYuppLbB/qM4AMy/iP8u14ClB
         qyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792688551; x=1793293351;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kSWxRjaE/IbCSPMaNuU9AixW3+O1lzhb2zsYAgN97Mw=;
        b=KEz+Dc0pNLjM0Qpdur1bKiMqFQZyHx9hnHzTlJEC93/P9SSVG3q1Aoecni8uW+voPv
         NRK1LDg5oadHvPyXaYpXRgmuozo2WxvKOhUymyXNXtiCqxOaqNDxUTnn7UGkWKp1UPBS
         QzyOASQDQbgYxwoz6cjd30JZ9WH9LUmHY0fvLFHTsbXgQdi7e/lU0+awCgFmcaxu18lB
         k0BPfVP6O3q4XrnbYajz/ClBEeJXTbK+f5RtjkMXdwC41qkFDg4ZIk47zwQ1CO6GaoEc
         1J8T0jwGXGrf4RIaaLMfvSir97z/KGh5S0mnYIAbJhtSUp3Ak1/9JH3Puko4UVAVGzUr
         7ebQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2InU3nJPxMtPPmlgehyyT9nrs00Ewa10lFO7Kw6WoAKLt+G31Gz+MsS2GsPxXe9598JQBGClPSgM8z5SsKDg=@vger.kernel.org
X-Gm-Message-State: AFq9FYIHW9TdRShXuox9s4nPSVtaSAAVGevqvMFw+/5Ex9buoXWV1x4o
	hmj6slmnmcJSFQhR3mKXZMlohswiuzTEEci48ScrrDdKgpNnPCLOiqfBgMehwLL2K+m3QQC1F2S
	iSW1pi1jwsuRZNbjZKzWL90hCXgKprpk=
X-Gm-Gg: AYBFou3p8Oq9zmeHN8oXVNFXYQADaAegnGSGHVytyEupMNUdNslNra8vizEvaplwLjy
	NO51sqMGRXFlPXyW85umim9176zUCPoazWT3HHSIfeq7pKOH/swJGjIsvMGglqfrEDuC+JHx/il
	bZ1dfNIvhMo3NVHPfIemJyBvCd6/0YjdqWY/KzlHIwuMzF5oiCVQthrBErghBka6034XyEQlckP
	wzA6NrOwnaI7rcYqQUQgAbwQYtnMezVQ/VgxzBhn9lMZq0Nrieu1jgwNNr2VypZA3vU/WndPChS
	+4RmQ+X4c0mcPY+OCLQYTeN70oUmleQNEvr0fap4n6cAvW74z794lvSrj97x414gsDzcykz51mB
	R4sl+K8OPmtvuOrmCl6Lu1PQNnWNOrWSu4twGmARUt7Pu29A0V160txdtZoZdxF/ri0Cysg==
X-Received: by 2002:a05:6122:1b8e:b0:5ea:9a2c:27a8 with SMTP id
 71dfb90a1353d-5eaebe4278cmr2430756e0c.14.1792688550608; Thu, 22 Oct 2026
 10:02:30 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <6aa9c7f8.a211d2ce.1a5198.02b5.GAE@google.com> <6ada3d82.d1c214cc.659fa.00db.GAE@google.com>
In-Reply-To: <6ada3d82.d1c214cc.659fa.00db.GAE@google.com>
From: mixalhs <mike.michalo@gmail.com>
Date: Thu, 22 Oct 2026 19:02:18 +0200
X-Gm-Features: AclHuK8O7NwRbWIfFzmBEJxz6JrwfkQQtk4I4dUTZ1jjiRYQl1sxYC0LmHe1Uj0
Message-ID: <CAO+rqLgLRszT2U_x49hYVULuJ6Lm-80EdokzQUyNO_mECKEvKA@mail.gmail.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nf_flow_table_extend_ct_timeout
To: syzbot <syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	edumazet@kernel.org, fw@strlen.de, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="00000000000040a347065e70d4ec"

--00000000000040a347065e70d4ec
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git mai=
n

On Thu, Oct 22, 2026 at 6:44=E2=80=AFPM syzbot
<syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    abeacca61eea Merge branch 'net-mlx5-hws-fix-modify-header=
-..
> git tree:       net
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D111f4d0d58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc4b098695335c=
89f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D521f7e7e2b974ab=
de99a
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.=
8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1491e029580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D157d410d58000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/22930d0e9391/dis=
k-abeacca6.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d2e18d51f288/vmlinu=
x-abeacca6.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/69879bb16225/b=
zImage-abeacca6.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> 1
> WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_table_extend_c=
t_timeout+0x1ee/0x2f0 net/netfilter/nf_flow_table_core.c:553, CPU#1: kworke=
r/1:2/123
> Modules linked in:
> CPU: 1 UID: 0 PID: 123 Comm: kworker/1:2 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/07/2026
> Workqueue: events_power_efficient nf_flow_offload_work_gc
> RIP: 0010:nf_flow_table_extend_ct_timeout+0x1ee/0x2f0 net/netfilter/nf_fl=
ow_table_core.c:553
> Code: 00 00 00 41 83 ff 06 0f 84 9a 00 00 00 41 83 ff 05 0f 85 b0 00 00 0=
0 e8 e0 10 a9 f7 41 bf 30 75 00 00 eb 0f e8 d3 10 a9 f7 90 <0f> 0b 90 41 bf=
 01 00 00 00 48 c7 c0 80 f2 a0 8f 48 c1 e8 03 42 80
> RSP: 0018:ffffc90002dcf930 EFLAGS: 00010293
> RAX: ffffffff8a1effad RBX: ffff888027a52900 RCX: ffff88801ffa1f40
> RDX: 0000000000000000 RSI: ffffffff912fa640 RDI: 000000000000002f
> RBP: 0000000000000737 R08: ffff88801ffa1f40 R09: 0000000000000002
> R10: 0000000000000011 R11: 0000000000000000 R12: dffffc0000000000
> R13: 1ffff11004f4a538 R14: ffff888027a52948 R15: 000000000000002f
> FS:  0000000000000000(0000) GS:ffff888123bbd000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f926bd5bd3c CR3: 000000000fb48000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  nf_flow_offload_gc_step+0x5aa/0x840 net/netfilter/nf_flow_table_core.c:5=
93
>  nf_flow_table_iterate+0x13c/0x1f0 net/netfilter/nf_flow_table_core.c:459
>  nf_flow_table_gc_run net/netfilter/nf_flow_table_core.c:616 [inline]
>  nf_flow_offload_work_gc+0x22/0x70 net/netfilter/nf_flow_table_core.c:624
>  process_one_work kernel/workqueue.c:3396 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

--00000000000040a347065e70d4ec
Content-Type: application/octet-stream; 
	name="0001-netfilter-flowtable-extend-ct-timeout-of-offloaded-G.patch"
Content-Disposition: attachment; 
	filename="0001-netfilter-flowtable-extend-ct-timeout-of-offloaded-G.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvjsgn1g0>
X-Attachment-Id: f_mvjsgn1g0

RnJvbTogTWljaGFpbCBBbmRyZWFzIE1pY2hhbG9wb3Vsb3MgPG1pa2UubWljaGFsb0BnbWFpbC5j
b20+ClN1YmplY3Q6IFtQQVRDSCBuZl0gbmV0ZmlsdGVyOiBmbG93dGFibGU6IGV4dGVuZCBjdCB0
aW1lb3V0IG9mIG9mZmxvYWRlZCBHUkUgZmxvd3MKClNpbmNlIGNvbW1pdCAwMzQyOGNhNWNlZTkg
KCJuZXRmaWx0ZXI6IGNvbm50cmFjazogcmV3b3JrIG9mZmxvYWQgbmZfY29ubgp0aW1lb3V0IGV4
dGVuc2lvbiBsb2dpYyIpLCB0aGUgZmxvd3RhYmxlIGdjIHdvcmtlciBleHRlbmRzIHRoZSB0aW1l
b3V0Cm9mIGFuIG9mZmxvYWRlZCBjb25udHJhY2sgZW50cnkgZnJvbSBuZl9mbG93X3RhYmxlX2V4
dGVuZF9jdF90aW1lb3V0KCkKb25jZSBpdCBmYWxscyBiZWxvdyA1IG1pbnV0ZXMuIFRoYXQgZnVu
Y3Rpb24gb25seSBrbm93cyBhYm91dCBUQ1AgYW5kClVEUCBhbmQgaGl0cyBXQVJOX09OX09OQ0Uo
KSBmb3IgYW55IG90aGVyIGxheWVyIDQgcHJvdG9jb2wuIEhvd2V2ZXIsCkdSRSBmbG93cyBjYW4g
YmUgb2ZmbG9hZGVkIHRvbywgYm90aCB2aWEgbmZ0X2Zsb3dfb2ZmbG9hZCBhbmQgYWN0X2N0LApz
aW5jZSBjb21taXQgNGU4ZDk1ODRkMTU0ICgibmV0ZmlsdGVyOiBmbG93dGFibGU6IFN1cHBvcnQg
R1JFIikuCgpUaGUgdGltZW91dCBvZiBhbiBvZmZsb2FkZWQgR1JFIGVudHJ5IGRyb3BzIGJlbG93
IHRoYXQgdGhyZXNob2xkIGFzIHNvb24KYXMgYSBwYWNrZXQgb2YgdGhlIGZsb3cgc3RpbGwgZ29l
cyB0aHJvdWdoIGNvbm50cmFjay4gV2l0aCBpcDZncmUKdHVubmVscyB1c2luZyB0aGUgZGVmYXVs
dCBlbmNhcHN1bGF0aW9uIGxpbWl0IHRoaXMgaXMgb3JkaW5hcnkgdHJhZmZpYzoKdGhlIGZsb3d0
YWJsZSBkb2VzIG5vdCBwYXJzZSB0aGUgRGVzdGluYXRpb24gT3B0aW9ucyBoZWFkZXIgaW4gZnJv
bnQgb2YKR1JFLCBzbyBldmVyeSBwYWNrZXQgb2YgdGhlIGZsb3cgdGFrZXMgdGhlIGNsYXNzaWMg
Zm9yd2FyZGluZyBwYXRoLiBJdAphbHNvIGhhcHBlbnMgZm9yIGEgcGFja2V0IHdpdGggdHRsIDw9
IDEsIHdoaWNoIHRoZSBmbG93dGFibGUgZmFzdCBwYXRoCnBhc3NlcyB1cCB0byB0aGUgY2xhc3Np
YyBmb3J3YXJkaW5nIHBhdGguIG5mX2Nvbm50cmFja19ncmVfcGFja2V0KCkgdGhlbgpyZWZyZXNo
ZXMgY3QtPnRpbWVvdXQgdG8gdGhlIEdSRSBzdHJlYW0gdGltZW91dCAoMTgwIHNlY29uZHMgYnkg
ZGVmYXVsdCksCmFuZCB0aGUgbmV4dCBnYyBydW4gdHJpZ2dlcnMsIGFzIHJlcG9ydGVkIGJ5IHN5
emJvdDoKCiAgV0FSTklORzogbmV0L25ldGZpbHRlci9uZl9mbG93X3RhYmxlX2NvcmUuYzo1NTMg
YXQgbmZfZmxvd190YWJsZV9leHRlbmRfY3RfdGltZW91dCsweDFlZS8weDJmMAogIFdvcmtxdWV1
ZTogZXZlbnRzX3Bvd2VyX2VmZmljaWVudCBuZl9mbG93X29mZmxvYWRfd29ya19nYwogIENhbGwg
VHJhY2U6CiAgIG5mX2Zsb3dfb2ZmbG9hZF9nY19zdGVwKzB4NTQ1LzB4N2IwCiAgIG5mX2Zsb3df
dGFibGVfaXRlcmF0ZSsweDEzYy8weDFmMAogICBuZl9mbG93X29mZmxvYWRfd29ya19nYysweDIy
LzB4NzAKICAgcHJvY2Vzc19zY2hlZHVsZWRfd29ya3MrMHhjM2QvMHgxNjMwCiAgIHdvcmtlcl90
aHJlYWQrMHhhNDcvMHhmYjAKICAga3RocmVhZCsweDM4Yi8weDQ4MAoKQmVzaWRlcyB0aGUgc3Bs
YXQsIHdoaWNoIHBhbmljcyB0aGUgbWFjaGluZSB3aXRoIHBhbmljX29uX3dhcm4sIHRoZQpkZWZh
dWx0IGJyYW5jaCBzZXRzIHRoZSBuZXcgdGltZW91dCB0byAxIGppZmZ5LCBzbyB0aGUgY29ubnRy
YWNrIGVudHJ5CmV4cGlyZXMgcmlnaHQgYXdheSBhbmQgdGhlIG9mZmxvYWRlZCBmbG93IGlzIHRv
cm4gZG93bi4KCkhhbmRsZSBHUkUgbGlrZSBVRFAgYW5kIGV4dGVuZCB0aGUgdGltZW91dCB0byBO
Rl9DVF9EQVkuIEdSRSBjb25udHJhY2sKaGFzIG5vIHByb3RvY29sIHN0YXRlIHRvIHRha2UgaW50
byBhY2NvdW50LCBhbmQgTkZfQ1RfREFZIGlzIGFsc28gd2hhdApmbG93X29mZmxvYWRfYWRkKCkg
YWxyZWFkeSBzZXRzIGZvciBldmVyeSBvZmZsb2FkZWQgZW50cnksIEdSRSBpbmNsdWRlZC4KVGhp
cyBhbHNvIHJlc3RvcmVzIHRoZSBiZWhhdmlvdXIgZnJvbSBiZWZvcmUgY29tbWl0IDAzNDI4Y2E1
Y2VlOSwgd2hlbgp0aGUgY29ubnRyYWNrIGdjIHdvcmtlciBleHRlbmRlZCBvZmZsb2FkZWQgZW50
cmllcyBvZiBhbnkgcHJvdG9jb2wgdG8KTkZfQ1RfREFZLgoKRml4ZXM6IDAzNDI4Y2E1Y2VlOSAo
Im5ldGZpbHRlcjogY29ubnRyYWNrOiByZXdvcmsgb2ZmbG9hZCBuZl9jb25uIHRpbWVvdXQgZXh0
ZW5zaW9uIGxvZ2ljIikKUmVwb3J0ZWQtYnk6IHN5emJvdCs1MjFmN2U3ZTJiOTc0YWJkZTk5YUBz
eXprYWxsZXIuYXBwc3BvdG1haWwuY29tCkNsb3NlczogaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3Bv
dC5jb20vYnVnP2V4dGlkPTUyMWY3ZTdlMmI5NzRhYmRlOTlhCkNjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnCkFzc2lzdGVkLWJ5OiBMTE0KU2lnbmVkLW9mZi1ieTogTWljaGFpbCBBbmRyZWFzIE1p
Y2hhbG9wb3Vsb3MgPG1pa2UubWljaGFsb0BnbWFpbC5jb20+Ci0tLQogbmV0L25ldGZpbHRlci9u
Zl9mbG93X3RhYmxlX2NvcmUuYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
CgpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9mbG93X3RhYmxlX2NvcmUuYyBiL25ldC9u
ZXRmaWx0ZXIvbmZfZmxvd190YWJsZV9jb3JlLmMKaW5kZXggMzZiYmM3YmUyZi4uOTQ1MDJjOTdi
YSAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9mbG93X3RhYmxlX2NvcmUuYworKysgYi9u
ZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVfY29yZS5jCkBAIC01NDQsNiArNTQ0LDcgQEAgc3Rh
dGljIHZvaWQgbmZfZmxvd190YWJsZV9leHRlbmRfY3RfdGltZW91dChzdHJ1Y3QgbmZfY29ubiAq
Y3QpCiAKIAkJc3dpdGNoIChsNHByb3RvKSB7CiAJCWNhc2UgSVBQUk9UT19VRFA6CisJCWNhc2Ug
SVBQUk9UT19HUkU6CiAJCQluZXdfdGltZW91dCA9IE5GX0NUX0RBWTsKIAkJCWJyZWFrOwogCQlj
YXNlIElQUFJPVE9fVENQOgotLSAKMi40My4wCg==
--00000000000040a347065e70d4ec--
