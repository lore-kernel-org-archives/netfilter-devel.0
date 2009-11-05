From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit kernel fix (610)
Date: Thu, 05 Nov 2009 15:03:46 +0100
Message-ID: <4AF2DB42.2050701@trash.net>
References: <alpine.LSU.2.00.0911042240580.16279@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZKEODn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:03:43 -0500
In-Reply-To: <alpine.LSU.2.00.0911042240580.16279@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent 1e13cbc53085fc50ddb5f500218af806b8ae9d68 (v2.6.32-rc3-7-g1e13cbc)
> commit a7fe7609f6555189e9c743305fce640ae87f7825
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Nov 4 14:27:30 2009 +0100
> 
> netfilter: xt_connlimit: fix zero family value
> 
> Commit v2.6.28-rc1~717^2~109^2~2 was slightly incomplete; not all
> instances of par->match->family were changed to par->family.
> 

Applied, thanks Jan.
