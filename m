From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Thu, 12 Jul 2012 17:49:57 +0200
Message-ID: <20120712154957.GE18793@1984>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
 <1341964350-13809-5-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44043 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab2GLPuE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:50:04 -0400
Content-Disposition: inline
In-Reply-To: <1341964350-13809-5-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 11, 2012 at 01:52:30AM +0200, Jan Engelhardt wrote:
> The SYSRQ target will allow to remotely invoke sysrq on the local
> machine. Authentication is by means of a pre-shared key that can
> either be transmitted plaintext or digest-secured.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  net/netfilter/Kconfig    |   12 ++
>  net/netfilter/Makefile   |    1 +
>  net/netfilter/xt_SYSRQ.c |  361 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 374 insertions(+), 0 deletions(-)
>  create mode 100644 net/netfilter/xt_SYSRQ.c
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index c19b214..fbe8e40 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -644,6 +644,18 @@ config NETFILTER_XT_TARGET_RATEEST
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> +config NETFILTER_XT_TARGET_SYSRQ
> +	tristate '"SYSRQ" - remote sysrq invocation'
> +	depends on NETFILTER_ADVANCED
> +	---help---
> +	This option enables the "SYSRQ" target which can be used to trigger
> +	sysrq from a remote machine using a magic UDP packet with a pre-shared
> +	password. This is useful when the receiving host has locked up in an
> +	Oops yet still can process incoming packets.
> +
> +	Besides plaintext packets, digest-secured SYSRQ requests will be
> +	supported when CONFIG_CRYPTO is enabled.

I guess this is useful for user, eg. you can reboot your crashed
system from your office in case that cheap comodity hardware without
remote management tools (eg. HP's ILO or Dell's iDRAC).

Still, I think that including this in Netfilter is a bit of abuse
since this is out of the scope of providing some firewalling feature.

People willing to use this should be able to use without requiring
Netfilter at all.

If you have interest in pushing this into mainline, I think this
deserves to be generalized and included somewhere into the networking
tree and provide some genetlink interface to configure it.
