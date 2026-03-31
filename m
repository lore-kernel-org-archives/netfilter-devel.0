Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E2E3D904C
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 08:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944446; cv=none; b=dzmLqj+WPnU4fgf3GYkT4C+KgOYgzwqMrHVj0/p++8rP+fVK+AJLlePB5u6W+IJUanxB2o6KsBbhl+slY8KOXNoiGG4+5Jc5DsQfi2Qbtp3x1IdiXQMHvSxavzbsXi82+lLZZS/Mf+58HEzUSOItCGu5fhy3XkYNkxEQqF1j6nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944446; c=relaxed/simple;
	bh=OyOSFNZAcOtYFeS5LtZzdqXIl4nRzbBo9fS0PL7/QXk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aLYjhO9u5R6iNegTvpxdQw1YWh2/IVaYhdmqy+lttycvwTHHktTcSvmn1+oWociNeawMEglk/TG5pCY1JSBKsaEVjHZeHFXf0IEG0u1zkMqK7xba+tY/J4y1hl1qmRF/G6Gd0+qekcdTs4SxKq56N/AXM0v7v6udh+SV9TG6t+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67e282b93d1so6688361eaf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 01:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774944441; x=1775549241;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGOBMXTLJYi8EMajLqsobqRUIHxHoS8nmfP1bIVDhEw=;
        b=PoBCIvvEecY9hq9dGuROy6nRbqUR3lWZL+6jVnOMCWwyb7J1GGVi+QlOBN1AIDWB/u
         v8HMYR7VsfDUny1zxzWkCMFUTtC6s/xOHJ3uFKcvyUb4IVSsDwJMu98b6MqR9l5BYFnR
         1IjyJT145CD/8FkXgm0ucblrWBBS6ZTPFgISoP1DPo2W5RxAou+BHQ0WMqkv2cKOJFI8
         JX6+DiND+DqnpV9qncpRmyrHrq8pVfuiKSVsMnWB1+umDRECXd8aw8LIyCGOpz0HxcZe
         aStYYHEBhztqbkNkq766w0sSzURfsapWi1PSCuc7rxDjr2vt3LFOgPzLikxpaSw107+4
         hd3A==
X-Forwarded-Encrypted: i=1; AJvYcCVbOqmShPh0OC6nuE7NEGHG3FHgAHP9KBmv0/yF5QXxpFRODSibgaOG6piDL+cdCkM7iQh6DVZCodQQgiMLRQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+/pPRGdwV1tbUa3S5VRgjZWrBsTc7TQvejK7wijH4PeXU109I
	2x1VtYyZSbj8eZv0k7BsEKgoiPrLW818RaOauAutonM0QZmUZdyPAhHxVvt8qaI9scLuCVeWvyw
	E3zb24omhKOdtDm0M5TZgS0FwvNyKDhlr0TLAc4AJ4Phi94Ay6Ih+DMbh25M=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:99b:b0:67e:3f0d:4229 with SMTP id
 006d021491bc7-67e3f0d4596mr1108766eaf.14.1774944441434; Tue, 31 Mar 2026
 01:07:21 -0700 (PDT)
Date: Tue, 31 Mar 2026 01:07:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cb80b9.a70a0220.97f31.0281.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Mar 2026)
From: syzbot <syzbot+listb1e1f17cbdba99a9f9fe@syzkaller.appspotmail.com>
To: fw@strlen.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 2 new issues were detected and 2 were fixed.
In total, 13 issues are still open and 196 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 4918    Yes   INFO: rcu detected stall in worker_thread (9)
                  https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<2> 692     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<3> 325     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<4> 68      No    INFO: task hung in nfnetlink_rcv_msg (5)
                  https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
<5> 11      Yes   KMSAN: uninit-value in ip6table_mangle_hook (3)
                  https://syzkaller.appspot.com/bug?extid=6023ea32e206eef7920a
<6> 6       Yes   WARNING in nf_ct_bridge_post
                  https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
