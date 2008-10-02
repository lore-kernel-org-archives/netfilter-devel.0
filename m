From: Patrick McHardy <kaber@trash.net>
Subject: Re: 06/11 [NETFILTER]: ebt_among: obtain match size through different
 means
Date: Thu, 02 Oct 2008 12:22:04 +0200
Message-ID: <48E4A0CC.2000000@trash.net>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0809102245250.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54004 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYJBKXF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:23:05 -0400
In-Reply-To: <alpine.LNX.1.10.0809102245250.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit bf2819b12227becf56bee62047bace59931505c8
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Sep 11 02:27:31 2008 -0400
>
> [NETFILTER]: ebt_among: obtain match size through different means
>
> The function signatures will be changed to match those of Xtables, and
> the datalen argument will be gone. ebt_among unfortunately relies on
> it, so we need to obtain it somehow.
>   

Applied, thanks.
