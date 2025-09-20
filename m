Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43592FB61C
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Sep 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758393208; cv=none; b=aOc8qcfgAT5b4dvtsqWqmLbekx5Qk8osj6RDZ8qM5W0pBaEYhU9Pn8LmGg7tPdY/OCyR1N0jkoUVUaDyOsKyqHA3rue4nCaS4vHx3mGdvF94rTzdVgBDTpIPrVoK2zwPo+gRkzavBU432+CIamrGGb9CgWDfPDwJoMYmoKXb5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758393208; c=relaxed/simple;
	bh=q3JwbZLYkwQ6662aLHgG3XzreNcfXAsrUOq0SyjB5Do=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=B07/pMrF11Ze8FtYkpwf3Uu8+nroPZTsp1rQU3VpF+p2zg4FO9fSX8DiNGgujYpr2JcG9OUPvgMZWPj2dMkrbCQWnwUEz4qtwCH+lmBrDL8gEzCedZNlCm8/5LtTTmmil2UxRzCxKcP3tSxIBIXmxdIJsPf/qKW6hnoRV7sDGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-424019a3dfaso28270775ab.2
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Sep 2025 11:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758393206; x=1758998006;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1MxQWFMj0zJHq+eE4KxBbGkYIuLFaEc9m0xWis+dN6M=;
        b=J7XBP49b/YOHVYec1ohQblL43+/qqk+10J3278LJPECrCzOt00drzNU3Ymb//LdXLe
         rhBMX8K1xwVCyr0N0sd6PpCkH93NIQ0Rjo5SayX4Eb8eswJZYutaHvxK9WJ88IttbZtr
         xpa8l67KS3ddPD93NaAmN5JDJ7TC5ZhOM7B++mGsoe5V64Z55SxhaHt2+Aal6/75mOhd
         QuAX+qRQetlrdpbMKMxu54g624S48APWO+P+1cMy5Xi22nSrQO8cmc8SrfnqiyI6gkMv
         n6t8tJk4UkmodbV/SISLXIMTAPEGLXNn1yJp5oeq5xP17ic+FyRVa3edto0AAM1l87Vz
         Pcsw==
X-Forwarded-Encrypted: i=1; AJvYcCWleXQ1TNZYAvHXkRdXEBYcIFL205+7TIaVYOL53iHjRI61eRSrgU366L4igZ+PE0LrjDV92TyC0RTEti92eiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh0r8ImHmWwbjFdC2Jmvm5bkKzm7FqnQy3RYfbVj0OAle4RRO4
	tHWT5oUE745te++0pZVr9KdfQlsSYlhbfxiVi/3137CmQ9y9GjGXiPZrrEZPCSUC8vMK6WyRyNM
	wgtzXFvzSXf/VACGVNMYwVStNljSpJjm1WY7AGcDnInUdEJ29DuiWPmhQASg=
X-Google-Smtp-Source: AGHT+IFZHvT24Hr2IWmXXBCBm3AbfLkO1CrX2GHqJ7LPOLF2UBqELELG0UpX0nSreYr12sGwFWvG9P/DkpiG/5Jout9w4zYMT1HP
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d85:b0:424:8c2d:ca43 with SMTP id
 e9e14a558f8ab-4248c2dcd45mr51544435ab.29.1758393205956; Sat, 20 Sep 2025
 11:33:25 -0700 (PDT)
Date: Sat, 20 Sep 2025 11:33:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cef375.050a0220.13cd81.001d.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Sep 2025)
From: syzbot <syzbot+listc8cad7cc6e5421df7d8b@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 0 new issues were detected and 0 were fixed.
In total, 10 issues are still open and 191 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 4276    Yes   INFO: rcu detected stall in worker_thread (9)
                  https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<2> 557     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<3> 554     No    KMSAN: uninit-value in __schedule (5)
                  https://syzkaller.appspot.com/bug?extid=28bdcfc1dab2ffa279a5
<4> 211     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<5> 3       No    WARNING in __nf_unregister_net_hook (9)
                  https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda
<6> 3       No    general protection fault in nft_fib6_eval (2)
                  https://syzkaller.appspot.com/bug?extid=109521837481c8e96ea5

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
