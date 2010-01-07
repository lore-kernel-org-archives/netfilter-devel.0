From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ebtables: enforce CAP_NET_ADMIN
Date: Thu, 07 Jan 2010 18:37:39 +0100
Message-ID: <4B461BE3.6050200@trash.net>
References: <1262715967-25274-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47602 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0AGRho (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:37:44 -0500
In-Reply-To: <1262715967-25274-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> normal users are currently allowed to set/modify ebtables rules.
> Restrict it to processes with CAP_NET_ADMIN.
> 
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> ---
>  Note that this cannot be reproduced with
>  unmodified ebtables binary because it uses SOCK_RAW.

Unbelievable that this went unnoticed for so long. Applied and
queued for -stable, thanks a lot Florian.
