Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D8A1B59D
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709764685; cv=none; b=T5me7kqjZ5jRxh7D+nLVgy2fWcn1tgjQS2KriA9MkB20xVEy79NxM66iCEKz+kk2laEHJVEBUFbfSTySqywFq03F3K9q1V0Uhyg+EaxDK9WUJgfGXXoxLQOCfu55+gIV9ygkfnA2rINF5zZstKFN2whBKfvWtcVWFPYteZBYdmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709764685; c=relaxed/simple;
	bh=aONfvMBLi+nGa8z5RQpjQsVQe9F1v8fIwL3IxZQZEyI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FZniR6yFuXjR9Bjy4qlsiO3WQ9+Ie1t5aGgoe7ooE4pt8tM4B6hGOe0agJzXjMRwUmC0Chs/4nDQs8P0OsLzhhOgx85D7QQ0FI3XC+r6PY3Ovwd9McYVsXm5o24F4atkz6q0LeZUfSeiJ2Blf/Y2wA7yKr6hRF7XRLbywFyhdPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c7e21711d0so29995639f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Mar 2024 14:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709764682; x=1710369482;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQx8oyVkoBQfTgwpCDc5Joc1fA/0UhEcaF4wgBQJJZ8=;
        b=NGItxLlfEgj0+F4gocvYdO8YB5lc8uEh/SruMkg4MimnhzIXUk0AggkdtYgMrxtsIz
         JMMcSkog98y7vACeOVoA4lWH7OMQcfRQjOGolAuY2gKtUHfByQQ8qC+UIHQF16m4Nvke
         B+WwqbrcFjnIs0cG6ByAa1l+yGr/V2eXolR6Ro4e08Db+Qgs3YSxBlH1/0g+0DtTftmM
         YQ9CuCbgJ1ehTNclmndhC06y+2fX9XsKMZdefIH2ptBAtI2X6fmr11i4kew9Q2YLF3vc
         qhAonXFeIwiRAN4xGsX2yvsKOelfrzUNmcyVkJ4OB6GeHRzA2lTr5c1uC3MPqge6Tc05
         xvHA==
X-Forwarded-Encrypted: i=1; AJvYcCVGoSlUVMr+SYvNVhHDoaveLG2Zicackdw/KSxk1IE07qOFBzW7OTS8ElT5QPEs7z5cUQv+rFO/qoCiVIt/wxaevagw2Q3orA8spgYhtesN
X-Gm-Message-State: AOJu0YwKQhWnKIlO/LgFmYH3NVF6v/fYBADTRPFdD4ZCudB4OVk0rgo2
	pOywZjR0psYhCnLQXDoAL5LSlaFfpA4dZieOzVf2ZarvveUI45sE82yKenSI7t16t7vmYeiZKLM
	S0Vy6w3sLGcJKAfuP9pUKj+7FkHGDeZMcir8w9LazEIvwAbgO/S+7gVA=
X-Google-Smtp-Source: AGHT+IGUeFlmZ563e7wj+Rf7wOdbVjqxtWnT0cqDf2LCScDa5TAdV8QLnpmJdPdM1DX82HvmD30tfAYPKrbIiXL+LIblSWlVilKs
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2181:b0:474:c5e2:384c with SMTP id
 s1-20020a056638218100b00474c5e2384cmr727865jaj.4.1709764682541; Wed, 06 Mar
 2024 14:38:02 -0800 (PST)
Date: Wed, 06 Mar 2024 14:38:02 -0800
In-Reply-To: <0000000000000c439a05daa527cb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008d7cfe0613059c97@google.com>
Subject: Re: [syzbot] [netfilter?] INFO: rcu detected stall in gc_worker (3)
From: syzbot <syzbot+eec403943a2a2455adaa@syzkaller.appspotmail.com>
To: bpf@vger.kernel.org, coreteam@netfilter.org, davem@davemloft.net, 
	dvyukov@google.com, edumazet@google.com, fw@strlen.de, gautamramk@gmail.com, 
	hdanton@sina.com, jhs@mojatatu.com, jiri@resnulli.us, kadlec@netfilter.org, 
	kuba@kernel.org, lesliemonis@gmail.com, linux-kernel@vger.kernel.org, 
	michal.kubiak@intel.com, mohitbhasi1998@gmail.com, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	paulmck@kernel.org, sdp.sachin@gmail.com, syzkaller-bugs@googlegroups.com, 
	tahiliani@nitk.edu.in, tglx@linutronix.de, vsaicharan1998@gmail.com, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 8c21ab1bae945686c602c5bfa4e3f3352c2452c5
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Aug 29 12:35:41 2023 +0000

    net/sched: fq_pie: avoid stalls in fq_pie_timer()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1338df0e180000
start commit:   d4a7ce642100 igc: Fix Kernel Panic during ndo_tx_timeout c..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=77b9a3cf8f44c6da
dashboard link: https://syzkaller.appspot.com/bug?extid=eec403943a2a2455adaa
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1504b511a80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137bf931a80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net/sched: fq_pie: avoid stalls in fq_pie_timer()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
