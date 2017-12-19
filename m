From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Unable to compile linux-kernel pulled from nf-next tree
Date: Tue, 19 Dec 2017 20:33:01 +0530
Message-ID: <CANMOCy3yF2xfJ6dvFO0qpYMnXDDRF0O62BA+byyH2ZHvCF+XnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:37135 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdLSPDC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 10:03:02 -0500
Received: by mail-ua0-f177.google.com with SMTP id l36so13164607uae.4
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 07:03:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I'm working on a task in netfilter and trying to compile linux-kernel
pulled from nf-next tree.
https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
but fail with these errors.
make--
Kernel: arch/x86/boot/bzImage is ready (#4)
MODPOST 4905 modules
fs/ufs/ufs.o: Invalid argument
scripts/Makefile.modpost:92: recipe for target '__modpost' failed
make[1]: *** [__modpost] Error 1
Makefile:1211: recipe for target 'modules' failed
make: *** [modules] Error 2

sudo make modules_install install--
cp: cannot stat 'net/nsh/nsh.ko': No such file or directory
At main.c:291:
- SSL error:02001002:system library:fopen:No such file or directory:
bss_file.c:175
- SSL error:2006D080:BIO routines:BIO_new_file:no such file: bss_file.c:178
sign-file: /lib/modules/4.14.0-rc8+/kernel/net/nsh/nsh.ko: No such
file or directory
scripts/Makefile.modinst:36: recipe for target 'net/nsh/nsh.ko' failed
make[2]: *** [net/nsh/nsh.ko] Error 1
Makefile:1232: recipe for target '_modinst_' failed
make[1]: *** [_modinst_] Error 2
Makefile:527: recipe for target '__build_one_by_one' failed
make: *** [__build_one_by_one] Error 2

Any help will be appreciated.
Thanks.

Regards,
Harsha Sharma
