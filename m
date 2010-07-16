From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Fri, 16 Jul 2010 21:27:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net> <1279285829.1603.77.camel@powerslave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Changli Gao <xiaosuo@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36365 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966044Ab0GPT1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:27:50 -0400
In-Reply-To: <1279285829.1603.77.camel@powerslave>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-07-16 15:10, Luciano Coelho wrote:
>> > There is one problem with this solution, which is that it works in a
>> > per-connection basis (due to CONNMARK).  This is not exactly what I
>> > want.  I need to have this on a per-ruleset basis.  For that, I need to
>> > have a MARK (variable?) which can be set independently of connections or
>> > packets.  This is similar to the proposed condition match, but what is
>> > missing there is a way to set the condition with iptables itself,
>> > without requiring the userspace to change the procfs file.  This could
>> > probably be achieved with a "CONDITION" target or something similar.
>> > Any ideas?
>> 
>> Sounds useful.
>
>Okay, this was the kind of confirmation I wanted before jumping into the
>implementation. ;) I'll implement this target soon.

My suggestion to have it combined with xt_condition.

