From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] netfilter: ebtables: Use %pM conversion specifier
Date: Mon, 10 Aug 2009 10:11:24 +0200
Message-ID: <4A7FD62C.5080506@trash.net>
References: <1247655306-21337-1-git-send-email-klto@zhaw.ch> <1247729151-6210-1-git-send-email-klto@zhaw.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: bart.de.schuymer@pandora.be, shemminger@linux-foundation.org,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Tobias Klauser <klto@zhaw.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58162 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZHJIL2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:11:28 -0400
In-Reply-To: <1247729151-6210-1-git-send-email-klto@zhaw.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tobias Klauser wrote:
> ebt_log uses its own implementation of print_mac to print MAC addresses.
> This patch converts it to use the %pM conversion specifier for printk.

Applied, thanks.
