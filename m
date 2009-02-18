From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: Combine ipt_ttl and ip6t_hl source
Date: Wed, 18 Feb 2009 18:40:35 +0100
Message-ID: <499C4813.8070102@trash.net>
References: <1234972949-12036-1-git-send-email-jengelh@medozas.de> <1234972949-12036-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZBRRki (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:40:38 -0500
In-Reply-To: <1234972949-12036-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/ipv4/netfilter/Kconfig   |    9 ----
>  net/ipv4/netfilter/Makefile  |    1 -
>  net/ipv4/netfilter/ipt_ttl.c |   63 ------------------------
>  net/ipv6/netfilter/Kconfig   |    9 ----
>  net/ipv6/netfilter/Makefile  |    1 -
>  net/ipv6/netfilter/ip6t_hl.c |   68 --------------------------
>  net/netfilter/Kconfig        |    8 +++
>  net/netfilter/Makefile       |    1 +
>  net/netfilter/xt_hl.c        |  108 ++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 117 insertions(+), 151 deletions(-)
>  delete mode 100644 net/ipv4/netfilter/ipt_ttl.c
>  delete mode 100644 net/ipv6/netfilter/ip6t_hl.c
>  create mode 100644 net/netfilter/xt_hl.c

Also applied, thanks. How about a compat config option for one
or two releases to keep the make oldconfig annoyance down?
