From: Feliksas <computershik@gmail.com>
Subject: xtables-addons: Kernel 4.4.0 OOPS with xt_CHAOS
Date: Tue, 10 May 2016 18:15:58 +0300
Message-ID: <CAOxNAe+PUyGO3GkZDP1BMxnXpSjv4KZq7ArB0+aU-N8AK0KTvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34959 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbcEJPP7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2016 11:15:59 -0400
Received: by mail-oi0-f67.google.com with SMTP id w198so1924420oiw.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 May 2016 08:15:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greetings,

Opened a bug on Launchpad, since it happened on Ubuntu, probably was
the wrong place to do that, so reposting here.

After upgrading from Wily to Xenial, my server started being frequently
rebooted by an HP iLO watchdog. I turned it off, and installed kdump
tools, and managed to capture a kernel crashdump. Turned out to be a
network-related OOPS, looks like a bug with xtables modules and kernel
4.4.0 (the issue doesn't seem to occur with 4.2.0).

crash tool outputs for two crashes (occured in series with 5-minute
pause for server coldboot):
http://pastebin.com/BSyEmUyJ

corresponding kernel backtraces:
http://pastebin.com/BMmqzrVP
http://pastebin.com/xQRA2kGP

The offending iptables rule, now removed:

iptables -A INPUT -j CHAOS --tarpit

xtables-addons-dkms and xtables-addons-common version:

 Installed: 2.10-1build1
  Candidate: 2.10-1build1
  Version table:
 *** 2.10-1build1 500
        500 http://mirror.yandex.ru/ubuntu xenial/universe amd64 Packages
        100 /var/lib/dpkg/status

Kernel version 4.4.0-22-generic #39-Ubuntu SMP Thu May 5 16:53:32 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

I still have the dumps and can provide any additional information
necessary.

Bug on Launchpad:
https://bugs.launchpad.net/ubuntu/+source/xtables-addons/+bug/1579385

---
Andrew
