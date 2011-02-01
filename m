From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] bitmap:ip set type support
Date: Tue, 01 Feb 2011 15:34:09 +0100
Message-ID: <4D4819E1.1000409@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1BAOeL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:34:11 -0500
In-Reply-To: <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> The module implements the bitmap:ip set type in two flavours, without
> and with timeout support. In this kind of set one can store IPv4
> addresses (or network addresses) from a given range.
> 
> In order not to waste memory, the timeout version does not rely on
> the kernel timer for every element to be timed out but on garbage
> collection. All set types use this mechanism.

Applied, thanks Jozsef.
