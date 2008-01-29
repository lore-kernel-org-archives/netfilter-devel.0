From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Tue, 29 Jan 2008 14:08:11 +0100
Message-ID: <479F253B.6060508@trash.net>
References: <Pine.LNX.4.64.0801242337480.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54504 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764064AbYA2NYJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:24:09 -0500
In-Reply-To: <Pine.LNX.4.64.0801242337480.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7f1764fa749032eb8566226bbd1c5a58a8a5efc6
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 16 18:58:49 2008 +0100
> 
>     [NETFILTER]: xt_conntrack: add port and direction matching
>     
>     Extend the xt_conntrack match revision 1 by port matching (all four
>     {orig,repl}{src,dst}) and by packet direction matching.

Applied, thanks.
