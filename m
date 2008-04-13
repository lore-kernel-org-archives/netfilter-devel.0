From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/13] manpages: update to reflect fine-grained control
Date: Sun, 13 Apr 2008 07:20:15 +0200
Message-ID: <4801980F.4080603@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <ed1ef4afd357078bbaeee398e17a9bc573f9f4fa.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33352 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYDMFUT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:20:19 -0400
In-Reply-To: <ed1ef4afd357078bbaeee398e17a9bc573f9f4fa.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Some manpages (DNAT for example) specifies
> 	--to-destination ip[-ip][:port-port]
> while it is actually
> 	--to-destination ip[-ip][:port[-port]]
> ---
>  extensions/libip6t_frag.man   |    4 ++--
>  extensions/libipt_DNAT.man    |    2 +-
>  extensions/libipt_SAME.man    |    2 +-
>  extensions/libipt_SNAT.man    |    2 +-
>  extensions/libxt_connmark.man |    2 +-
>  extensions/libxt_helper.man   |    2 +-
>  extensions/libxt_iprange.man  |    4 ++--
>  extensions/libxt_mark.man     |    2 +-
>  extensions/libxt_owner.man    |   10 +++++-----
>  extensions/libxt_tos.man      |    4 ++--
>  10 files changed, 17 insertions(+), 17 deletions(-)

Applied.
