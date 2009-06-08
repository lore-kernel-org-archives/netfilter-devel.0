From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Passive OS fingerprint xtables match.
Date: Mon, 8 Jun 2009 21:25:54 +0400
Message-ID: <20090608172554.GA9158@ioremap.net>
References: <20090607151758.GB31757@ioremap.net> <4A2D28E0.80508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from broadrack.ru ([195.178.208.66]:58527 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZFHRZ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:25:58 -0400
Content-Disposition: inline
In-Reply-To: <4A2D28E0.80508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 08, 2009 at 05:06:08PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> Applied, thanks. I've made one minor change:
> 
> --- a/include/linux/netfilter/Kbuild
> +++ b/include/linux/netfilter/Kbuild
> @@ -33,6 +33,7 @@ header-y += xt_limit.h
>  header-y += xt_mac.h
>  header-y += xt_mark.h
>  header-y += xt_multiport.h
> +header-y += xt_osf.h
>  header-y += xt_owner.h
>  header-y += xt_pkttype.h
>  header-y += xt_quota.h

No problem, thank you!

-- 
	Evgeniy Polyakov
