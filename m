Return-Path: <SRS0=kfn4=SQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F624C10F13
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 20:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76D02084D
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 20:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="hNTJTAJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfDNUIN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 16:08:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43353 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfDNUIN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 16:08:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id n8so7501227plp.10
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 13:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=APE1+5Wvf+xwt+gAjLgAiPB8zAu3NBFsDQCMn4otx0w=;
        b=hNTJTAJ2tkSO2jsnr2m80fzaBiOmdbfaPsIcE0EHbZby0KMa+1zY3IsmEMGsd4T6fy
         UO26mMe4ADsd+iVe4YNUzwq4WITSs6lF6iiaOGK+KdhCXZu1uFHgvzHXSrVr6eeRhQhP
         maf+oNQLMKAFkUbwSCmQ5JB20Pds032OHVkvy/7at2dGrguGu+cSoqRLsY/ksY4Hb0Bt
         jFxnwuYgnVcB6rwzP34/IylEQQH0gF/jHc0U6HbwGR+sjRJur5qKrcjEcORKM2F81WCX
         TQA/b1thezdRQxoxrtzYNIGnPfepbShEn5++VelOHAtmyjWlfOQuvAMfaz5QgS057LOH
         TVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=APE1+5Wvf+xwt+gAjLgAiPB8zAu3NBFsDQCMn4otx0w=;
        b=qA6kvz/VkpYvTMgGBDyrqzpcyAA+Q4YMNtsHeCZN2SxHd4ndQqJPKLFgZi+RakKwNt
         XeOLE5ef12RDOf6BBckRq4HQ57r3gWJMfv3zqcNTsiTA6YkkeNYSFNIzrpiLb0nuOsEe
         B4e2n1vfxnQoBxxun0wOHvVB99J27qhGA/eo1PgeSkM5i+wJXfpFZiMoHTwosO7K2z3G
         FDysgf/kJwQoTP+QoeDDi5isC4/ZAI2kawGsamL03oT7rVZkPCAz6lZWnPRbESDpoTEr
         IEV5Ub5gSWGIrk+c2h+bScp409c1KXrQM2kQIQq1pA2pd5iu6OCwqA8ZVlNbrswODuWf
         y4KQ==
X-Gm-Message-State: APjAAAU+9W1kz5z09gp27tnf1YFV2kjxPTEoxsNV8Gu5ZWyuo8FV8XXn
        /i2TX9s7K7LBfpc8jOmr16ZVnA==
X-Google-Smtp-Source: APXvYqw+WLg9J949GQ9BO8rLoRcqgqtuWDdn+K1Sr4VfQFZpzkngVA8rIOP/xR/PMJW6gdI0fBQZsw==
X-Received: by 2002:a17:902:61:: with SMTP id 88mr29500016pla.166.1555272492570;
        Sun, 14 Apr 2019 13:08:12 -0700 (PDT)
Received: from ?IPv6:2600:1010:b026:b512:2540:dce2:f491:4435? ([2600:1010:b026:b512:2540:dce2:f491:4435])
        by smtp.gmail.com with ESMTPSA id m8sm51172813pgn.59.2019.04.14.13.08.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Apr 2019 13:08:11 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: WARNING in compat_copy_entries (2)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <00000000000019eb000586826c2a@google.com>
Date:   Sun, 14 Apr 2019 13:08:09 -0700
Cc:     alexl@redhat.com, bridge@lists.linux-foundation.org,
        coreteam@netfilter.org, cosimo@endlessm.com, davem@davemloft.net,
        dvyukov@google.com, fw@strlen.de, kadlec@blackhole.kfki.hu,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nicholson@endlessm.com,
        pablo@netfilter.org, peterz@infradead.org, raji@linux.vnet.ibm.com,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        tuliom@linux.vnet.ibm.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E15851D-59E4-455D-985E-65F066E7A85A@amacapital.net>
References: <00000000000019eb000586826c2a@google.com>
To:     syzbot <syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is likely a confused bisection.  I bet that reverting this patch breaks=
 your test but has nothing to do with the bug. Try reproducing with socketca=
ll() to bisect farther.

--Andy

> On Apr 14, 2019, at 12:20 PM, syzbot <syzbot+659574e7bcc7f7eb4df7@syzkalle=
r.appspotmail.com> wrote:
>=20
> syzbot has bisected this bug to:
>=20
> commit 9dea5dc921b5f4045a18c63eb92e84dc274d17eb
> Author: Andy Lutomirski <luto@kernel.org>
> Date:   Tue Jul 14 22:24:24 2015 +0000
>=20
>    x86/entry/syscalls: Wire up 32-bit direct socket calls
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D1736919f200=
000
> start commit:   ce380619 Merge tag 'please-pull-ia64_misc' of git://git.ke=
..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10b6919f200000=

> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D36fbc8c97ef985=
d3
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D659574e7bcc7f7eb=
4df7
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D179b4d8b8000=
00
>=20
> Reported-by: syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
> Fixes: 9dea5dc921b5 ("x86/entry/syscalls: Wire up 32-bit direct socket cal=
ls")
>=20
> For information about bisection process see: https://goo.gl/tpsmEJ#bisecti=
on
