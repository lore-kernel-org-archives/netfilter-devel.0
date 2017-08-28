From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] net: netfilter: Remove NFDEBUG.
Date: Mon, 28 Aug 2017 18:13:16 +0200
Message-ID: <20170828161316.GA4438@salvia>
References: <20170825104112.2620-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38010 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH1QNk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 12:13:40 -0400
Content-Disposition: inline
In-Reply-To: <20170825104112.2620-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 25, 2017 at 04:11:12PM +0530, Varsha Rao wrote:
> Remove NFDEBUG and use pr_debug() instead of it.

Applied, thanks.

Varsha, could you remove CONFIG_NETFILTER_DEBUG too?

Update IP_NF_ASSERT() to use WARN_ON(), this is actually already there
in ip6_tables.

net/bridge/netfilter/ebtables.c:#ifdef CONFIG_NETFILTER_DEBUG
net/bridge/netfilter/ebtables.c:#ifdef CONFIG_NETFILTER_DEBUG
net/bridge/netfilter/ebtables.c:#ifdef CONFIG_NETFILTER_DEBUG
net/ipv4/netfilter/ip_tables.c:#ifdef CONFIG_NETFILTER_DEBUG
net/ipv6/netfilter/ip6_tables.c:#ifdef CONFIG_NETFILTER_DEBUG

Conversions in ebtables.c are not so straight forward, but still
possible to get rid of this.

Make sure Kconfig and defconfig lines also goes away for good.

$ git grep NETFILTER_DEBUG
arch/parisc/configs/c3000_defconfig:CONFIG_NETFILTER_DEBUG=y
arch/sh/configs/se7751_defconfig:CONFIG_NETFILTER_DEBUG=y
include/net/netfilter/nf_conntrack.h:#ifdef CONFIG_NETFILTER_DEBUG
net/Kconfig:config NETFILTER_DEBUG

Same thing for NF_CT_ASSERT(), update it to use WARN_ON() instead.

Actually, you could send two patches: One to update all NF_CT_ASSERT()
to use WARN_ON(), then a patch to remove CONFIG_NETFILTER_DEBUG and
all these _ASSERT() macros.
