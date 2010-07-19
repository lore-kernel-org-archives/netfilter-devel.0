From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 19 Jul 2010 08:30:23 +0300
Message-ID: <1279517423.7097.2.camel@powerslave>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
	 <1279285829.1603.77.camel@powerslave>
	 <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ext Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Changli Gao <xiaosuo@gmail.com>
To: ext Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41357 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0GSFaz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jul 2010 01:30:55 -0400
In-Reply-To: <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-07-16 at 21:27 +0200, ext Jan Engelhardt wrote:
> On Friday 2010-07-16 15:10, Luciano Coelho wrote:
> >> > There is one problem with this solution, which is that it works in a
> >> > per-connection basis (due to CONNMARK).  This is not exactly what I
> >> > want.  I need to have this on a per-ruleset basis.  For that, I need to
> >> > have a MARK (variable?) which can be set independently of connections or
> >> > packets.  This is similar to the proposed condition match, but what is
> >> > missing there is a way to set the condition with iptables itself,
> >> > without requiring the userspace to change the procfs file.  This could
> >> > probably be achieved with a "CONDITION" target or something similar.
> >> > Any ideas?
> >> 
> >> Sounds useful.
> >
> >Okay, this was the kind of confirmation I wanted before jumping into the
> >implementation. ;) I'll implement this target soon.
> 
> My suggestion to have it combined with xt_condition.

Yes, I also think that is the best idea.  I'll implement a CONDITION
target that will work together with the condition match.  For now I'll
use the non-final version you submitted some time ago.


-- 
Cheers,
Luca.

