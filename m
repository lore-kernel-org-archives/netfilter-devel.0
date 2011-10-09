From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Interface match in POSTROUTING
Date: Sun, 9 Oct 2011 13:01:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110091257150.19306@frira.zrqbmnf.qr>
References: <13481318151145@web42.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45991 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1JILBo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:01:44 -0400
In-Reply-To: <13481318151145@web42.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-10-09 11:05, "Oleg A. Arkhangelsky" wrote:

>Hello,
>
>I have a question regarding this piece of code in iptables.c:
>
>                if (strcmp(chain, "POSTROUTING") == 0
>                    || strcmp(chain, "OUTPUT") == 0) {
>                        /* -i not valid with outgoing packets */
>                        if (cs.options & OPT_VIANAMEIN)
>                                xtables_error(PARAMETER_PROBLEM,
>                                           "Can't use -%c with %s\n",
>                                           opt2char(OPT_VIANAMEIN),
>                                           chain);
>                }
>
>I agree that "-i" is not valid for locally generated packets
>(that is what OUTPUT chain for). But for forwarded packets
>going through POSTROUTING this is not true. As far as I
>understand we can match for both input and output interface
>here (as in FORWARD).

Locally generated packets also appear in POSTROUTING.
