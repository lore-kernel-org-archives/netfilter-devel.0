From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] iptables: libxt_owner
Date: Sun, 25 Nov 2007 16:22:18 +0100
Message-ID: <4749932A.4010902@trash.net>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61832 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbXKYPWz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:22:55 -0500
In-Reply-To: <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> +static void owner_mt_help(void)
> +{
> +	printf(
> +"owner match v%s options:\n"
> +"[!] --uid-owner userid     Match local UID\n"
> +"[!] --gid-owner groupid    Match local GID\n"
> +"[!] --socket-exists        Match if socket exists\n"
> +"[!] --filp-exists          Match if filp exists\n"
> +"\n",
> +IPTABLES_VERSION);


The filp-exists option strikes me as useless, what would the
use case be? For the socket-exists option, I'd prefer for the
owner match to simply accept no further option, i.e. "-m owner".
