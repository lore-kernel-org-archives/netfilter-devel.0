From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Fix make/compile error for iptables-1.4.0rc1
Date: Mon, 26 Nov 2007 14:55:32 +0900 (JST)
Message-ID: <200711260555.lAQ5tXSH021627@toshiba.co.jp>
References: <1195828201.3866.20.camel@localhost.localdomain>
	<1195834612.3866.42.camel@localhost.localdomain>
	<47499137.3060709@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jdb@comx.dk, yasuyuki@netfilter.org,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:61007 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXKZGDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 01:03:40 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id lAQ63ctU002970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 15:03:38 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id lAQ5tZ44010336
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 14:55:35 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id lAQ5tZae019558
	for netfilter-devel@vger.kernel.org; Mon, 26 Nov 2007 14:55:35 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id lAQ5tZw2014766
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Nov 2007 14:55:35 +0900 (JST)
In-Reply-To: <47499137.3060709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


From: Patrick McHardy <kaber@trash.net>
Date: Sun, 25 Nov 2007 16:13:59 +0100

> Jesper Dangaard Brouer wrote:
> > Fixing a make/compile issue with iptables, release candidate 1.4.0rc1,
> > which has existed since SVN changeset 6920.  This patch adds ip_tables.h
> > and ip6_tables.h, and updates x_tables.h, taken from Linus'es git tree.
> > 
> > Changeset 6920 added the include file x_tables.h from kernel source, but
> > didn't add ip_tables.h and ip6_tables.h.
> > 
> > At some point (Tue Nov 14 19:48:48 2006, by Yasuyuki Kozakai) these
> > kernel headers where changed, which actually removes certain
> > depencencies from ip_tables.h and ip6_tables.h to x_tables.h.
> > 
> > If compiling will fail, with old kernel headers (ip_tables.h and
> > ip6_tables.h) available in systems include path, because they depend on
> > certaine defines in x_tables.h with is missing in the version in SVN.
> 
> 
> Applied, but I stripped the #ifdef __KERNEL__ sections first.
> Thanks Jesper.

Thanks Jesper and Patrick. That looks fine to me.

XT_SO_GET_REVISION_{MATCH,TARGET} in 2.6.18 was removed because of
conflicts on {get,set}sockopt number of IPv6 socket. I.e. ip_tables.h
you used on build included bug.

iptables.c only uses IPT_SO_GET_REVISION_* and they are defined in local
header include/iptables.h. I suspects that
/usr/include/linux/netfilter_ipv4/ip_tables.h re-defined
IPT_SO_GET_REVISION_* with XT_SO_GET_REVISION_* on your environment.

P.S. sorry for late reply. I was very busy for other work this several
months but I will be able to contribute to netfilter again from next month.

Regards,

-- Yasuyuki Kozakai

