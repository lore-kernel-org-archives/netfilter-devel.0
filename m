From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 05/30] Add signalling subsystem
Date: Fri, 01 Feb 2008 10:17:04 +0100
Message-ID: <47A2E390.1090502@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.013311819@kruemel.intranet.astaro.de>	<47A295FA.2040709@netfilter.org> <8763x9ay4b.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, heitzenberger@astaro.com,
	netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42008 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYBAJRK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:17:10 -0500
In-Reply-To: <8763x9ay4b.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>> Hm, why do we poll now every 1 second event even if there's nothing to do?
> 
> AFAIRK I initially planned to use that for timers.  But yes, this is
> worth to be removed later on.  Thanks.


Thanks for noticing this. Since its a probably a major effort to
respin these patches I tend to favour the "fix later" solution.
Holger, I assume this would be a simple fix on top?

