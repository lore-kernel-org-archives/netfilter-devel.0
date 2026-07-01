Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D574921A9
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909147; cv=none; b=eqQUDz0cpRlE5K3KHADVZo64/YwR7C+KAC7XUQX1xfEhxfg2vEBgLPgG/lGih5FKmk/Ry0WeaZYO2/mFL1Gh4hnAoqyCP6bM2ZeCWuvTtv8JoQccxVYdhF0Sj3JiwAu7tGaBUkYqwJA5G3uT1Gv3Kfkn8wGlWUTEKPpu00Vkr/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909147; c=relaxed/simple;
	bh=C8ae2Wn3IRIgHe995KPxuL6o13/FdExud3bMgQz6wD4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mE/BEhvNJeMySVBxpv/vv2SfXOAv9BHhqAuWTkaJMwp3CHRKuDw/6KXaCd3orBKHOFIjx2Is2XaUAAoQACAMk/qOSQCkbsyu2a+PlhIE5SRTf02o8/5lYKQzwlPZCrmXvDj9IJ+MBdpcpOaAh8x2KlgXrc0+h3VWT5BcDlXml6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6a14a54c185so710871eaf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jul 2026 05:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909144; x=1783513944;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=me+E3q06UL+WArmFrq+65FdWO4Z3IexCPtt0ELwjlkE=;
        b=J3JSxAmFPi32XyloiHrHg/o1nlsmOiVfe9IRNY1MxI2vin3e87QyoI1v7VBglnpXm6
         5guAZLdHwMxC3Hoqvgws5Gof78UuZ1j/FQjb1SCA5tZOwiVunvpIqh+dbtaSR9vYsSHk
         B65Zf2jCw786HPnxPh2sE9MO7y4JBgBJVeW69QlfazClWfP8rkr0NhUgVo3Xo+sEGwR4
         tuybQ0hxk5qEhCrdDsOig3rJorzlXid/n32FFYp8d9ghTewerVt0rKtlpeQq73RSTiUD
         DS1muZ1BRnRrPSPK6Luoq2VI3yLhIjeaSk0ix4MNTpbok+IHFvVwZvYnjiSBVOVLHB8X
         Cblw==
X-Forwarded-Encrypted: i=1; AFNElJ9m4T/KBus5bs09zGsI/W45rkeWDS/qrgCRWAvtK6TSmOox/+5Ni+JSeG+2K49q/SmE9iXPi0uqG0ndyiOkkKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYCLIppFgFz0HD57sGdy/6DtxZLKIsoEBf3YRrsdWk+BEuQU4i
	wZHqypjXIQKL8q54qXgb4RW4kP1t6K7wl/w4YG4HOgTbg7gwdGHklzj7F5nIU/AKbkxFrJ+PdZJ
	SsuLSGu0mhOfrPpi0WCHVigZVSgt/DHC9XAA0z6HLAHK3lYSxUqXcupo5Nls=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8e:b0:6a1:9a59:5c5f with SMTP id
 006d021491bc7-6a309b372b9mr715415eaf.46.1782909144391; Wed, 01 Jul 2026
 05:32:24 -0700 (PDT)
Date: Wed, 01 Jul 2026 05:32:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4508d8.52c20a74.1f8b39.0002.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Jul 2026)
From: syzbot <syzbot+list936a506377afb7f1a7a7@syzkaller.appspotmail.com>
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
<1> 1759    Yes   INFO: task hung in addrconf_dad_work (5)
                  https://syzkaller.appspot.com/bug?extid=82ccd564344eeaa5427d
<2> 703     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<3> 137     Yes   INFO: rcu detected stall in NF_HOOK (2)
                  https://syzkaller.appspot.com/bug?extid=34c2df040c6cfa15fdfe
<4> 124     Yes   INFO: rcu detected stall in br_handle_frame (6)
                  https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
<5> 78      No    INFO: task hung in nfnetlink_rcv_msg (5)
                  https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
<6> 2       No    WARNING in nf_conntrack_cleanup_net_list (2)
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
