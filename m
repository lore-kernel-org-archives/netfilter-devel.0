From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/13] bitmap:ip,mac type support
Date: Tue, 01 Feb 2011 15:36:13 +0100
Message-ID: <4D481A5D.3060901@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43381 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1BAOgO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:36:14 -0500
In-Reply-To: <1296514388-20900-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> The module implements the bitmap:ip,mac set type in two flavours,
> without and with timeout support. In this kind of set one can store
> IPv4 address and (source) MAC address pairs. The type supports elements
> added without the MAC part filled out: when the first matching from kernel
> happens, the MAC part is automatically filled out. The timing out of the
> elements stars when an element is complete in the IP,MAC pair.
> 

Applied, thanks Jozsef.
