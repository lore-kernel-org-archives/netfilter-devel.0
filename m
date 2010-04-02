From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: br_netfilter post routing hook question...
Date: Fri, 02 Apr 2010 20:47:37 +0200
Message-ID: <4BB63BC9.1050000@pandora.be>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com> <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com> <CB2DD11991B27C4F99935E6229450D320566ACAE@STORK.scenix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: agashi shipora <gashipo@gmail.com>, netfilter-devel@vger.kernel.org
To: Gareth Williams <gwilliams@ubicom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:43480 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0DBSrk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:47:40 -0400
In-Reply-To: <CB2DD11991B27C4F99935E6229450D320566ACAE@STORK.scenix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gareth Williams schreef:
> The product is a router and the bridge (br0) is connecting the lan to wlan.  The module only wants to examine packets on the bridge for qos purposes - to wlan and so I can, at the bridge layer, check for packets to/from ath0 (the wireless port).  At PF_INET I would only see br0 so my qos scope would be too wide.
>
>   
The iptables physdev match will probably save your day.


cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

