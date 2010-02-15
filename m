From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Code cleanups
Date: Mon, 15 Feb 2010 17:07:30 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002151653020.27775@obet.zrqbmnf.qr>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <alpine.LSU.2.01.1002102209360.24621@obet.zrqbmnf.qr> <4B796976.7050805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34224 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0BOQHc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:07:32 -0500
In-Reply-To: <4B796976.7050805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-02-15 16:34, Patrick McHardy wrote:
>> 
>>> the next patch pack is mostly about cleanups, and there is one
>>> commit for improving debug a little.
>>> Pull URL will be posted once the previous request has been
>>> merged, but I am already posting them now for review.
>>>
>>> The following changes since commit e3eaa9910b380530cfd2c0670fcd3f627674da8a:
>>> are available in the git repository at:
>> 
>> 	git://dev.medozas.de/linux master
>
>This doesn't apply cleanly anymore due to the mangle table
>fixes from Alexey.


Rebased, see below.


The following changes since commit 98e6d2d5ee26bf56850a10eb64139c68fb09ba19:
  Jan Engelhardt (1):
        netfilter: xt_recent: inform user when hitcount is too large

are available in the git repository at:

  git://dev.medozas.de/linux master-d5d1baa

Jan Engelhardt (6):
      netfilter: iptables: remove unused function arguments
      netfilter: reduce NF_HOOK by one argument
      netfilter: get rid of the grossness in netfilter.h
      netfilter: xtables: print details on size mismatch
      netfilter: xtables: constify args in compat copying functions
      netfilter: xtables: add const qualifiers

 include/linux/netfilter.h            |   55 +++++++++++---------
 include/linux/netfilter/x_tables.h   |   12 ++--
 net/bridge/netfilter/ebtables.c      |   59 ++++++++++++----------
 net/ipv4/netfilter/arp_tables.c      |   73 +++++++++++++++------------
 net/ipv4/netfilter/ip_tables.c       |   92 +++++++++++++++++++---------------
 net/ipv4/netfilter/ipt_ULOG.c        |    4 +-
 net/ipv4/netfilter/iptable_mangle.c  |   10 +---
 net/ipv6/netfilter/ip6_tables.c      |   92 ++++++++++++++++++---------------
 net/ipv6/netfilter/ip6table_mangle.c |   10 +---
 net/netfilter/x_tables.c             |   16 ++++--
 net/netfilter/xt_hashlimit.c         |    4 +-
 net/netfilter/xt_limit.c             |    4 +-
 12 files changed, 233 insertions(+), 198 deletions(-)


And the second run would be


The following changes since commit d5d1baa15f5b05e9110403724d5dc72d6d541e04:
  Jan Engelhardt (1):
        netfilter: xtables: add const qualifiers

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (6):
      netfilter: xtables: replace XT_ENTRY_ITERATE macro
      netfilter: xtables: optimize call flow around xt_entry_foreach
      netfilter: xtables: replace XT_MATCH_ITERATE macro
      netfilter: xtables: optimize call flow around xt_ematch_foreach
      netfilter: xtables: reduce arguments to translate_table
      netfilter: xtables2: make ip_tables reentrant

 include/linux/netfilter/x_tables.h        |   24 ++
 include/linux/netfilter_arp/arp_tables.h  |   10 +-
 include/linux/netfilter_ipv4/ip_tables.h  |   15 +-
 include/linux/netfilter_ipv6/ip6_tables.h |   14 +-
 net/ipv4/netfilter/arp_tables.c           |  307 ++++++++----------
 net/ipv4/netfilter/ip_tables.c            |  501 ++++++++++++++---------------
 net/ipv6/netfilter/ip6_tables.c           |  492 ++++++++++++++---------------
 net/netfilter/x_tables.c                  |   79 +++++
 net/netfilter/xt_TCPMSS.c                 |   12 +-
 9 files changed, 741 insertions(+), 713 deletions(-)
