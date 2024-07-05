Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D951F1487FE
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720178285; cv=none; b=NTbX22PrSeI8MG/B9z5+QMeC79O4jvBNK2pzBuVVJEQyyK+92Crmw+oeUerFYx/6fLuhyysH/YgpUWvhxvpjWhuwZmkT5NgJz2fs53i56g54TInkgLZvZL8r1cohVBoGyTcsHOzpEWTs/QqZ6Hj5L8Hsm+x6/mR3iyGPfIJTH44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720178285; c=relaxed/simple;
	bh=DcEvBQzYn4eHzbpGBy15PzrDsQIOG4YC35uyd6YyNUg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=CoJl8pv7+FbjChP2q267M7acd8T5sDosrMs1B12px6Om84l4YHzHGDNzhxKu27yb3j/6p9+MX73PYwEfE70q5ZM0irotDLQ7KGPGZOvA/xEeYsHN2zwHUE30JXDX6y+oNUYfwkyChoRPahrJADNHh9+h6xZBfp43vPfGqwJA87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7f664993edbso203570839f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2024 04:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720178283; x=1720783083;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcXD0BG3kuwJsqIbgzDKmojoQKPo+GlBR5V8khmyXns=;
        b=ehtdXaBHO6lXnSt95xeXHNrszcfUqodSuh6BxaFkMphLc8/cXx2TWBEm39u7vhOUHx
         /R4NVSBptAYnoxq3zDW0fcW8yZwgQ6j7uh3f085UzfyQZ09uEhaZ4sOEzUGejcT4nTAY
         bOvFCPcqrLqALBRmQIVtkhEIO/6CiiipePmfRLVljZZb96FOvpACUQD2ULMJC1lE3RAq
         2ugWH/KWX8hFk0OcwuOPlFvKDtBxLSjWh2rz3j8FkyH4K7FX04ypIhZUgFImHuRMuW0N
         z9Km+wSHHUXG0oSAprH0u9mrIBZkpNMolaGPZhFnuxXRaEG41lhPBWnjZOPsmz2wWY3z
         bgSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsUMdx14WfZtxnIAU2jS8pbtJKBKmGUtPD8T6mwIrizcds1ERTsGrB+2wKxeCV4D4rp18lYbUqcRCiu4VW1RO93auFQOlai+9x+oVbYtTn
X-Gm-Message-State: AOJu0YwMfd0ODxLpBnSL9GEmbVREKDUAupMcBV/rBnDyp2Db/eCg6HLn
	lDnJExQLzZWe97a39fD14vtxek1onDuZxzu0Qwldqgl6J7Hgonrb5FQL6yBL+/WBj9/pTDeah7u
	DKwpUsdeI0e+FhysFvTIBgRrvyE5Sr5rjS7nkuJZ5pm2ju7X6l8T2eyg=
X-Google-Smtp-Source: AGHT+IFMVpbI/oyUD/Nzf6SMZz+ORuXDMuVeo/VwepvtWQMChUOmoisakOynndWpToGIlO7sv74oPSteHwMvhUCQGIieG7LgFupM
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:35ac:b0:4c0:7f51:c3c5 with SMTP id
 8926c6da1cb9f-4c07f51da77mr85862173.1.1720178283056; Fri, 05 Jul 2024
 04:18:03 -0700 (PDT)
Date: Fri, 05 Jul 2024 04:18:03 -0700
In-Reply-To: <20240705104821.3202-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000832194061c7e37c3@google.com>
Subject: Re: [syzbot] [netfilter?] KASAN: slab-use-after-free Read in nf_tables_trans_destroy_work
From: syzbot <syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com>
To: fw@strlen.de, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com

Tested on:

commit:         1c5fc27b Merge tag 'nf-next-24-06-28' of git://git.ker..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=152db3d1980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5264b58fdff6e881
dashboard link: https://syzkaller.appspot.com/bug?extid=4fd66a69358fc15ae2ad
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1395cd71980000

Note: testing is done by a robot and is best-effort only.
