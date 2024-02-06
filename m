Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05DA1CAA5
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 23:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261847; cv=none; b=MEYODlXLXUCuvgHuAHtj55SGxIZ47e9J0pD3bMiPaFplhrgXiV5UxkO876ONJe4rfoqX37BKLd73qjPJgf5UiojP/8wlCHXU9zqesxbEf3aYt4QwW2uKkWyBqsLw1+S5vJ6dBjg0ehgKrad8CGODy4uWJ3Paifcp+cXk6Ro6XVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261847; c=relaxed/simple;
	bh=avaOUcgWWADF6KLGwzoW9QsC+X9ueBhEDEJuX1SutnY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YEdDfY44y7Q4IyTQZEGgDPwi1A96EXkWDYb6ms0Ho7mjZqZecQbDh9EXygjWXwVYXQ/v0qE7zz5EyAXis7LgvbPh4zoF8Un05FwKeK0F/Ef5ebJ1r9viQykQynjZOIXeDYpoHeOa6402hI42sk8EmJc475V1HUjPBeq+jYgD6qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-363da08fc19so181015ab.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2024 15:24:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707261845; x=1707866645;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dyU9aBXxURAl9A5KuV1JqmHm0E55rA4SNAlAUuaADxs=;
        b=hzUoJYKfTlEqh6T3LLeJe0Q0LuLkPn6OAHHVLVircuufCtwZN0jr1WSBh0QZ/gimfW
         N+DCQlUFHFfC8nSGnhFOMVjJ879t4Jslg2amr/AEBRVGRz6Y173erKJrjM0VjE3CFIH2
         7I5wbQN+CzxgBB9PazyZEeVgYRxIoF+njJGz0wLIBia0Rd9MDSzRcPXh98/hzr9oirCU
         CEt0MfKUIk1ooMboGWDtYGtxiyeXqZ/9JwUkluIqv6t/MLoVJoo01p5bDQsejXjAJGce
         W+ZDDHGUGnTkV4I/fxXLiUH8UPaypRn2G3/sgrmgpCYNrYIA6mCH/vsgHO5ffXAPxh4R
         7v8A==
X-Forwarded-Encrypted: i=1; AJvYcCVnL9lLASJ+zmBsx3eBvxC9Lq4tVP9LXvrM3wE/5eIK5JxArb5fZz7yZhP8dmv5faMfyQzui7aPTm//dFd5z9WMqVhFXYmWjkrF4NtRj++p
X-Gm-Message-State: AOJu0YwVQsAYafIt/3QlT0c1MARuSp59rjBkf9x5vGLN17TY8yPFDMtp
	Xf3QgEugNioZ79OfuKUyisR8JYPMHfK9b828F8yk3qiDS4xZjUuRk7T3ayZ47Ts9J26CgyF210E
	biaVYI9Ywgs7kqIRIk8W2kG0vLfsMicRoRS8GoRJsWJrXmFZhZLonf8s=
X-Google-Smtp-Source: AGHT+IGSXSHoJP49btDMUUbQR8POUN20RhhYPv9Heu/t1qcOYXiDcq7JQgRofse+fmN8ylccOMewqdmAQJFGKKPWHm8kVCz6GLrK
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9e:b0:363:ca65:7d12 with SMTP id
 h30-20020a056e021d9e00b00363ca657d12mr207768ila.6.1707261845064; Tue, 06 Feb
 2024 15:24:05 -0800 (PST)
Date: Tue, 06 Feb 2024 15:24:05 -0800
In-Reply-To: <0000000000009655270610aafce1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d053f20610bedf3b@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING: suspicious RCU usage in hash_netportnet6_destroy
From: syzbot <syzbot+bcd44ebc3cd2db18f26c@syzkaller.appspotmail.com>
To: 00107082@163.com, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, fw@strlen.de, justinstitt@google.com, 
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15790a38180000
start commit:   021533194476 Kconfig: Disable -Wstringop-overflow for GCC ..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17790a38180000
console output: https://syzkaller.appspot.com/x/log.txt?x=13790a38180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f204e0b6490f4419
dashboard link: https://syzkaller.appspot.com/bug?extid=bcd44ebc3cd2db18f26c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16329057e80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b8fe7be80000

Reported-by: syzbot+bcd44ebc3cd2db18f26c@syzkaller.appspotmail.com
Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
