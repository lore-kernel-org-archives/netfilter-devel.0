From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 1/5] net: netfilter conntrack - add per-net functionality
 for ICMP protocol
Date: Thu, 26 Mar 2009 17:16:31 +0100
Message-ID: <49CBAA5F.5020907@trash.net>
References: <20090326160544.519118777@openvz.org> <20090326160711.826548855@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
To: Cyrill Gorcunov <gorcunov@openvz.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35654 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZCZQQl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:16:41 -0400
In-Reply-To: <20090326160711.826548855@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cyrill Gorcunov wrote:
> Module specific data moved into per-net site and being allocated/freed
> during net namespace creation/deletion. For this reason module_init/exit
> calls added.

This doesn't work. You can't have multiple module_init functions
in one module and nf_connntrack_ivp4 already includes one.

Please test your patches with a modular built before resubmitting.
