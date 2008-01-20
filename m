From: Patrick McHardy <kaber@trash.net>
Subject: Re: [15/19] libxt_mark r1
Date: Sun, 20 Jan 2008 14:40:41 +0100
Message-ID: <47934F59.5090903@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161452570.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58138 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYATNll (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:41:41 -0500
In-Reply-To: <Pine.LNX.4.64.0801161452570.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Introduce libxt_mark match revision 1 support.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libxt_mark.c           |  140 ++++++++++++++++++++++++++++++--------
>  include/linux/netfilter/xt_mark.h |    7 +
>  2 files changed, 118 insertions(+), 29 deletions(-)
> 

Applied, thanks.

> +static void mark_mt_help(void)
>  {
>  	printf(
> -"MARK match v%s options:\n"
> -"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
> -"\n",
> -IPTABLES_VERSION);
> +"mark match options:\n"
> +"[!] --mark value[/mask]    Match nfmark value with optional mask\n"
> +"\n");

Not that the version number is particulary useful (only extensions
with matching version numbers are loaded anyways), but this is
kind of the opposite direction of your message unification efforts.
Are you planning to remove them from the other extensions as well?
