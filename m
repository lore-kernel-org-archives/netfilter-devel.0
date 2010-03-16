From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/10] netfilter: xtables: merge xt_NOTRACK into xt_CT
Date: Tue, 16 Mar 2010 18:01:38 +0100
Message-ID: <4B9FB972.7010207@trash.net>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de> <1268703135-2622-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37820 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758Ab0CPRBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:01:40 -0400
In-Reply-To: <1268703135-2622-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> References: http://marc.info/?l=netfilter-devel&m=126443812131414&w=2
> References: Message-Id: <4B5DCB63.7020704@trash.net>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/Kconfig      |   21 +++++------------
>  net/netfilter/Makefile     |    1 -
>  net/netfilter/xt_CT.c      |   54 ++++++++++++++++++++++++++++++++++---------
>  net/netfilter/xt_NOTRACK.c |   53 -------------------------------------------
>  4 files changed, 48 insertions(+), 81 deletions(-)
>  delete mode 100644 net/netfilter/xt_NOTRACK.c

Since CT is supposed to obsolete NOTRACK, I don't want to merge
these two. Better schedule it for removal in one or two years.
