From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/27] Change semantic of mask value in xt_TOS
Date: Fri, 04 Jan 2008 15:27:55 +0100
Message-ID: <477E426B.2000606@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022125360.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48147 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYADOa5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:30:57 -0500
In-Reply-To: <Pine.LNX.4.64.0801022125360.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 4fd5dd02c10be25f59155d127d3ea6de17703946
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:35:23 2008 +0100
> 
>     [NETFILTER]: Change semantic of mask value in xt_TOS
>     
>     This patch changes the behavior of xt_TOS v1 so that the mask value
>     the user supplies means "zero out these bits" rather than "keep these
>     bits". This is more easy on the user, as (I would assume) people keep
>     more bits than zeroing, so, an example:
>     
>     	Action:     Set bit 0x01.
>     	before (&): iptables -j TOS --set-tos 0x01/0xFE
>     	after (&~): iptables -j TOS --set-tos 0x01/0x01
>     
>     This is not too "tragic" with xt_TOS, but where larger fields are used
>     (e.g. proposed xt_MARK v2), `--set-xmar 0x01/0x01` vs. `--set-xmark
>     0x01/0xFFFFFFFE` really makes a difference. Other target(!) modules,
>     such as xt_TPROXY also use &~ rather than &, so let's get to a common
>     ground.
>     
>     (Since xt_TOS has not yet left the development tree en direction to
>     mainline, the semantic can be changed as proposed without breaking
>     iptables.)

Applied, thanks Jan.
