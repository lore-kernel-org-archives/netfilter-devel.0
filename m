From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH v2] netfilter: ebt_ip6: allow matching on ipv6-icmp types/codes
Date: Mon, 20 Dec 2010 19:17:03 +0100
Message-ID: <4D0F9D9F.7090608@pandora.be>
References: <1292857067-1595-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:37148 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab0LTSRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:17:07 -0500
In-Reply-To: <1292857067-1595-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 20/12/2010 15:57, Florian Westphal schreef:
> To avoid adding a new match revision icmp type/code are stored
> in the sport/dport area.
>
> Signed-off-by: Florian Westphal<fw@strlen.de>
> Reviewed-by: Holger Eitzenberger<holger@eitzenberger.org>
> ---
>   Changes since v1:
>    - use u16 where appropriate
>    - use proper () in if condition
>    - renamed _ports to _pkthdr
>    - add comment that sizeof(_pktheader) is also ok in ICMP6 case.
>
>   include/linux/netfilter_bridge/ebt_ip6.h |   15 ++++++++--
>   net/bridge/netfilter/ebt_ip6.c           |   46 ++++++++++++++++++++++--------
>   2 files changed, 46 insertions(+), 15 deletions(-)
>
OK for me.

Reviewed-by: Bart De Schuymer<bdschuym@pandora.be>

