From: Patrick McHardy <kaber@trash.net>
Subject: Re: libxt_TOS: make sure --set-tos value/mask is recognized
Date: Mon, 30 Jun 2008 14:57:33 +0200
Message-ID: <4868D83D.6050206@trash.net>
References: <alpine.LNX.1.10.0806272208540.12725@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35754 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbYF3M5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:57:34 -0400
In-Reply-To: <alpine.LNX.1.10.0806272208540.12725@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit d30191dd6ea9e13a7a7340004872f027aa7d4d5c
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Jun 27 22:00:11 2008 +0200
> 
>     libxt_TOS: make sure --set-tos value/mask is recognized
>     
>     Only when a 'stop' pointer is passed, the string may consist of more
>     than just a number.
>     
>     Reported-by: Anonymous
>     Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
