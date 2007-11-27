From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 6/6] xt_TOS v1 target
Date: Tue, 27 Nov 2007 01:05:27 +0100
Message-ID: <474B5F47.2020202@trash.net>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711270043430.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39154 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXK0AFe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:05:34 -0500
In-Reply-To: <Pine.LNX.4.64.0711270043430.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Import xt_tos v1 target
>
> Extends the xt_DSCP target by xt_TOS v1 to add support for selectively
> setting and flipping any bit in the IPv4 TOS and IPv6 Priority fields.
> (ipt_TOS and xt_DSCP only accepted a limited range of possible
> values.)
>   

Fixed indentation and applied it. Thanks a lot Jan, two config options
and two files less :)


