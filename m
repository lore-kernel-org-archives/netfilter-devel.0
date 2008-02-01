From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 22/30] Add set_sockbuf_len()
Date: Fri, 01 Feb 2008 10:20:40 +0100
Message-ID: <47A2E468.8050502@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190129.323941901@kruemel.intranet.astaro.de>	<47A2970D.2010208@netfilter.org> <871w7xay0q.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, heitzenberger@astaro.com,
	netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYBAJUr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:20:47 -0500
In-Reply-To: <871w7xay0q.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>> AFAIK, there's a similar function in libnfnetlink which uses
>> SO_RCVBUF_FORCE instead.
> 
> Thanks for the info.  libnl also implements a similar kind of
> function.  At the time I completely switch that I'll of course
> use that one.


I guess thats also a simple patch on top. I'll see whether
I can apply there patches while switching to the libnfnetlink
function. I guess it shouldn't cause any conflicts since its
only a single caller from what I can see.
