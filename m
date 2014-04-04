From: Ronny Janssen <ronny.janssen@gmail.com>
Subject: ip_tables: limit match: invalid size 40 != 48
Date: Fri, 4 Apr 2014 11:13:09 +0200
Message-ID: <CAJsRc6irAg4WeP8EpY1Vk3ZVWnKPee1ab6j1-8jgy0cZyF21Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53833 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaDDJNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:13:09 -0400
Received: by mail-qc0-f173.google.com with SMTP id r5so3153035qcx.18
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2014 02:13:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm running Linux 2.6.32.2 mips64 with 32bit userland iptables-1.4.18.

When installing a second limit filter rule the kernel complains with:
    ip_tables: limit match: invalid size 40 != 48

It does not matter if this second limit rule is on the same or on a
different chain. Other targets/rules/matches are just fine.

Using GDB I examined the replacement buffer sent back using setsockopt
and as far as I can see all the match elements have the correct size
of 40.

I'm a bit of a noob on the netfilter kernelside so I'm calling on the
developers community for help.. I suspect something's going wrong in
the match->compat_from_user().

I can't imagine being the only one with this problem. I am aware I'm
running a bit of an outdated kernel, but upgrading is not an option.
It'd be ideal if someone could point me to an existing patch solving
this problem, but if not I'd appreciate pointers to where start
looking.

Thanks,

Ronny.
