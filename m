From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 06/10] netfilter: xtables: merge xt_NOTRACK into xt_CT
Date: Tue, 16 Mar 2010 18:30:22 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003161828370.19522@obet.zrqbmnf.qr>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de> <1268703135-2622-7-git-send-email-jengelh@medozas.de> <4B9FB972.7010207@trash.net> <alpine.LSU.2.01.1003161814340.25891@obet.zrqbmnf.qr> <4B9FBD75.3070205@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53419 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab0CPRaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:30:25 -0400
In-Reply-To: <4B9FBD75.3070205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-16 18:18, Patrick McHardy wrote:
>
>>> Since CT is supposed to obsolete NOTRACK, I don't want to merge
>>> these two. Better schedule it for removal in one or two years.
>> 
>> Ok, perfect. Just skip this patch then for now. (Should I update the git 
>> branch?)
>
>Yes please.
>
>> I'll send you another patch later on documenting the fact in 
>> Documentation/feature-removal-schedule.txt in one of the next 
>> microrounds.
>
>Thanks.

Patch tucked in (see *) and pushed.


The following changes since commit 3a5b27bf6f29574d667230c7e76e4b83fe3014e0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (10):
      netfilter: xt_CT: par->family is an nfproto
      netfilter: xt_NFQUEUE: consolidate v4/v6 targets into one
      netfilter: xtables: add comment markers to Xtables Kconfig
      netfilter: xtables: merge xt_MARK into xt_mark
      netfilter: xtables: merge xt_CONNMARK into xt_connmark
 *    netfilter: xtables: schedule xt_NOTRACK for removal
      netfilter: update my email address
      netfilter: ebt_ip6: add principal maintainer in a MODULE_AUTHOR tag
      netfilter: xt_recent: update description
      netfilter: xt_recent: remove old proc directory

 Documentation/feature-removal-schedule.txt |   18 ++---
 include/linux/netfilter/xt_CONNMARK.h      |   22 +-----
 include/linux/netfilter/xt_MARK.h          |    6 +-
 include/linux/netfilter/xt_connmark.h      |   11 +++
 include/linux/netfilter/xt_mark.h          |    4 +
 net/bridge/netfilter/ebt_ip6.c             |    3 +-
 net/netfilter/Kconfig                      |   98 ++++++++++++++----------
 net/netfilter/Makefile                     |    8 +-
 net/netfilter/xt_CONNMARK.c                |  113 ----------------------------
 net/netfilter/xt_CT.c                      |    4 +-
 net/netfilter/xt_MARK.c                    |   56 --------------
 net/netfilter/xt_NFQUEUE.c                 |   40 +++-------
 net/netfilter/xt_TCPOPTSTRIP.c             |    3 +-
 net/netfilter/xt_connlimit.c               |    1 -
 net/netfilter/xt_connmark.c                |   86 ++++++++++++++++++++-
 net/netfilter/xt_hashlimit.c               |    2 +-
 net/netfilter/xt_mark.c                    |   35 ++++++++-
 net/netfilter/xt_recent.c                  |  109 +--------------------------
 net/netfilter/xt_time.c                    |    3 +-
 net/netfilter/xt_u32.c                     |    3 +-
 20 files changed, 223 insertions(+), 402 deletions(-)
 delete mode 100644 net/netfilter/xt_CONNMARK.c
 delete mode 100644 net/netfilter/xt_MARK.c
