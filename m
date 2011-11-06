From: Ruben Kerkhof <ruben@rubenkerkhof.com>
Subject: Unable to use the ebtables limits module
Date: Sun, 6 Nov 2011 15:23:16 +0100
Message-ID: <CAPed3OEtVFqe6O+MhUy41H5Z_oRe=Mefsucj9pac9nb8bSR10w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33301 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1KFOXh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Nov 2011 09:23:37 -0500
Received: by iage36 with SMTP id e36so4791537iag.19
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Nov 2011 06:23:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I've been trying to use the ebtables limits module as follows:

ebtables -A INPUT -p IPv4 --ip-proto udp --ip-dport 80 --limit 10/second -j DROP
This triggers the following kernel message: eb_tables: limit.0 match:
invalid size 40 (kernel) != (user) 32
and ebtables responds with:

Unable to update the kernel. Two possible causes:
1. Multiple ebtables programs were executing simultaneously. The ebtables
   userspace tool doesn't by default support multiple ebtables programs running
   concurrently. The ebtables option --concurrent or a tool like flock can be
   used to support concurrent scripts that update the ebtables kernel tables.
2. The kernel doesn't support a certain ebtables extension, consider
   recompiling your kernel or insmod the extension.

This only happens when the ebt_limit.ko is not loaded, and the
iptables xt_limit module is loaded
If I either modprobe the ebt_limit module, or unload the xt_limit,
inserting the rule succeeds.

My guess is that the kernel headers which are shipped with ebtables
2.0.10 are not in sync with the ones from the kernel I'm running (3.0,
but this also happens on 2.6.34.7)

Kind regards,

Ruben Kerkhof
