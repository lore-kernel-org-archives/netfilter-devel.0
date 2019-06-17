Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC43AC31E5C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 14:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B5AC20833
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 14:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPW5MdbT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfFQOqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:46:19 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36953 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfFQOqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 10:46:19 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so16555017eds.4;
        Mon, 17 Jun 2019 07:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DFwUk4yWVrkIKls5uUFDnuAo5aYcJdkpGFX5fTaw8lw=;
        b=PPW5MdbTM1PeJvIuLyEFP3Z953FunXbOd0TAdw9889WsHzw1N9R+h3Dqabkw0V0hGO
         ZFzley0cv/tNHZAsUtJPPhMeVm/ErJ12zVSOLOyX+nPCedy3ojWJKSt1i0F6aQ6twRpu
         eqXrZO96EdeVVxRfPMnBJoR72sAyD8K3seKSfaOHIGfGL1qSRsBemiuytW7snlE9A+/t
         YaNoUOymDFLGKGnvA+0Pw1CuItpIkt7l/F5UAPQynkEqH41Mm6S5NOy9GAvDsTQgIWdk
         U3CKfFE5rspLq6B8BmMdIusKDC90i8FDGWFa//OEFvW3fLSG+LGxAuL7uBXse+x7gswI
         Q61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DFwUk4yWVrkIKls5uUFDnuAo5aYcJdkpGFX5fTaw8lw=;
        b=c585sNJiLlq9OKJYGDb5tW12CgoCEeKfDLKr9W4fSgDY5o1SMvWJ39ZgQO3iDu7eXA
         cSYt2S3FvoWgqckPo9YsABlOZFy1Ati1rr0nepn17YHZljbultlTf9rx9fnMmhM2pNeB
         5cIf3nF6D1gx337tUOZZ8ZFcCOLln/mCmjebVQR8bmi7ktTfrt5SyOAhHA8pDLmMkeG0
         KvEVjysp3meGwYAdNVTmmf1x+rpYEfoT2N5ppJNYeKwqd1ib9OAaVxhcwANm6CaUCNa/
         XFusBnRPVD9e3zIIFEh9d3r9MRIOIZlEk3APdx1Jk48icgAzF7iZpyjhE3yzkRmjCk4H
         diAw==
X-Gm-Message-State: APjAAAU09udhqntBPG0vjJLGkYNaXyolN2H46TKQLlfhJjOAIY7Gygcz
        1wt59l438t73S0XlvnyVjUzDShjYTZ2S+m6b+FgHJ66x
X-Google-Smtp-Source: APXvYqx95AmBObf5OfLwzey/QGollvBxnQ2YWwB5KFZk6i5sxD11/HQzSA09G5eUuQ0AmPjysZYiHY0EUPnraGRV3eU=
X-Received: by 2002:a50:bdc2:: with SMTP id z2mr119153424edh.245.1560782776395;
 Mon, 17 Jun 2019 07:46:16 -0700 (PDT)
MIME-Version: 1.0
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Mon, 17 Jun 2019 17:46:04 +0300
Message-ID: <CADxRZqy=pCbwg6Lyio=GQ6gckR5B5Y=YQ1URPO0qn3YPAnUc0A@mail.gmail.com>
Subject: [sparc64] possible circular locking / deadlock
To:     Sparc kernel list <sparclinux@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     debian-sparc <debian-sparc@lists.debian.org>,
        coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

Getting the following git kernel trace on boot with rc.local having :

ipset create sshguard4 hash:net
iptables -A INPUT -p tcp --dport 22 -m set --match-set sshguard4 src -j DROP

current git kernel:

$ uname -a
Linux ttip 5.2.0-rc5 #981 SMP Mon Jun 17 09:52:04 MSK 2019 sparc64 GNU/Linux
linux-2.6$ git desc
v5.2-rc5


$ dmesg
<cut>
[   10.356388] Adding 787176k swap on /dev/vdiska4.  Priority:-2
extents:1 across:787176k FS
[   10.471900] EXT4-fs (vdiska1): mounting ext3 file system using the
ext4 subsystem
[   10.487226] EXT4-fs (vdiska1): mounted filesystem with ordered data
mode. Opts: (null)
[   11.158102] random: crng init done
[   11.158155] random: 7 urandom warning(s) missed due to ratelimiting

[   11.697866] ======================================================
[   11.697875] WARNING: possible circular locking dependency detected
[   11.697886] 5.2.0-rc5 #981 Not tainted
[   11.697894] ------------------------------------------------------
[   11.697902] iptables/732 is trying to acquire lock:
[   11.697913] 000000004f61aa56 (&table[i].mutex){+.+.}, at:
nfnl_lock+0x24/0x40 [nfnetlink]
[   11.697937]
               but task is already holding lock:
[   11.697946] 000000000d652829 (&net->nft.commit_mutex){+.+.}, at:
nf_tables_valid_genid+0x18/0x60 [nf_tables]
[   11.697973]
               which lock already depends on the new lock.

[   11.697983]
               the existing dependency chain (in reverse order) is:
[   11.697992]
               -> #1 (&net->nft.commit_mutex){+.+.}:
[   11.698012]        __mutex_lock+0x48/0x920
[   11.698021]        mutex_lock_nested+0x1c/0x40
[   11.698033]        nf_tables_valid_genid+0x18/0x60 [nf_tables]
[   11.698043]        nfnetlink_rcv_batch+0x24c/0x620 [nfnetlink]
[   11.698053]        nfnetlink_rcv+0x110/0x140 [nfnetlink]
[   11.698067]        netlink_unicast+0x12c/0x1e0
[   11.698076]        netlink_sendmsg+0x324/0x360
[   11.698091]        sock_sendmsg+0x34/0x80
[   11.698099]        ___sys_sendmsg+0x228/0x240
[   11.698108]        __sys_sendmsg+0x4c/0x80
[   11.698116]        sys_sendmsg+0x18/0x40
[   11.698131]        linux_sparc_syscall+0x34/0x44
[   11.698138]
               -> #0 (&table[i].mutex){+.+.}:
[   11.698157]        lock_acquire+0x1a4/0x1c0
[   11.698165]        __mutex_lock+0x48/0x920
[   11.698173]        mutex_lock_nested+0x1c/0x40
[   11.698181]        nfnl_lock+0x24/0x40 [nfnetlink]
[   11.698196]        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
[   11.698207]        set_match_v1_checkentry+0x14/0xc0 [xt_set]
[   11.698222]        xt_check_match+0x238/0x260 [x_tables]
[   11.698234]        __nft_match_init+0x160/0x180 [nft_compat]
[   11.698244]        nft_match_init+0x18/0x40 [nft_compat]
[   11.698256]        nf_tables_newrule+0x57c/0x7a0 [nf_tables]
[   11.698266]        nfnetlink_rcv_batch+0x3f8/0x620 [nfnetlink]
[   11.698275]        nfnetlink_rcv+0x110/0x140 [nfnetlink]
[   11.698284]        netlink_unicast+0x12c/0x1e0
[   11.698292]        netlink_sendmsg+0x324/0x360
[   11.698300]        sock_sendmsg+0x34/0x80
[   11.698309]        ___sys_sendmsg+0x228/0x240
[   11.698317]        __sys_sendmsg+0x4c/0x80
[   11.698325]        sys_sendmsg+0x18/0x40
[   11.698334]        linux_sparc_syscall+0x34/0x44
[   11.698340]
               other info that might help us debug this:

[   11.698351]  Possible unsafe locking scenario:

[   11.698359]        CPU0                    CPU1
[   11.698366]        ----                    ----
[   11.698372]   lock(&net->nft.commit_mutex);
[   11.698381]                                lock(&table[i].mutex);
[   11.698390]                                lock(&net->nft.commit_mutex);
[   11.698400]   lock(&table[i].mutex);
[   11.698408]
                *** DEADLOCK ***

[   11.698418] 1 lock held by iptables/732:
[   11.698424]  #0: 000000000d652829 (&net->nft.commit_mutex){+.+.},
at: nf_tables_valid_genid+0x18/0x60 [nf_tables]
[   11.698444]
               stack backtrace:
[   11.698454] CPU: 6 PID: 732 Comm: iptables Not tainted 5.2.0-rc5 #981
[   11.698463] Call Trace:
[   11.698471]  [00000000004cfde0] print_circular_bug+0x2e0/0x320
[   11.698480]  [00000000004d4bd8] __lock_acquire+0x1d38/0x2900
[   11.698489]  [00000000004d6084] lock_acquire+0x1a4/0x1c0
[   11.698498]  [0000000000a06508] __mutex_lock+0x48/0x920
[   11.698506]  [0000000000a06dfc] mutex_lock_nested+0x1c/0x40
[   11.698516]  [000000001071c024] nfnl_lock+0x24/0x40 [nfnetlink]
[   11.698527]  [00000000107568dc] ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
[   11.698537]  [000000001078e5d4] set_match_v1_checkentry+0x14/0xc0 [xt_set]
[   11.698549]  [0000000010310ed8] xt_check_match+0x238/0x260 [x_tables]
[   11.698559]  [000000001077cc00] __nft_match_init+0x160/0x180 [nft_compat]
[   11.698569]  [000000001077ccb8] nft_match_init+0x18/0x40 [nft_compat]
[   11.698582]  [0000000010731c3c] nf_tables_newrule+0x57c/0x7a0 [nf_tables]
[   11.698592]  [000000001071d238] nfnetlink_rcv_batch+0x3f8/0x620 [nfnetlink]
[   11.698602]  [000000001071d570] nfnetlink_rcv+0x110/0x140 [nfnetlink]
[   11.698611]  [000000000093e82c] netlink_unicast+0x12c/0x1e0
[   11.698620]  [000000000093f484] netlink_sendmsg+0x324/0x360



Full kernel configuration file as well full dmesg messages are
available at https://github.com/mator/sparc64-dmesg/

system info:

$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/sparc64-linux-gnu/8/lto-wrapper
Target: sparc64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian
8.3.0-7' --with-bugurl=file:///usr/share/doc/gcc-8/README.Bugs
--enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++ --prefix=/usr
--with-gcc-major-version-only --program-suffix=-8
--program-prefix=sparc64-linux-gnu- --enable-shared
--enable-linker-build-id --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --libdir=/usr/lib
--enable-nls --enable-clocale=gnu --enable-libstdcxx-debug
--enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new
--enable-gnu-unique-object --disable-libquadmath
--disable-libquadmath-support --enable-plugin --enable-default-pie
--with-system-zlib --disable-libphobos --enable-objc-gc=auto
--enable-multiarch --disable-werror --with-cpu-32=ultrasparc
--enable-targets=all --with-long-double-128 --enable-multilib
--enable-checking=release --build=sparc64-linux-gnu
--host=sparc64-linux-gnu --target=sparc64-linux-gnu
Thread model: posix
gcc version 8.3.0 (Debian 8.3.0-7)

# ldconfig -V
ldconfig (Debian GLIBC 2.28-10) 2.28

# ld -V
GNU ld (GNU Binutils for Debian) 2.31.1

PS: i wasn't able to trace which kernel version introduced this
possible deadlock... but tried (from top git tag v5.2-rc1 to bottom)
up to 4.13 kernel version...
