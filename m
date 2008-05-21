From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] add full support for SCTP to ctnetlink
Date: Wed, 21 May 2008 13:12:42 +0200
Message-ID: <483403AA.9000909@trash.net>
References: <483350CA.10202@netfilter.org> <4833529D.40807@netfilter.org> <483352FB.10808@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37411 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbYEULMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 07:12:43 -0400
In-Reply-To: <483352FB.10808@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> Pablo Neira Ayuso wrote:
>>> [PATCH] add full support for SCTP to ctnetlink
>>>
>>> This patch adds full support for SCTP to ctnetlink. This includes three
>>> new attributes: state, original vtag and reply vtag.
>>>
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> I'm resending this patch because I've been working against an old kernel
>> tree. The patch attached should apply fine.
> 
> Wrong again. Sorry. Attached the correct patch.


Applied, thanks.

