Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337E52DB79C
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2026 00:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785628839; cv=none; b=B/8bcvPqo7gi7mt3Ui/gDN6nXEagdbzdTguKPuf4dzG3sgHK7vYZre1Wo64nBUTg/t0I3Zgo8eX5LYilfBV9WzWOF7OZy1Qo+vOHHQeaO/h3zz7kYYXcEvG+kjs0o2mycHg0+mvSnJDIbY70SCEula9K4G86ZFEYEbZH6sTn3ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785628839; c=relaxed/simple;
	bh=FkvwcGmPaYjEJ8j6+nz1j8HFd4IzNdzqUCflb2OtZN4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JZjo6RPK0RXxPcG3ZEBX1c+TDaIRnd/5D8mMzDVc9Yi1KfPQQhN7PM17F4o5SiUf64pZHDPHw2Boerquszwv2ueSIxcnZCHRnf0Fp4ZC5tcfw+xHGaCl3SURpso/f1uSONxev9v0WWjnj16ygXnAdbmXehyxo1NWyPRCidq3L5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49001defc4dso3415028b6e.3
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2026 17:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785628836; x=1786233636;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DApPQPDvyDynAHjSaKvCCTdiu7dQn53eMBYw3i2c5ks=;
        b=iYw0Z1hWEpSg2HEh50aN4kB7KSC7mMAMXgd0bOKdiVaTnaZpzTtGGffkGbc9SZRKhU
         kRjIOx83c3E4v5ejJqZV++6OKrk6L5Lo4zRSAwY1boa0QakxWxX1rCmduRTA9sRvgMQL
         iePlaSUhhEWS93lO5XRo6q+KCnL0ValpugVTMhSfN3uJQt6wInvA1BCFzSDB/5pWRaWP
         7sSJMM/2lpy5idvkt3ILbcVg3ra3sdr+dcYIRAMJTHGg09eTH6atyoWNj/HiYn14DILa
         b2Pw50ZGT6EWE3uqhXqITw4ETPFZDxIHAOcoYgKjcNfkLf6c8hJC7mK+z5eQcwWwFGUE
         v+Xg==
X-Forwarded-Encrypted: i=1; AHgh+RoCFkLCR5+NUtkLN79MTJU7B6ALdaM63DrpJ5TMpzxvlbQnyX1CCQg7YNpwqTkCMbnMHEin/fAPJkUFJl7rRNM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2VqtN3rT+Tg0m2kh2I08B7vmbdjfmpT1WYsJvQDO6GC33jpr7
	b5m09nHYQKKFqPo5GDxaMo3PrSNljJ73dtGmFC0WvsqksfDhctWOgk+FoahMqU8mT2YpyI9aAgf
	MscRxy6FZDV0TBU+HTkXmyI4y6V8HyaL5Ys40XD/vgkc0HH6odmLXuQLMsa8=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3c4a:b0:4a4:e11c:7b56 with SMTP id
 5614622812f47-4af5e05c3ecmr8972357b6e.8.1785628835992; Sat, 01 Aug 2026
 17:00:35 -0700 (PDT)
Date: Sat, 01 Aug 2026 17:00:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e88a3.13bfb6d0.1ecdd5.0267.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Aug 2026)
From: syzbot <syzbot+listae8a20fd53e9b2a3905f@syzkaller.appspotmail.com>
To: fw@strlen.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 0 new issues were detected and 0 were fixed.
In total, 11 issues are still open and 198 have already been fixed.
There are also 3 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 10      Yes   WARNING in nf_ct_bridge_post
                  https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
<2> 1777    Yes   INFO: task hung in addrconf_dad_work (5)
                  https://syzkaller.appspot.com/bug?extid=82ccd564344eeaa5427d
<3> 704     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<4> 157     Yes   INFO: rcu detected stall in br_handle_frame (6)
                  https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
<5> 143     Yes   INFO: rcu detected stall in NF_HOOK (2)
                  https://syzkaller.appspot.com/bug?extid=34c2df040c6cfa15fdfe
<6> 80      No    INFO: task hung in nfnetlink_rcv_msg (5)
                  https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
<7> 3       No    WARNING in nf_conntrack_cleanup_net_list (2)
                  https://syzkaller.appspot.com/bug?extid=122256c3e2bf6ec9f928

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
