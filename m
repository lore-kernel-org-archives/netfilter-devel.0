Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA7B1C5499
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Jul 2025 01:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753494185; cv=none; b=m8wdJ5A/yeoI2lsQN8MsA6wt2tNhDmcDVQ9HjmUqqFEgse1KO8GR0uNavG8t85KKXlwb9KuFUrIxDTZGGnPQK58qmsl4BtaH31Qo/YZ1ooSDO09EkyE2lgKtQHYJodo+9V2jOK7mgdwamCx1HOlseYaMtA9Auxun4xOEmF1egtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753494185; c=relaxed/simple;
	bh=EiRZkke/EwWZK+jioE2Brp8brltihridvzQx2QVTP5Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DQDISzBEaleihqoSf6sQuHVCx6bAgqjbKi4tOEGyQqFfAPsEcasmLhuxeQyQFmjTojctUJRLal/JTbGu8/tp9v/Yb3hO2rEz4XvFj4Kme+BNa7WJP55PE8eDZaJ+fzrvwo+ey/Zajuxe1Lt2aKFhVvw20mjPYVFBBX7jtzWpwdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e29ee0fb2dso24891715ab.3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 18:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753494183; x=1754098983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCUniYILMqleAH3xbE9+O1uxqI2C8yao5yj/kH/o7DI=;
        b=CjhYVA+OAg+4qis2E/lYujlohGLc/LAGFHbe4DVBItd7ywGXL6NcAPxQlpyaTWQyun
         Gy7kbBkbkTJp9FVFVNBo97g2c8mj7LFgBo3n5eFiCg8otmyN3TS/yhrsvvv3RHfCrY6t
         pVtItZ92yrqYFUP44UmB+u1B48GiKsHCkEJQJkIuCGT41IId4yYRKv/HEO+dXzIDRvKk
         wnJIEnzQJykeeQA2NaR9xA90Tq4HnFSlSE6z+kHigyAxmZXpVUmwqDLT38xaHlrip6Jp
         KYOU/WjvDD5M98qeTwmjUXcZj2jB6xu14MfWW/TqzQSFebmnac0zN9BEWg9U1hB0v5j1
         Qasg==
X-Forwarded-Encrypted: i=1; AJvYcCWZfh7YsZegwOLT23hAmRXWRmDbQxyLGomZA4176wuYQmiqM7DhmXg0HyasvuGGwgEQIZ6MLpUTkniCdQVUwjE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2DhDZgh2gcyVBqe0XW9wABtnNsKOK45PNq703W65BJ9daMXk4
	nFQ7wa+KpSfZucF56c3NUpWT8ngOrcZA7AoRAlt0QYeuJdIsG1KZQi+p7OJvq1EpeVWYZwu1z77
	aKf067Xp9UskHCObg7K/gb2frz2LHV3URGrDt47O/jPDN5Mqjh1InoCEmKBo=
X-Google-Smtp-Source: AGHT+IEThwMXKzDRO0MQ+2RmdbFxFmPNC/OTQrGwiLB1flNLtz2bsAnrcviKrT98ZcLhEMaHQvexFRHwRefEGLWJWAajKGc5UjSj
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3b86:b0:3e2:9a13:74fd with SMTP id
 e9e14a558f8ab-3e3c526fbd1mr56688995ab.6.1753494183251; Fri, 25 Jul 2025
 18:43:03 -0700 (PDT)
Date: Fri, 25 Jul 2025 18:43:03 -0700
In-Reply-To: <68837ca6.a00a0220.2f88df.0053.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688432a7.050a0220.1a379b.0001.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init (2)
From: syzbot <syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 7f3287db654395f9c5ddd246325ff7889f550286
Author: Florian Westphal <fw@strlen.de>
Date:   Sat Sep 7 14:07:49 2024 +0000

    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ff50a2580000
start commit:   94619ea2d933 Merge tag 'ipsec-next-2025-07-23' of git://gi..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1400d0a2580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1000d0a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ceda48240b85ec34
dashboard link: https://syzkaller.appspot.com/bug?extid=a225fea35d7baf8dbdc3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bf10a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d27fd4580000

Reported-by: syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com
Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
