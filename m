From: Nicole <nicole@cats-muvva.net>
Subject: Non-Understood Message
Date: Tue, 13 Nov 2012 19:48:30 +0000
Message-ID: <50A2A40E.5050802@cats-muvva.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.cats-muvva.net ([195.69.92.234]:58900 "EHLO
	hosting.cats-muvva.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755668Ab2KMTyw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:54:52 -0500
Received: from [192.168.9.2] (workbench.cats-muvva.net [192.168.9.2])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "CAcert WoT User", Issuer "CA Cert Signing Authority" (not verified))
	by hosting.cats-muvva.net (Postfix) with ESMTPS id C945746F51
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 19:48:22 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear All,

Can someone help?

I find this message in dmesg:

MYTARGET.0 target: invalid size 65540 (kernel) != (user) 4

I've recompiled everything in site: kernel, iptables, xtables-addons,
MYTARGET, to no avail. I really cannot see what's wrong. I think it
means that there's a mismatch in size of between what the user-space
passes and what the kernel-space expects.

Many thanks

Nicole

here are some code snippets:

from libxt_MYTARGET.c

static struct xtables_target mytarget_tg_reg[] = {
    {
        .version       = XTABLES_VERSION,
        .name          = "MYTARGET",
        .revision      = 0,
        .family        = NFPROTO_IPV4,
        .size          = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
        .userspacesize = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
	...
    },
#ifdef WITH_IPV6
    {
        .version       = XTABLES_VERSION,
        .name          = "MYTARGET",
        .revision      = 0,
        .family        = NFPROTO_IPV6,
        .size          = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
        .userspacesize = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
        ...
    },
#endif
};

from xt_MYTARGET.c

static struct xt_target mytarget_tg_reg[] __read_mostly = {
    {
        .name       = "MYTARGET",
        .revision   = 0,
        .family     = NFPROTO_IPV4,
        .table      = "mangle",
        .target     = mytarget_tg,
        .checkentry = mytarget_tg_check,
        .destroy    = mytarget_tg_destroy,
        .targetsize = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
        .me         = THIS_MODULE,
    },
#ifdef WITH_IPV6
    {
        .name       = "MYTARGET",
        .revision   = 0,
        .family     = NFPROTO_IPV6,
        .table      = "mangle",
        .target     = mytarget_tg,
        .checkentry = mytarget_tg_check,
        .destroy    = mytarget_tg_destroy,
        .targetsize = XT_ALIGN(sizeof(struct xt_mytarget_tginfo)),
        .me         = THIS_MODULE,
    },
#endif
};

from xt_MYTARGET.h

struct xt_mytarget_tginfo {
    __u8    value;

    __u8    mode;

    bool    final;

    bool    set_value;

    __u8    by_port[USHRT_MAX];
};
