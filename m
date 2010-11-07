From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables extenstions - Unknown symbol
 xtnu_register_match/xtnu_unregister_match
Date: Sun, 7 Nov 2010 19:07:42 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011071907290.8402@obet.zrqbmnf.qr>
References: <AANLkTimM06O=DfEjX+i9k1Q8=wp0430jzo=c9dk7n_QA@mail.gmail.com> <AANLkTinvHR7dwmivcc53JEhUKFkETShZ8_FZNqJ4SwtY@mail.gmail.com> <AANLkTimdDs1jmm1rN0pH6aj+-STD-vGKxz2v1Ps+_qZr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Andrejkovic <jandrejk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46888 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0KGSHo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:07:44 -0500
In-Reply-To: <AANLkTimdDs1jmm1rN0pH6aj+-STD-vGKxz2v1Ps+_qZr@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-11-07 18:53, Jan Andrejkovic wrote:

>I solved the main issue,
>
>I did not realise that modules require compat_xtables module to be
>loaded. Once I used modprobe,
>it solved module dependency and module is loaded now:
>
># lsmod
>Module                  Size  Used by
>xt_ipv4options           780  0
>compat_xtables          3894  1 xt_ipv4options
>
>So now only one small issue persits: once I edited mconfig file and I
>commented out all lines (by adding  hash as the first char on the
>line) but "build_ipv4options=m" all modules were compiled and
>installed anyway.

Chances are you built them first before adding #s.
