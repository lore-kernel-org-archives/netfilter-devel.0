Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3CE1CD2C
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 06:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707288607; cv=none; b=NXcqzjvFXcHI5PCKCBxCNCLb+NmAy5tPpQokYnVYuFrKqJ8LY+mxgEy0CbEn68XeYadXT6uq8mGW5ecnF7mvUCWyfB/ZWo8ELVpJKAZBZ2PbMkgRT5p5SeZVvYDfFMzHbfbk7j2c5+/Rf3XS/bfr8t4MoHU4RWOIRWWv8xxOirE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707288607; c=relaxed/simple;
	bh=txwgru8ukqwseSHIc0ZyhJJEtXFoGOV/G4cX6j4bgyc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s9ohrTGbBAXcSvYXQ5mBN+FSu12L67ZciE4xGFm7gWaRZYXEwQFPSzMCF+9+/CrtaB81GZIpqGg8dZAx8LW1E1p6dgaLfCa/gQso5o+VIimLGPCF5fd0AfV28KD9hurODB8oTIIeD9Ys2DDOIdX1MCCBGH1pgfVZayeTONE/4Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7bef5e512b6so30283339f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2024 22:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707288605; x=1707893405;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JJp9PiIxbgAEsE0ISqJs+jF6VAx9STrKEpa7F04AncM=;
        b=LnE4ZWQPEKkaGAO4SYaSrHLmfWdSuxUSpwn/6Ik+xDrPYXXkcnXJCkaSLBSWtH9cA4
         E+kSHId5oDsqm74Lx0ylKCYd1S2ahHAxG0RLFjpGK4u+O5SSc8FmSkEdy/doJ0GwEa8+
         TCypLys+E5dawxUM94Cq80R9/h+qr5/W33CEundyshdxvyO639iRhMTvPk4vrTm//9pE
         lxqt1a3UCTzZEv5LlYQCD6hNLyzLiKe7v37bG7GEWPKWZM8/lDnD8Ipiycnns7ViNTI+
         7czxr4o3Z07Yxyey6BazkXae3TI0L5B6KkPX45v2hTJ87z+FBmQDkJl4qHiBiuCAsYIf
         AHAA==
X-Gm-Message-State: AOJu0YznqM6JWzkm574ivGuCoSgeS3iTaxX2sZ7/ltoOSR2msfV+06Al
	cGC8TsyjhL/vncIxZbqZdauAdbKcnmtJ+BrA5KaB9ZSux2k5m84SjsEnSEeHqv+MFjxe/a0fdMj
	CjlJbX9+rZguvmlqB5H+0oYJjbmceTcEwe4lhZ6jbS6qVOY58KsGbd6k=
X-Google-Smtp-Source: AGHT+IHIQD5e5Ra5jnAc0Lil23mYT3rezE8/io/0zI23XRimBC6ndhE/lGbLe2e9vRJfEQFrO/zPDUHLra9PuBS5SabQnmstnc37
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160d:b0:363:ab40:78c7 with SMTP id
 t13-20020a056e02160d00b00363ab4078c7mr314018ilu.6.1707288605030; Tue, 06 Feb
 2024 22:50:05 -0800 (PST)
Date: Tue, 06 Feb 2024 22:50:05 -0800
In-Reply-To: <000000000000ecb4750610659876@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5018e0610c51a8e@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING: ODEBUG bug in hash_netiface4_destroy
From: syzbot <syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com>
To: 00107082@163.com, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, fw@strlen.de, hdanton@sina.com, justinstitt@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, kuniyu@amazon.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 97f7cf1cd80eeed3b7c808b7c12463295c751001
Author: Jozsef Kadlecsik <kadlec@netfilter.org>
Date:   Mon Jan 29 09:57:01 2024 +0000

    netfilter: ipset: fix performance regression in swap operation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=179ff138180000
start commit:   6897cea71837 Merge tag 'for-6.8/dm-fixes' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=145ff138180000
console output: https://syzkaller.appspot.com/x/log.txt?x=105ff138180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=457249c250b93697
dashboard link: https://syzkaller.appspot.com/bug?extid=52bbc0ad036f6f0d4a25
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174bd5d3e80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fcf5b0180000

Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
