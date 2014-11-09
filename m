From: Nguyen Duong Tuan <hoang.su.tk@gmail.com>
Subject: How to debug libiptc and mechanism for exchanging information between
 user space and kernel space
Date: Sun, 9 Nov 2014 18:44:32 +0700
Message-ID: <CAM_kxqf5EdXQ7+cPFQk5NsaY3F7LDtsTbqEmZCnr11X_nUc9BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48491 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKILoe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:44:34 -0500
Received: by mail-lb0-f172.google.com with SMTP id w7so4638088lbi.17
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2014 03:44:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I'm studying iptables' source code (both user and kernel space) and
got several questions and statements. I will highly appreciate if
someone could confirm them.

1 - How to debug libiptc? I tried with TC_APPEND_ENTRY in libiptc.c by
adding a print command and rebuilt iptables source code but it didn't
show when I added a new rule.

2 - iptables utility (user space) and ip_tables module (kernel space)
communicate with each other via getsockopt and setsockopt functions
defined in TC_INIT of libiptc.c.

3 - Netlink (libnfnetlink) is only used for other modules (log, queue,
conntrack). Not for iptables.

Regards,
HTS
