Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570761586C2
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Dec 2025 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766735246; cv=none; b=EXuluDKOzaiwC08weNeeKWOqgPnYCq6/DB4AComn5yFPyPfwzqC3rOoK+PMZiVhCTv9/+kqDKV8rsU/BB3jKYVvht6VHxuw9USAOM18S/WrbkZu+7pf6vdGfsHu+ooUqm1nAa7FppHnl1aI7F5bWwc6vaacEN6hNbmcg8NymBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766735246; c=relaxed/simple;
	bh=UNsXj3V8BVUoYkRtHWST2T4L2TCT00/fZxiwN8LBSJA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ABMnfvynCyN9QqdPSRC26xyNFe7GRXGZP4sYW9iZ3ho1h5rLKHus0eZsIp+16Fy6sj7S0Rdtq0hLFt/eGatKPDNeEOv7/swQnOcO5mFCgYdX2Of483nba/QLv1zyRDtwS/ON93AQFmYjX4nbAchLAIEzy0J39kn85Q0rO2FM65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7cdcd09efc6so5998185a34.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2025 23:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766735243; x=1767340043;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MP4vBykJbYxGqQ4N+Xjb6R9EF1dhARO71RByzwm+SXs=;
        b=crtYGHb0O/7ntgZdi8w+4yKblp1gvesu5u9m2ildsXkleflQVI6gncXg3BDCx2ZcvF
         YSGYh2i8JI2xRboLQTVH2+Y1KbhV/yQccQIoKVtqyXXJzgs6dFGIwIn+3gsGi71OOJol
         +fjqNT/Q/u12TS927bkWIYL0M85BpGqCF6Zpqkk0sa/CzMa9km3DqVJ5f7rQwmMpmpXh
         lRNhx9SKdZx5BslU+VynXlOJrSPrFk2UjGNlugXbC0/umOhkrxVa8igydDo1Vir8EODa
         MceQ8WwJ5hhkzuHdb/smCdu+atUMsDP2mJ+zgiYxt8WbM7gjN3Pz3gqH8N0Nu96bO1WK
         sEPw==
X-Forwarded-Encrypted: i=1; AJvYcCUaR3VIC7CDjcfRGb+bGPTDLu8BloH7lkGRsblVnzrvfcBDRde77ZNLRym5fmirVll1VxspwSSjyVe/PEu4dzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYKmajDypPVvjDfRnLb5chWy/0vHUrFnTmrWx0QZD9T+jH/jcw
	m57tOlhW/JMJmkuOFXoRfmM36MNgUFxtjd7z9IXxfNrFNCj/wMP1tGW1htX1duCWkOq28GmofpG
	sEunB17sxv/6zTEuxwsRErujUUWLKfrnohRvizneeXb4tkNJcR6TLqPwGtYg=
X-Google-Smtp-Source: AGHT+IE1dFIaxTIcRJlZdE+hZMymfmQx0LkUBrve2JPD6tLnF3dM/icrpoMNgLq9pKcqU6ucC1cyraYD/oCQlOf3+LgjHqAjWA1R
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca1:b0:659:9a49:8f43 with SMTP id
 006d021491bc7-65d0eb56dd7mr8731259eaf.84.1766735243381; Thu, 25 Dec 2025
 23:47:23 -0800 (PST)
Date: Thu, 25 Dec 2025 23:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694e3d8b.050a0220.35954c.0065.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Dec 2025)
From: syzbot <syzbot+listde02170f214c3819f6ae@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 2 new issues were detected and 0 were fixed.
In total, 13 issues are still open and 191 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 627     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                  https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<2> 276     Yes   INFO: rcu detected stall in gc_worker (3)
                  https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
<3> 119     Yes   INFO: rcu detected stall in NF_HOOK (2)
                  https://syzkaller.appspot.com/bug?extid=34c2df040c6cfa15fdfe
<4> 11      Yes   WARNING in __nf_unregister_net_hook (9)
                  https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda
<5> 6       No    possible deadlock in ip_set_nfnl_get_byindex
                  https://syzkaller.appspot.com/bug?extid=aefe8555e94ae62b95c1

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
