From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: inclusion of xt_SYSRQ
Date: Thu, 12 Jul 2012 23:25:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207122252070.29206@frira.zrqbmnf.qr>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de> <1341964350-13809-5-git-send-email-jengelh@inai.de> <20120712154957.GE18793@1984> <alpine.LNX.2.01.1207121822430.13237@frira.zrqbmnf.qr> <20120712202608.GA9927@breakpoint.cc>
 <alpine.LNX.2.01.1207122229420.27546@frira.zrqbmnf.qr> <20120712203541.GB9927@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:43811 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987Ab2GLVZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:25:29 -0400
In-Reply-To: <20120712203541.GB9927@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-07-12 22:35, Florian Westphal wrote:

>Jan Engelhardt <jengelh@inai.de> wrote:
>> >Jan Engelhardt <jengelh@inai.de> wrote:
>> >> David Miller has stated his opinion already last year, and he's
>> >> for the Netfilter variant:
>> >> http://markmail.org/message/d7kpczdbtpcxwli6
>> >
>> >We now have udp encap support also for ipv6, so this could now
>> >be solved outside of netfilter without impacting the ability to
>> >filter sysreq packets.
>> 
>> How does xt_SYSRQ inhibit filtering sysrq packets?
>
>Not at all.  But the last 'do it outside of netfilter' approaches
>suffered from that.  With encap sockets this should no longer be a
>problem.

People like using Xtables because it's simple and they know how to
use it (or at least, the frontend). The biggest strength is that
users can _combine it with existing extensions_. All that seems
impossible with the sysrq-ping patch.

(You know how they hate it when they have to cross a "boundary" like
iptables-nfmark-tc and iptables-nfmark-iproute).
