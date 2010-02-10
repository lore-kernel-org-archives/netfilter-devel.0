From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Code cleanups
Date: Wed, 10 Feb 2010 22:10:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002102209360.24621@obet.zrqbmnf.qr>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49079 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab0BJVKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:10:08 -0500
In-Reply-To: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 18:39, Jan Engelhardt wrote:

>the next patch pack is mostly about cleanups, and there is one
>commit for improving debug a little.
>Pull URL will be posted once the previous request has been
>merged, but I am already posting them now for review.
>
>The following changes since commit e3eaa9910b380530cfd2c0670fcd3f627674da8a:
>are available in the git repository at:


	git://dev.medozas.de/linux master



> include/linux/netfilter.h            |   55 +++++++++++---------
> include/linux/netfilter/x_tables.h   |   12 ++--
> net/bridge/netfilter/ebtables.c      |   59 ++++++++++++----------
> net/ipv4/netfilter/arp_tables.c      |   73 +++++++++++++++------------
> net/ipv4/netfilter/ip_tables.c       |   92 +++++++++++++++++++---------------
> net/ipv4/netfilter/ipt_ULOG.c        |    4 +-
> net/ipv4/netfilter/iptable_mangle.c  |   10 +---
> net/ipv6/netfilter/ip6_tables.c      |   92 ++++++++++++++++++---------------
> net/ipv6/netfilter/ip6table_mangle.c |   10 +---
> net/netfilter/x_tables.c             |   16 ++++--
> net/netfilter/xt_hashlimit.c         |    4 +-
> net/netfilter/xt_limit.c             |    4 +-
> 12 files changed, 233 insertions(+), 198 deletions(-)
