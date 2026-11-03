Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793680440;
	b=HZtzig2mn4a3OIdmEkSVrRa2yFnPfCCrJZW56qJbDN/Jcv8k0zflAm9Ufr+Gk8lyai+5
	 acCQISoaLvhx3w3J0objnqs7hTkTa35Ge50pXaBnTL2ccpUjKLDTFw9KSNjS1j+4Wd4VX
	 3XQHPm3kJrNVsyLVgUatpSdN5yrR6qC9pcxhUxzViZU8iJMjhIsbvwZ1wFe2k4/6tYHOM
	 93dDQHbelIsE4VuaZdaypQbT02l7Zh/UKU+PrI/xW5ZkhZgC/sJ9W+htejsFsS51iDkSH
	 0Ur4iPAc2Wz2BXwwjXGPIHKFAnIhqUKKkvgAzNtryfGkkQfuUgnsoYDVhEjC99GBKFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793680440;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=4tPs4mp2bvwQdRd4sbq6CaL9zCSxrf0L6Yrn8je4uH4=;
	b=FRYecmFJEROWAY4byMSdsijK+S87VMG5NZgdM09qOCHusxT42+G9yKr7PlQrvlE+zbZm
	 v2XNsnCQvxmWcupF/0rFIvc48hu7RLMbho+cDGAYpjuarM4AuB7Hf6A6Gr8Sm2zNfoaxI
	 Gtx/WL89sth1miavxXDKju3RUJVrgBL8knl8BLcHAsvYdFakO1fj0HG+L4v1xymxFi50x
	 bPxLmh1GcXey+mCTbVZvg9dP3E2AK83YeY8sj4N+muOnz/cr/PWBcC2QNrlobKD55P2Pc
	 1+VyYkV6RP0whUKhJrQy9FCC7Sp08XYp/zWZijAW/VB4h7ST1XR97FFJLwTZkS9/KQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6FF606A32E
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 04:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE6FF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8255327a28fso4553185a34.0
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Nov 2026 20:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793680439; x=1794285239;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4tPs4mp2bvwQdRd4sbq6CaL9zCSxrf0L6Yrn8je4uH4=;
        b=AGoWGkyotzgxTZCgg5tTEJYFOBtJnWyue56Uh7bov35POn8IwA07CY8xqyL6HwgUH/
         dwlp+266mBtD4vGTuZXaHSg5tLTXatAsf4PVT+GqGoZSDigshlzDyQXHJi9zGDPam38Z
         Aq9+eKOY3d+T/Ukl3iqtywD1i17azRURr10nKUYH2nnYxhAc52zNBSWtUlzs/T0uxCYo
         OAuSUjuQ9+p3mOyLDhUP67F0Dnki1ZwapIZVb0QwwcXdKsb20pTx7Hw3pLEmiEmQ6Ui+
         tJ7LHp3Sv0RAh4gy82Jft8mTh+E73XwcIj1D/nD1GiM279/cSHClWPJP21+UW/nwQ6Vk
         eJag==
X-Forwarded-Encrypted: i=1; AKwUvBy80CmzCX2LqfHvZZxcnddIGAEgbb+MQqRmGwNS3cedTl5iOLhj9YsrLvJrkHr3VYS1p2/Dpb2OpUK8RwtKUfY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKIzntdVMsy2PadnvIItF/GW6OegAT0nwUvHMs3rmUEgVNgVa7q
	Io+xUdb01y77QCWMCU5trqjFW9azXwkXoe7Qm+qr3YgzqgLYXCXo4p8VYW8rdAHPk6g3mNoyHdv
	dncudrgXl9uhiP2gJ0koksXAC5hdatutLX7NR8wu510LVa/KuEZIqTQ4SkkY=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1910:b0:4dc:1374:99ae with SMTP id
 5614622812f47-5640e033037mr9173554b6e.56.1793680438963; Mon, 02 Nov 2026
 20:33:58 -0800 (PST)
Date: Mon, 02 Nov 2026 20:33:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae96436.abb90550.19e2c9.0002.GAE@google.com>
Subject: [syzbot] Monthly netfilter report (Nov 2026)
From: syzbot <syzbot+list484d79b18bdec1b120a0@syzkaller.appspotmail.com>
To: fw@strlen.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello netfilter maintainers/developers,

This is a 31-day syzbot report for the netfilter subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/netfilter

During the period, 1 new issues were detected and 0 were fixed.
In total, 13 issues are still open and 200 have already been fixed.
There are also 3 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 151     Yes   INFO: rcu detected stall in rescuer_thread (2)
                  https://syzkaller.appspot.com/bug?extid=d5f7a5097c24c7c2dbbb
<2> 7       Yes   INFO: task hung in nf_tables_valid_genid (3)
                  https://syzkaller.appspot.com/bug?extid=83439cb981624bd8d068
<3> 199     Yes   INFO: rcu detected stall in br_handle_frame (6)
                  https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
<4> 132     Yes   INFO: task hung in nfnetlink_rcv_msg (5)
                  https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
<5> 98      No    WARNING in nf_conntrack_cleanup_net_list (2)
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
