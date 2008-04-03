From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/29] [NETFILTER]: Use unsigned types for hooknum and
 pf vars
Date: Thu, 03 Apr 2008 17:02:36 +0200
Message-ID: <47F4F18C.8000307@trash.net>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <af437bf3afbf0130adde82eb5810b66f2fa52c37.1206469820.git.jengelh@computergmbh.de> <47EAB2DE.2070902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37358 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbYDCPCl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:02:41 -0400
In-Reply-To: <47EAB2DE.2070902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Using u16 or something similar sizes would have made more sense
> for the families, but it removes some inconstencies, so I've
> applied it.

Dropped again:

sERROR: use tabs not spaces
#55: FILE: include/linux/netfilter.h:156:
+               struct net_device *indev, struct net_device *outdev,$

...

total: 25 errors, 0 warnings, 801 lines checked
