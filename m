From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 22/27] Rename ipt_iprange to xt_iprange
Date: Tue, 08 Jan 2008 16:55:38 +0100
Message-ID: <47839CFA.9090005@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63323 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYAHP7g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:59:36 -0500
In-Reply-To: <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit b9d3db24231f4555d13b348645e6c0b2f6eba3af
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:49:22 2008 +0100
> 
>     [NETFILTER]: Rename ipt_iprange to xt_iprange
>     
>     This patch moves ipt_iprange to xt_iprange, in preparation for adding
>     IPv6 support to xt_iprange.


This doesn't apply without the MODULE_DESCRIPTION patch.
