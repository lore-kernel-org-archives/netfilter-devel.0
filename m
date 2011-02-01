From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/13] hash:ip,port,ip set type support
Date: Tue, 01 Feb 2011 15:42:03 +0100
Message-ID: <4D481BBB.3080106@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-4-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-5-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-6-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-7-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-8-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-9-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43479 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1BAOmG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:42:06 -0500
In-Reply-To: <1296514388-20900-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:53, schrieb Jozsef Kadlecsik:
> The module implements the hash:ip,port,ip type support in four flavours:
> for IPv4 and IPv6, both without and with timeout support. The elements
> are three dimensional: IPv4/IPv6 address, protocol/port and IPv4/IPv6
> address triples.

Applied, thanks Jozsef.
