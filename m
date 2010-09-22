From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net: ipv4,nodefrag: check socket type before touching
 nodefrag flag
Date: Wed, 22 Sep 2010 08:59:55 +0200
Message-ID: <4C99A96B.4020604@trash.net>
References: <1284974876-4596-1-git-send-email-jolsa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: eric.dumazet@gmail.com, jengelh@medozas.de, davem@redhat.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-man@vger.kernel.org
To: Jiri Olsa <jolsa@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53693 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0IVHAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:00:14 -0400
In-Reply-To: <1284974876-4596-1-git-send-email-jolsa@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 20.09.2010 11:27, schrieb Jiri Olsa:
> we need to check proper socket type within ipv4_conntrack_defrag
> function before referencing the nodefrag flag.
> 
> For example the tun driver receive path produces skbs with
> AF_UNSPEC socket type, and so current code is causing unwanted
> fragmented packets going out.

Looks good. Applied, thanks.

