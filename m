From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/27] remove ipt_TOS.c
Date: Fri, 04 Jan 2008 15:25:46 +0100
Message-ID: <477E41EA.3090903@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022125030.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYADO2s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:28:48 -0500
In-Reply-To: <Pine.LNX.4.64.0801022125030.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit b6e9a26f05e83d8058f1dc56a45e5f5d533ad373
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:31:42 2008 +0100
> 
>     [NETFILTER]: remove ipt_TOS.c
>     
>     Commit 88c85d81f74f92371745158aebc5cbf490412002 forgot to remove the
>     old ipt_TOS file (whose code has been merged into xt_DSCP). Remove
>     it now.

Applied, thanks.
