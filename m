From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] xt_tos match
Date: Mon, 19 Nov 2007 11:37:26 +0100
Message-ID: <47416766.6090209@trash.net>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61898 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXKSKhp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:37:45 -0500
In-Reply-To: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Posted for review and checkup.
> 
> Index: net-2.6.25/include/linux/netfilter_ipv4/Kbuild
> ===================================================================
> --- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
> +++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
> @@ -40,7 +40,6 @@ header-y += ipt_sctp.h
>  header-y += ipt_state.h
>  header-y += ipt_string.h
>  header-y += ipt_tcpmss.h
> -header-y += ipt_tos.h

We still need that file, no?

Otherwise looks fine, thanks.

