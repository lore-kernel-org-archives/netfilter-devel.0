From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend: [PATCH] Fix iptables-save output of libxt_owner match
Date: Fri, 06 Jun 2008 14:20:43 +0200
Message-ID: <48492B9B.3020401@trash.net>
References: <20080606114215.GA4474@innominate.com> <48492756.40508@trash.net> <alpine.LNX.1.10.0806061408580.11044@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lutz Jaenicke <ljaenicke@innominate.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43021 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYFFMUq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:20:46 -0400
In-Reply-To: <alpine.LNX.1.10.0806061408580.11044@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> libxt_owner: add spaces to output
>     
> It could happen that --<arg><value> was printed on iptables-save with
> owner rules (owner_mt_save() function) without the obligatory space
> inbetween. Also transfer printing of the space character into
> owner_mt_print_item().

Applied, thanks.
