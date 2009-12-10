From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: Fix compiler warning.
Date: Thu, 10 Dec 2009 14:08:43 -0800 (PST)
Message-ID: <20091210.140843.142337259.davem@davemloft.net>
References: <pvmein2bj1p.fsf@chavey.mtv.corp.google.com>
	<alpine.LSU.2.01.0912102301380.5189@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: chavey@google.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com,
	akpm@google.com
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39898
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761909AbZLJWIh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:08:37 -0500
In-Reply-To: <alpine.LSU.2.01.0912102301380.5189@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 10 Dec 2009 23:06:32 +0100 (CET)

> 
> On Donnerstag 2009-12-10 22:44, chavey@google.com wrote:
> 
>>Fix compiler warning "discards qualifiers from pointer target type",
>>by allowing explicit discard of const qualifier thru type casting.
>>The const_cast() macro is taken from a patch from Kaveh R. Ghazi
> 
> Uhm, I am not getting any warning on xt_time with either gcc-4.4.1
> or gcc-4.5_20091126, so what case are we actually trying to fix?

I get this warning with gcc-4.3.x all the time.
