From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] iptables out-of-tree build directory
Date: Mon, 12 May 2008 17:58:25 +0200
Message-ID: <48286921.9010509@trash.net>
References: <1210547721.23433.33.camel@henriknordstrom.net> <alpine.LNX.1.10.0805121018530.25441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYELP7F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 11:59:05 -0400
In-Reply-To: <alpine.LNX.1.10.0805121018530.25441@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 333c904234d9320aca2494cf86595b9639b03f3e
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon May 12 10:25:15 2008 +0200
> 
>     Makefile: fix out-of-topdir compilation
>     
>     Reported by: Henrik Nordstrom
>     
>     When xtables.h is not already found in /usr/include, compilation
>     would fail when ${top_srcdir} != ${top_builddir}.

Applied, thanks.

