Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B941DA5F
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734095793; cv=none; b=kzq316rwaBn4+c2a25ASdG1E6iODJTMerqQnPNNi3xNx1rnsMYOlZL+Sp0fBKEcSZ/uCGHTDHdbTDWRRr4QzMx6TDKezemkqOdu6X0s7YGwwlfyKtzx0XkmdcDZw9LjnaPqK6BRbsoxOJmJccbXKOtom8B73OMPqe+xr6r0Hn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734095793; c=relaxed/simple;
	bh=MfODUbaKjsDTInyPezTB9iD2+taJp9jMC+mbhYdLpKo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KI4axNRNrttDzTq8QxZlUDdU94NParo6IZ2ZssGN547N1VB04YFzGmJLsfXhnEHoztu39MO+o1qr5l/a7Ooax4IOQOfjiTtSnEerQgFRmaPQGgULUE7zSNXElcp9cj3yyu9UwdYH1wuyWzgFBrAjGp9LjNiWE8wd/0N8LVX7QQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7d85ab308so14532535ab.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2024 05:16:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734095791; x=1734700591;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uoBiKipHNLLpHGGGSTJe/jfqJxnRClX1ADVodHH2Ukk=;
        b=nvjfxHs5E7KTTReMhTI1KevsYH/Zn1KripX+5H2NMtLkoyUsp6VqoN/6RqqjBrTduT
         4RUc5T3gBTWcZ5oDvdYDrbtUc+C3aKhR+KLaCFJVYc2C58CiU9ZgQ+cDuVj5Xkqu0BCr
         rzJjT9+KJGAu0VZ5xceTuxnnGx6OlG7dQerSuTqY+pc5uuwUiL6Y6JwrSrFVJ3Gww+S5
         F2+N07tASuu7cK4oC8RC8jME8kECLky2QJAt3zK1sVD0nucpNtCdCHV9ASGn6cui3c7b
         ErkaQdg6odl4sOxbjfHklbhDecpcp0jrjVGgVPVxqLSfezeXuPLBaNoWf3LIzQKfvXeB
         084w==
X-Forwarded-Encrypted: i=1; AJvYcCXma/hdBnDvbyqdwxEPnMfO+3+4JSj7PYNszfIUm5kZcyRpFI3VS7KBUrQ7GPRWW89UV+BjVLpC454/8NXkjU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB8j1DjYF4s6dMI2VwEdRCa5TyWLBAOmMwBKj8VuiCUSfkrZNF
	copZmE2g2M/2+2IDZMTLegs/B4A2yrJO06H3em8/T7WflIQQuFfEPHgAyDrYPoOv04bQ50fR7XR
	DM3Yv34jOyfw2G9Uu97Gdkiq4ZIP1p+6HS1udsH2n9XOuEvTwdjUOyts=
X-Google-Smtp-Source: AGHT+IE/k0fH2aZWvFpnpJL0Kpg078Jm4gbrIke1NK4w8p393GE7mD5tDe40KwEIlaW3OO2uN7GjbOFMai0o7tHJH4bF+ddEJxL9
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1448:b0:3a7:7811:1101 with SMTP id
 e9e14a558f8ab-3aff2dd4d49mr35489215ab.20.1734095790862; Fri, 13 Dec 2024
 05:16:30 -0800 (PST)
Date: Fri, 13 Dec 2024 05:16:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675c33ae.050a0220.17d782.0011.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Dec 2024)
From: syzbot <syzbot+listcc55049a3e829aa8f20a@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 0 new issues were detected and 4 were fixed.
In total, 12 issues are still open and 181 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2851    Yes   INFO: rcu detected stall in worker_thread (9)
                  https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<2> 119     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<3> 52      Yes   INFO: rcu detected stall in NF_HOOK (2)
                  https://syzkaller.appspot.com/bug?extid=34c2df040c6cfa15fdfe
<4> 47      No    INFO: rcu detected stall in sys_sendmmsg (7)
                  https://syzkaller.appspot.com/bug?extid=53e660acb94e444b9d63
<5> 39      Yes   INFO: rcu detected stall in ip_list_rcv (6)
                  https://syzkaller.appspot.com/bug?extid=45b67ef6e09a39a2cbcd
<6> 37      No    INFO: task hung in htable_put (2)
                  https://syzkaller.appspot.com/bug?extid=013daa7966d4340a8b8f
<7> 10      Yes   KMSAN: uninit-value in ip6table_mangle_hook (3)
                  https://syzkaller.appspot.com/bug?extid=6023ea32e206eef7920a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
