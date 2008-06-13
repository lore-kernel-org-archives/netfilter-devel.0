From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.4.1 + iprange fails for me
Date: Fri, 13 Jun 2008 18:00:06 +0200
Message-ID: <48529986.1020204@trash.net>
References: <20080613090236.417411cd@maxim.office.modum.by> <alpine.LNX.1.10.0806131047070.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Maxim Britov <maxim.britov@gmail.com>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44922 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbYFMQAJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:00:09 -0400
In-Reply-To: <alpine.LNX.1.10.0806131047070.23098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> iprange: kernel flags were not set
>     
> The --src-range and --dst-range parameters did not set the IPRANGE_*
> flags in struct xt_iprange_mtinfo.
>     
> Reported-by: Maxim Britov <maxim.britov@gmail.com>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks Jan.
