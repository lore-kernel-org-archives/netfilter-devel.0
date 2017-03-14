From: Peter Marczis <peter.marczis@greenwavesystems.com>
Subject: conntrack (possibly) hangs on our ARM CPU in case we delete 5k+
 connections as fast as possible
Date: Tue, 14 Mar 2017 10:56:00 +0100
Message-ID: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35856 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdCNJ4H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 05:56:07 -0400
Received: by mail-io0-f181.google.com with SMTP id l7so100760181ioe.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 02:56:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello developers,
I'm seeking some help to debug and solve one of my issues.

At GreenWave I'm working on a "SOHO" Router product, and of course we
use linux / netfilter.
We observed that if we create 30k connections, everything works as
expected, but when we start to disconnect them,
conntrack (well not confirmed yet fully) makes the kernel side busy,
and looks like no scheduling happens.

The whole thing works as expected, the only problem it makes our
processes and well everything on user side hanging for a couple of
seconds 10-30s,
which of course triggers our HW Watchdog, and we end up in a reboot.

This is of course a corner case, I just would like to understand
what's happening. I dig as deep in the code I can, looks like there is
a hash table protected by RCU in the code.
What I really seek is some help on how could I debug the kernel side
things better, to see if it locks on this table long, or why the
scheduling is not happening.

Some extra info:
Kernel: 3.4.108 - armv7l - conntrack compiled into it.

~ # cat /proc/cpuinfo
Processor       : ARMv7 Processor rev 1 (v7l)
processor       : 0
BogoMIPS        : 1594.16

processor       : 1
BogoMIPS        : 1594.16

Features        : swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc09
CPU revision    : 1

Hardware        : CORTINA-G2 EB
Revision        : 7542a1
Serial          : 0000000000000000

Idle value:
~ # cat /proc/meminfo
MemTotal:         436936 kB
MemFree:          298336 kB
Buffers:              16 kB
Cached:            30504 kB
SwapCached:            0 kB


Thanks a lot in advance ! I really appreciate your work !

-- 
Br,
 Peter G. Marczis
  SW. Developer
 +45 28 12 92 10
