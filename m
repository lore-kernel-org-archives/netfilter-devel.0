From: Sharat Masetty <sharat04@gmail.com>
Subject: ebtables issue in compat mode
Date: Wed, 30 Apr 2014 23:18:37 -0600
Message-ID: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:37188 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEAFSj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 May 2014 01:18:39 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so2638837wes.31
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Apr 2014 22:18:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am seeing a problem when running ebtables in 32bit userspace and 64
bit kernel space mode.

The command I am trying to run is
ebtables -t broute -A BROUTING -p IPv4 -j DROP

Here is the log message I am seeing in userspace

The message (http://sourceforge.net/p/ebtables/code/ci/master/tree/user=
space/ebtables2/communication.c
Line 243) in userspace is

        ebt_print_error("Unable to update the kernel. Two possible caus=
es:\n"

                       "1. Multiple ebtables programs were executing
simultaneously. The ebtables\n"

                       "   userspace tool doesn't by default support
multiple ebtables programs running\n"

                       "   concurrently. The ebtables option
--concurrent or a tool like flock can be\n"

                       "   used to support concurrent scripts that
update the ebtables kernel tables.\n"

                       "2. The kernel doesn't support a certain
ebtables extension, consider\n"

                       "   recompiling your kernel or insmod the extens=
ion.\n");

I noticed that setsockopt() is failing . The message is also printed
in kernel =E2=80=93 Standard target size too big . This occurs because =
there
is a mismatch in the size of the structures ebt_standard_target which
is 48 bytes in kernel and 40 bytes in userspace.

Can someone help us fix this issue?

Thanks
Sharat
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
