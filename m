From: martinbarrowcliff <martinbarrowcliff@gmail.com>
Subject: xtables-addons build fails
Date: Mon, 14 Jun 2010 17:37:13 -0400
Message-ID: <4C16A109.7050404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54017 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0FNVmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:42:12 -0400
Received: by gwj15 with SMTP id 15so2815415gwj.19
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2010 14:42:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A little compile problem here with xtables-addons-1.26 (and 1.27).
This is a new system. linux-2.6.34, Gcc-4.5. It runs fine otherwise.
Iptables is working. Networking is up.  Ipset compiles and works.
Kernel and modules all build. All other apps compile fine so far.
I have root access via a remote term.
The same xt-a source compiles and runs on my other systems but not here?

The source builds to this point, then compile fails as below:

make[3]: Leaving directory `/usr/src/kernels/linux-2.6.34'
make -f ../Makefile.iptrules all;
make[3]: Entering directory `/usr/src/build/firewall/xtables-addons-1.27/extensions'
  CC     libxt_IPMARK.oo
libxt_IPMARK.c:156:2: warning: implicit declaration of function 'ALIGN'
libxt_IPMARK.c:156:19: error: initializer element is not constant
libxt_IPMARK.c:156:19: error: (near initialization for 'ipmark_tg_reg.size')
libxt_IPMARK.c:157:19: error: initializer element is not constant
libxt_IPMARK.c:157:19: error: (near initialization for
'ipmark_tg_reg.userspacesize')
make[3]: *** [libxt_IPMARK.oo] Error 1
make[3]: Leaving directory `/usr/src/build/firewall/xtables-addons-1.27/extensions'
make[2]: *** [user-all-local] Error 2

Here is where it fails in the source. Looks fine to me...
(every extension fails the same way in same places)

static struct xtables_target ipmark_tg_reg = {
        .version       = XTABLES_VERSION,
        .name          = "IPMARK",
        .family        = NFPROTO_UNSPEC,
        .revision      = 1,
>>>>>        .size          = XT_ALIGN(sizeof(struct xt_ipmark_tginfo)),
>>>>>        .userspacesize = XT_ALIGN(sizeof(struct xt_ipmark_tginfo)),
        .help          = ipmark_tg_help,
        .init          = ipmark_tg_init,
        .parse         = ipmark_tg_parse,
        .final_check   = ipmark_tg_check,
        .print         = ipmark_tg_print,
        .save          = ipmark_tg_save,
        .extra_opts    = ipmark_tg_opts,
};

I don't really know why gcc is failing here; this is a new problem.
The compiler passed all tests. Looks like a missing header, but
I checked and have the whole API as far as I can tell.
I must have goofed somewhere?  Can someone offer insight to this?

BTW, must mention, latest lzma says the 1.27.xz file
on sourceforge is corrupt. I used the git source instead.
Still failed.

Marty B.







