From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/24] Fix -Wshadow warnings and clean up xt_sctp.h
Date: Sun, 06 Apr 2008 17:35:20 +0200
Message-ID: <47F8EDB8.4010700@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <8969be7f93ce1d77567c949ed78a43a10addbfb4.1207495183.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYDFPfM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:35:12 -0400
In-Reply-To: <8969be7f93ce1d77567c949ed78a43a10addbfb4.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Note: xt_sctp.h is still not merged upstream in the kernel as of
> this commit. But a refactoring was really needed.
> ---
>  configure.ac                      |    3 +-
>  extensions/libipt_SAME.c          |   12 ++--
>  extensions/libipt_addrtype.c      |    4 +-
>  extensions/libxt_RATEEST.c        |   12 ++--
>  extensions/libxt_conntrack.c      |   28 +++++-----
>  extensions/libxt_hashlimit.c      |    4 +-
>  extensions/libxt_state.c          |   12 ++--
>  extensions/libxt_statistic.c      |   23 +++++---
>  include/linux/netfilter/xt_sctp.h |   87 ++++++++++++----------------
>  include/xtables.h                 |    4 +-
>  ip6tables-save.c                  |   10 ++--
>  ip6tables.c                       |   12 ++--
>  iptables-save.c                   |   10 ++--
>  iptables-xml.c                    |    7 +-
>  iptables.c                        |   12 ++--
>  libiptc/libiptc.c                 |   49 +++++++---------
>  xtables.c                         |    4 +-
>  17 files changed, 140 insertions(+), 153 deletions(-)
> 

I have my doubts about the usefulness of -Wshadow, but the
cleanups don't hurt I hope, so applied.
