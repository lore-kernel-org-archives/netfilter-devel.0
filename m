From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: delete useless characters
Date: Fri, 18 Apr 2014 14:36:25 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1404181435340.27921@nerf08.vanv.qr>
References: <20140416161038.1237.5216.stgit@nfdev.cica.es> <20140416163258.GA30296@macbook.localnet> <CAOkSjBiF2pv5z+wvguL0bTkB2vB=s7QA9-X=koZYP689TjFWoQ@mail.gmail.com> <20140416165046.GA951@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:59520 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRMg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:36:26 -0400
In-Reply-To: <20140416165046.GA951@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2014-04-16 18:50, Patrick McHardy wrote:

>On Wed, Apr 16, 2014 at 06:38:50PM +0200, Arturo Borrero Gonzalez wrote:
>> On 16 April 2014 18:32, Patrick McHardy <kaber@trash.net> wrote:
>> >
>> > I assume you're on debian? The -e is needed to interpret the backslash
>> > sequences like \t. Something is broken about the echo command in debian,
>> > I'd assume its using the shell internal one instead of /bin/echo.
>> >
>> 
>> Yes, you are right. Then forget this patch.
>> 
>> I was reading a bit the build system, wondering how to get the actual
>> form of the CC commands.
>
>Try using the full path to echo perhaps.

What about the automake patch I sent some months back? It would address 
the issue in a fashion that's also compatible with variants of sh/echo 
that do not support -e/-n.
