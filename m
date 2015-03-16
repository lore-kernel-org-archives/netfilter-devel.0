From: Nathan McSween <nwmcsween@gmail.com>
Subject: [PATCH] Use stdlib uint* instead of u_int*
Date: Mon, 16 Mar 2015 21:07:42 +0000
Message-ID: <1426540063-17099-1-git-send-email-nwmcsween@gmail.com>
Cc: Nathan McSween <nwmcsween@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35441 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbCQFHx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 01:07:53 -0400
Received: by igcau2 with SMTP id au2so24429064igc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 22:07:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use stdint as u_int* is deprecated / non-standard, it is also not exposed on some libc's.

Nathan McSween (1):
  Use stdlib uint* instead of u_int*

 include/libnfnetlink/libnfnetlink.h           | 25 +++++-----
 include/libnfnetlink/linux_nfnetlink.h        | 11 +++--
 include/libnfnetlink/linux_nfnetlink_compat.h |  6 ++-
 src/iftable.c                                 |  9 ++--
 src/iftable.h                                 |  6 ++-
 src/libnfnetlink.c                            | 71 ++++++++++++++-------------
 src/rtnl.c                                    |  5 +-
 src/rtnl.h                                    |  3 +-
 8 files changed, 73 insertions(+), 63 deletions(-)

-- 
2.3.1

