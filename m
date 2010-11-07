From: Jan Andrejkovic <jandrejk@gmail.com>
Subject: Re: xtables extenstions - Unknown symbol xtnu_register_match/xtnu_unregister_match
Date: Sun, 7 Nov 2010 17:53:17 +0000
Message-ID: <AANLkTimdDs1jmm1rN0pH6aj+-STD-vGKxz2v1Ps+_qZr@mail.gmail.com>
References: <AANLkTimM06O=DfEjX+i9k1Q8=wp0430jzo=c9dk7n_QA@mail.gmail.com>
	<AANLkTinvHR7dwmivcc53JEhUKFkETShZ8_FZNqJ4SwtY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:57667 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0KGRxS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:53:18 -0500
Received: by iwn35 with SMTP id 35so1516870iwn.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Nov 2010 09:53:17 -0800 (PST)
In-Reply-To: <AANLkTinvHR7dwmivcc53JEhUKFkETShZ8_FZNqJ4SwtY@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I solved the main issue,

I did not realise that modules require compat_xtables module to be
loaded. Once I used modprobe,
it solved module dependency and module is loaded now:

# lsmod
Module                  Size  Used by
xt_ipv4options           780  0
compat_xtables          3894  1 xt_ipv4options

So now only one small issue persits: once I edited mconfig file and I
commented out all lines (by adding  hash as the first char on the
line) but "build_ipv4options=m" all modules were compiled and
installed anyway.

Thank you for any hint,

Jan


On 7 November 2010 17:13, Jan Andrejkovic <jandrejk@gmail.com> wrote:
> Hi gyus,
>
> I compiled xtables-addons 1.30 on the Fedora12 kernel
> 2.6.32.23-170.fc12.i686 (./configure make make install)
>
> Once I want to instert the module, I get below errors:
>
> # insmod ./xt_geoip.ko
> insmod: error inserting './xt_geoip.ko': -1 Unknown symbol in module
> # insmod ./xt_ipv4options.ko
> insmod: error inserting './xt_ipv4options.ko': -1 Unknown symbol in module
>
> And dmesg shows:
> xt_geoip: Unknown symbol xtnu_register_match
> xt_geoip: Unknown symbol xtnu_unregister_match
> xt_ipv4options: Unknown symbol xtnu_register_match
> xt_ipv4options: Unknown symbol xtnu_unregister_match
>
> Do you please have any hint?
>
> I have also another minor issue - I commented out all the lines but
> ipv4options, however all modules were compiled and installed anyway.
>
> Thank you very much,
>
> Jan
>
