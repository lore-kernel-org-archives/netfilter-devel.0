From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/27] Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
Date: Fri, 04 Jan 2008 15:37:10 +0100
Message-ID: <477E4496.4050604@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022126330.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48352 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYADOkM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:40:12 -0500
In-Reply-To: <Pine.LNX.4.64.0801022126330.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 5dc63a190ced8162bad4709daa5442cad693ef2f
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:40:31 2008 +0100
> 
>     [NETFILTER]: Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
>     
>     The kernel parts of the structures do not need to be fixed nor
>     compat-converted; all other fields already use fixed types, so the
>     compat code is not needed.

Did you test this? It definitely seems necessary since pointers have
different size and allignment requirements on 64 bit.

In the hashlimit case we have a 4 byte hole before the hinfo pointer
on 64 bit which is not present on 32 bit, limit uses an unsigned long
which has different size and also has a hole before the master pointer
on 64 bit.

