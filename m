From: Matthew Weber <matthew.weber@rockwellcollins.com>
Subject: [Repost] Fix userspace compilation of ip_tables.h/ip6_tables.h in C++ mode
Date: Mon, 3 Nov 2014 22:13:43 -0600
Message-ID: <CANQCQpb+_Z0U7ko-FKcmA3Zm4VXrG4QG3+Nx_noq3CFt1UfZMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ch3vs01.rockwellcollins.com ([205.175.226.27]:53790 "EHLO
	ch3vs01.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbaKDEXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:23:20 -0500
Received: by mail-ie0-f180.google.com with SMTP id y20so6568999ier.25
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 20:13:43 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Re-posting a link to a patch that was posted to lkml & linux-netdev at
first, then posted to netfilter-devel.

http://marc.info/?t=134904906300003&r=1&w=1

It seems to have been rejected:   http://patchwork.ozlabs.org/patch/188216/

We're building a custom C++ application which pulls in the iptables
header that requires this change.  We wanted to see if we could get it
incorporated so we don't carry the patch as part of our build.  I can
gladly resubmit the patch but the one in patchworks is still correct.

Thanks,
Matt Weber
