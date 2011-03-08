From: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Subject: Re: [PATCH] iptables: add -C to check for existing rules
Date: Tue, 8 Mar 2011 22:15:03 +0100
Message-ID: <20110308211503.GZ11294@zirkel.wertarbyte.de>
References: <20110308115639.GA30013@zirkel.wertarbyte.de>
 <alpine.LNX.2.01.1103081955520.2391@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zirkel.wertarbyte.de ([188.40.44.137]:48057 "EHLO
	zirkel.wertarbyte.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1CHVPF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:15:05 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1103081955520.2391@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dies schrieb Jan Engelhardt (jengelh@medozas.de):

> > /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
> > /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
> > /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
> >-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
> >+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
> >+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '}
> 
> This would make it impossible to check for a rule that used the fragment
> test.
> 
> Does --lin even make sense with -C?

I'm not sure, I simply copied the line for DELETE to mimic the interface. In
fact, -C does exactly the same thing as -D - except the actual removal of the
rule.

> Where is ip6tables support?

It will probably follow soon, just like the missing paragraph of the man page :-)
