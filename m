From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
Date: Thu, 29 Nov 2007 23:28:20 +0100
Message-ID: <474F3D04.1020000@trash.net>
References: <Pine.LNX.4.64.0711292314110.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	davem@davemloft.net, stable@kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58459 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760977AbXK2W2x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:28:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711292314110.3089@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
>
>
> When xt_CONNMARK is used outside the mangle table and the user specified
> "--restore-mark", the connmark_tg_check() function will (correctly)
> error out, but (incorrectly) forgets to release the L3 conntrack module.
> Same for xt_CONNSECMARK.
> Fix is to move the call to acquire the L3 module after the basic 
> constraint checks.
>   

Applied, thanks Jan.

