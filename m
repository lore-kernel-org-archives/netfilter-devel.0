From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v6] netfilter: introduce l2tp match extension
Date: Thu, 9 Jan 2014 21:45:47 +0100
Message-ID: <20140109204547.GA18522@localhost>
References: <1389003428-29683-1-git-send-email-jchapman@katalix.com>
 <20140109195211.GA26947@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60620 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbaAIUp4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:45:56 -0500
Content-Disposition: inline
In-Reply-To: <20140109195211.GA26947@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

More minor changes I have done here:

On Thu, Jan 09, 2014 at 08:52:11PM +0100, Pablo Neira Ayuso wrote:
> > - Add IS_ENABLED(CONFIG_IPV6) around IPv6 code.

Changed this to use IS_ENABLED(CONFIG_IP6_NF_IPTABLES).

> > ---
> > :000000 100644 0000000... be65e0b... A	include/uapi/linux/netfilter/xt_l2tp.h
> > :100644 100644 c3398cd... a32c8ce... M	net/netfilter/Kconfig
> > :100644 100644 394483b... 564bf35... M	net/netfilter/Makefile
> > :000000 100644 0000000... 48f1211... A	net/netfilter/xt_l2tp.c
> >  include/uapi/linux/netfilter/xt_l2tp.h |   29 +++
> >  net/netfilter/Kconfig                  |   10 +
> >  net/netfilter/Makefile                 |    1 +
> >  net/netfilter/xt_l2tp.c                |  392 ++++++++++++++++++++++++++++++++

Added missing change in include/uapi/linux/netfilter/Kbuild.
