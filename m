From: Patrick McHardy <kaber@trash.net>
Subject: Re: [11/19] libxt_conntrack r0
Date: Sun, 20 Jan 2008 14:33:21 +0100
Message-ID: <47934DA1.2000502@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161451060.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58018 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYATNeU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:34:20 -0500
In-Reply-To: <Pine.LNX.4.64.0801161451060.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Move libipt_conntrack to libxt_conntrack.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libipt_conntrack.c                |  514 --------------------------
>  extensions/libipt_conntrack.man              |   49 --
>  extensions/libxt_conntrack.c                 |  517 +++++++++++++++++++++++++++
>  extensions/libxt_conntrack.man               |   71 +++
>  include/linux/netfilter/xt_conntrack.h       |   83 ++++
>  include/linux/netfilter_ipv4/ipt_conntrack.h |   77 ----
>  6 files changed, 671 insertions(+), 640 deletions(-)

Applied, thanks.
