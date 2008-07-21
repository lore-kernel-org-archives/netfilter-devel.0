From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables: use nf_register_hooks()
Date: Mon, 21 Jul 2008 18:28:58 +0200
Message-ID: <4884B94A.7020002@trash.net>
References: <20080721162349.GA13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41901 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYGUQ3A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:29:00 -0400
In-Reply-To: <20080721162349.GA13264@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  net/bridge/netfilter/ebtable_filter.c |   18 +++++-------------
>  net/bridge/netfilter/ebtable_nat.c    |   18 +++++-------------
>  2 files changed, 10 insertions(+), 26 deletions(-)

One minute too late for getting included my last netfilter update :)

Applied, thanks.
