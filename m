Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B013D2DB7AB
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110718; cv=none; b=SyailmbBr8Kht/3F8XPpk9P2Hxnsc5fsKvF7lAksAcXmKsl9wn7lvuCYBwoE0PGB/f5ntfrWV5at3BebJvX6E6jl/lSbSHcVJn8nFEP6p/hJ9CC59VKgl3sAa5Y8PpDdAeksPlXkpYnSWursq9Qmp98KeHJWGeVu2j+Zn1d//20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110718; c=relaxed/simple;
	bh=TiqbeE6FK5tIk/RJQnJ1wxvW8bDjSQKh5wvvtBQbv4g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=C5jyDEmGgh+jp/OrZvCpGd2gpDnj2And1esYmDt4VDjLW6sraRrRjq+6tjAsXewimwFORCnM5T2IVjwyObl5s3RbhrjmxATMRutCghbZx3LscKk75KutTZMqc0n2rlbtu8pdOPcSgo3ELdi6vRSo4ahLRyyh32ZivqWVavMGg7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679dcff168dso6899091eaf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 04:58:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110716; x=1772715516;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahVCnuEXR3Y0gW4V9lcm+HW1q/eix0cX0sztaTxYmyk=;
        b=XFYM0l+xiINfmSXBwbBs8X8ysL9lV36szbl8yibrLE3ZpOMyKyvARls5dGiENuFiMX
         H5s3kfvSgwugf3d1tsawW379i7PO2yoJ3CXkj8QsnV6FRlda3Xdys/b37qLjnTFC7ZU9
         B7UW14L3QAS9JtwNAmffGHg85VU2xw0QWeNipRZCjl69gB91HIwRjBMuRWxa0xg+bpA+
         xGAk9f+jd5gTlNq8mqCCTDxAcmO2q7HAjCGcp7suniZUf+FD2pIZdCCaW5p4KISea41t
         adfSyJZ4pFa4D4/klk+ffnUjGjbI1KFKCKGdRLSNdO/XA8uUzQrc7HpQyQddiEk22eVW
         aN1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+vhIl4e3gxCfKkutLTVzG05eBfOdiWQhl4Ph5YSFMW25mXR4IRniZnszAVEQ9bo2rqtlxynJlEzSgy1Qjfrc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3WdiKSPs0YFPqS6Y1pEZRwIN/e5exSQWdfOhER6UeQrmt1fm4
	pCjoGoJuuAA972iO9JHTmHESugT+yeaOu1Thp2LkPsIoR/GHp9vlvkJebTan1O2BTfWh3ikieQO
	XQ1BqIhhjSGkpWZG0fDbRe2JIE4SwGkTUmbxgDgCUfeWq3h72MbKXdFmVmqI=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:169e:b0:662:c0f7:bed8 with SMTP id
 006d021491bc7-679ef7fb075mr1712875eaf.12.1772110715794; Thu, 26 Feb 2026
 04:58:35 -0800 (PST)
Date: Thu, 26 Feb 2026 04:58:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a0437b.a00a0220.21906d.00e9.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Feb 2026)
From: syzbot <syzbot+listc25fa2ef6d483674daf7@syzkaller.appspotmail.com>
To: fw@strlen.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 1 new issues were detected and 2 were fixed.
In total, 15 issues are still open and 194 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 4865    Yes   INFO: rcu detected stall in worker_thread (9)
                  https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<2> 906     Yes   BUG: unable to handle kernel paging request in ip_route_output_key_hash_rcu
                  https://syzkaller.appspot.com/bug?extid=334190e097a98a1b81bb
<3> 671     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<4> 311     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<5> 47      No    WARNING in nf_hook_entry_head (2)
                  https://syzkaller.appspot.com/bug?extid=6f6a1d20567a8d6b2a58
<6> 32      Yes   KASAN: use-after-free Read in nf_hook_entry_head
                  https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
<7> 14      Yes   WARNING in __nf_unregister_net_hook (9)
                  https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
