From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC v2 5/7] net: netfilter conntrack - add per-net	functionality
 for TCP protocol
Date: Thu, 26 Mar 2009 16:13:58 +0100
Message-ID: <49CB9BB6.3040004@trash.net>
References: <20090311205706.141086138@gmail.com> <20090311210817.688725782@gmail.com> <20090316205825.GK7551@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, daniel.lezcano@free.fr,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	xemul@openvz.org, adobriyan@gmail.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZCZPOH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:14:07 -0400
In-Reply-To: <20090316205825.GK7551@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cyrill Gorcunov wrote:
> Here is an updated version which uses iterative assignment
> of sysctl data. Please review.
> ---
> 
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [RFC v2 5/7] net: netfilter conntrack - add per-net functionality for TCP protocol
> 
> Module specific data moved into per-net site and being allocated/freed
> during net namespace creation/deletion. For this reason module_init/exit
> calls added.


I guess this isn't going to get any prettier :) Could you please
send me the latest version of the missing patches against the current
nf-next tree?
