From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 019/103] netfilter: xtables: check for unconditionality
 of policies
Date: Mon, 10 Aug 2009 10:55:44 +0200
Message-ID: <4A7FE090.1060603@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-20-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59250 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZHJIzr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:55:47 -0400
In-Reply-To: <1249370787-17583-20-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/ipv4/netfilter/arp_tables.c |   12 +++++++-----
>  net/ipv4/netfilter/ip_tables.c  |   11 +++++++----
>  net/ipv6/netfilter/ip6_tables.c |   12 +++++++-----
>  3 files changed, 21 insertions(+), 14 deletions(-)

Some explanation please.

