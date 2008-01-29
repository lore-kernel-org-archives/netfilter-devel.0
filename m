From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_hashlimit: remove unneeded struct member
Date: Tue, 29 Jan 2008 19:09:47 +0100
Message-ID: <479F6BEB.8010601@trash.net>
References: <Pine.LNX.4.64.0801291636390.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61042 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYA2SJv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:09:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801291636390.14907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 9cd6d44dfc02166640166a44c27c3dc0a98b4ac3
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Jan 29 16:30:58 2008 +0100
> 
>     [NETFILTER]: xt_hashlimit: remove unneeded struct member
>     
>     By allocating ->hinfo, we already have the needed indirection to cope
>     with the per-cpu xtables struct match_entry.


You already sent this 30 minutes ago. This is not helping me
getting rid of my backlog ...

