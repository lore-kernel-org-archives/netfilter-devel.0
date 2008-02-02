From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Sat, 02 Feb 2008 22:10:57 +0100
Message-ID: <47A4DC61.6070600@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de> <47A2E256.6080600@trash.net> <47A320A4.3030203@netfilter.org> <47A34696.5070109@astaro.com> <47A34D28.2010303@netfilter.org> <47A3517A.40205@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41469 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756646AbYBBVLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:11:08 -0500
In-Reply-To: <47A3517A.40205@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Another option would be to just provide the newest code, without a
> history at all.  Is that what you like more?

No, you don't get my point. I don't doubt on the worthiness of your
contributions, I'm only stating that you don't do it right. Please,
rework your contribution with my suggestions and try again.

>>> That patch was provided exactly to solve that issue.
>>
>> ... because AFAICS if we check for ENOBUFS and then resync against the
>> kernel table using GET_CONNTRACK we won't need the sequence cache later,
>> will we?
> 
> You will on a busy site.  The sole purpose of checking ENOBUFS or
> NETLINK_OVERRUN is to check whether you need that logic during normal
> operation.  So, on a not-so-busy site you won't have those GET_CONNTRACK
> requests at all.
> 
> Of course the GET_CONNTRACK requests should be disabled if there wasn't
> any overrun for a certain period of time (e. g. one turnaround).
> 
> But still that's only an optimisation.

Sorry, I don't understand what you mean here.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
