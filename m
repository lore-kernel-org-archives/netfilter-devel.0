Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91D55C29
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 01:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730424610; cv=none; b=pNGBE+q2CXKqcXGw5KerA4EeIQG5LB3aqYOXWwNpwtx3pYouDcE147k87Ofl8QThK7qbCiB/YWzL4awWgNXNrdNr7CSen+Xq9iUUnfL8MmtXFfkt3CRcy0qY3EovvUlaym4wS8yXEM6ZKO1nx8p94Sb2+eOZTo1Uciw1XUEz8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730424610; c=relaxed/simple;
	bh=zTHtoB3tKjutMlHY+vdDzuxJOZwG9Q2qF1gd5/dnSQ4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ODDh6q/wWRFv/sD05boYARjtbEVcouMhu8f1PNOOw9wdvUXQ+TqGwkJP+SlMFfZtZOkIVzYeEsx5EgHGh1Bo/tvb3T0PWzJJxCdVVssTCp0pEk5M0JHHE4LoSAOImVE0aTQcrh5JmSKgYqWwHsaAvi4Vav1IVmMn4Kl4gYpZWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83abef51173so164460839f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 18:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730424603; x=1731029403;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TTx8Pkc/ULkMB25YnEZ2sz5xzsb50SUShkjtn2Uzgtk=;
        b=P3GalYo8ApB3cTN57r5Ulg71MjgPzccpbUiJjopn2wVhL17YkCb3pzKhYwUjcaAteQ
         pWSrZzkMN3g4yT0GJh7KBzr3EFNkdZ32HQqwJ45Z9MmAwBXdTcIduQAMPPyn0xq2V/Le
         b4hhiSShjn83qqAQH2J/FGuIeEVbag7HpL/ZePryr+FkHwdXsBFNrJlLbVh4KTsct2I7
         FbxiDRsDeJ4hkMlN67xyuwOUPau3Hh5fw6pASW5r6bl9PsMNdyQbIJIn1fOIJomtNEXK
         MPJ4HJRAGs8XXFgPqN7eDFtllmlC/5s3vg1s1/KYGD+9H43uU8QjKsjzkt0JzOb+e07G
         MGaA==
X-Forwarded-Encrypted: i=1; AJvYcCVTTxy6ZzMEcNfF6Af/qLtHC8xt8QfPfSIz6S8+fThl7/DgPA14VZTByMgDtDvDMK9BXsJljiL/9Xz4hMGE5ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzLoctgUzwefohMZO0xWOFRPEuVOqpiMyAbtkAZ/UEylksyjgD
	LK3a2Ac4bdvw39i0VJ9U/484Li0Bp9FIh33pkxwwSkyfoDvJl/b4Rayhb8OnDSfkqKQE5TyOF1J
	qqirXjOCFUMbMMYEsuKLlKSAB1zuiZItW4I4eN9dfnw7jAxX6sgqrVDg=
X-Google-Smtp-Source: AGHT+IF/iGjFSN3CX3FXliJcR+7/sefN9TRnsqo+hdrH+km5zgp622Jp80Ys88ISNfbFDe9cCPD2Fla0EDHTqw/Gd6zV0nQqPkjK
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1609:b0:3a4:e62b:4dfd with SMTP id
 e9e14a558f8ab-3a5e2458517mr111236185ab.7.1730424603451; Thu, 31 Oct 2024
 18:30:03 -0700 (PDT)
Date: Thu, 31 Oct 2024 18:30:03 -0700
In-Reply-To: <000000000000ce6fdb061cc7e5b2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67242f1b.050a0220.529b6.005e.GAE@google.com>
Subject: Re: [syzbot] [netfilter] BUG: soft lockup in batadv_iv_send_outstanding_bat_ogm_packet
From: syzbot <syzbot+572f6e36bc6ee6f16762@syzkaller.appspotmail.com>
To: a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, bsegall@google.com, 
	davem@davemloft.net, dietmar.eggemann@arm.com, edumazet@google.com, 
	juri.lelli@redhat.com, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch, mgorman@suse.de, 
	mingo@redhat.com, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	pabeni@redhat.com, pablo@netfilter.org, peterz@infradead.org, 
	rostedt@goodmis.org, sven@narfation.org, sw@simonwunderlich.de, 
	syzkaller-bugs@googlegroups.com, vincent.guittot@linaro.org, 
	vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit c662e2b1e8cfc3b6329704dab06051f8c3ec2993
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Sep 5 15:02:24 2024 +0000

    sched: Fix sched_delayed vs sched_core

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14886e87980000
start commit:   a430d95c5efa Merge tag 'lsm-pr-20240911' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=44d46e514184cd24
dashboard link: https://syzkaller.appspot.com/bug?extid=572f6e36bc6ee6f16762
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1481cca9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14929607980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: sched: Fix sched_delayed vs sched_core

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
