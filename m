Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFF321ADB4
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736772025; cv=none; b=YSNCByHN1wU2uYjoRjhCW4nlQvr3YfUqEfATTaax1eF75201sHi4TzR31xfmyXCx7qd/pnhDFcjR9JQ9tG4k0OcFS49C8rVHTIS6V5DEOpNcGK+ZqZrPNCkTcfGtk+i1ecU/UxCn+tpl+6ZpgUr7UbZ17jQ5u/n2ILDLBVAmFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736772025; c=relaxed/simple;
	bh=RMqixLrCBaOy/9vqj1YnU7ZZVjBPI3eSLuMjbEWPEEw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dzTaJQfnUdz85g8yLNH8YATSLSTr0sssMRDLXTCqunO48/JtoXbxJ9QSpz7w/szc5H1qRAGWdA0SlDn9YbROEGoW7wH0i/ewXAa0wCev2NrBB4ESyVBMBG/jPYoJuDyKtbUyNphRtD+9KSY2JzTQHAWhg5DNsgXPUfDupkjOYsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9d303a5ccso79285265ab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 04:40:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736772023; x=1737376823;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iScbg1d6pXUeHMhBZVlt8cevHYDSrCOtEczzf2kPWK4=;
        b=tJp8L5qcJIDgj6Atx2bIQXEQU+u2qVI0SxuKvrCpDuSzF0N6EXs1gGccgqH2I2JGf4
         jIGv1diBv6IqOkuA78oYL2etXpenMSNDnjKsgh/TJh9llLQi8QWMVdo5eVEKrbgEmTGO
         R77NNzTydjged2H3vNorJgnZvGSVB5VY0KZ/LTGdYEu2aY9Fq5DjU9tIY3AkkNk/VrQ/
         wD9v+yFmB6ZzdBRsN3zSnRG4VW/8CA/qNLr1NpoEAUgfG3ti7LJzVBx3MIHRS0s1E7Vv
         lqdD1QjsUgmh9uVv0n8TyHHXfzSqmNeRGkl1EFVYiRFjoBUL6Cx776LBYg6daMeTmhDi
         l3Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVJfFCPLYrtBU4wgX8P/PhFUdAt8QyDgJMsQ8vxS2JxgVlWzHGG/VjD4ghd3X32M0rPG3gU2OGFjpty0EEjA00=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx/+2cysN0adQw7HzCLzbToegPDVxY0Ut0D1/GSaWl4FGP3jHq
	2EObD+nNp/XsYB3sQfbAVY5ydmuGlD8hIFAnwxQrK97T1s9uklOIfooiBuish2AZ/4YbrNlqUmo
	XMzb/exIe/ZDzwAOig452G/bQqEXv1SBDjvxxHz4CBuOOS8Xn5eFw35c=
X-Google-Smtp-Source: AGHT+IHPJP4MRDcsQbEE3EnRShsFiA6mrVr2Zhx2OlcBtRIU+7eqAmeDVqsL/q0YoyO1L/SGS4vlaU1saEZeTemcUOST4/oNzdnY
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4b:b0:3a7:96f3:bb3c with SMTP id
 e9e14a558f8ab-3ce3a86b0dbmr145793965ab.2.1736772023539; Mon, 13 Jan 2025
 04:40:23 -0800 (PST)
Date: Mon, 13 Jan 2025 04:40:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678509b7.050a0220.216c54.0053.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Jan 2025)
From: syzbot <syzbot+listb2b30dffd05d7f628801@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 0 new issues were detected and 0 were fixed.
In total, 12 issues are still open and 181 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 395     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<2> 348     No    KMSAN: uninit-value in __schedule (5)
                  https://syzkaller.appspot.com/bug?extid=28bdcfc1dab2ffa279a5
<3> 120     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<4> 62      Yes   INFO: rcu detected stall in NF_HOOK (2)
                  https://syzkaller.appspot.com/bug?extid=34c2df040c6cfa15fdfe
<5> 46      Yes   BUG: soft lockup in batadv_iv_send_outstanding_bat_ogm_packet
                  https://syzkaller.appspot.com/bug?extid=572f6e36bc6ee6f16762

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
