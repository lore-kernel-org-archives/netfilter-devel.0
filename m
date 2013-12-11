From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipt_SYNPROXY: kernel panic caused by nullpointer dereference
Date: Wed, 11 Dec 2013 11:33:04 +0100
Message-ID: <20131211103304.GA7540@localhost>
References: <e9d26e1c009f406b1bb5a893aebc7771.squirrel@webmail.interwerk.de>
 <20131208100146.GA3840@localhost>
 <20131208165231.GA1564@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Nicki P." <xastx@gmx.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60626 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3LKKdL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:33:11 -0500
Content-Disposition: inline
In-Reply-To: <20131208165231.GA1564@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 08, 2013 at 04:52:31PM +0000, Patrick McHardy wrote:
> On Sun, Dec 08, 2013 at 11:01:46AM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Dec 08, 2013 at 08:16:00AM +0100, Nicki P. wrote:
> > > hi,
> > > 
> > > when activating ipt_SYNPROXY with:
> > > iptables -t raw -A PREROUTING -p tcp -d 1.2.3.4 --dport 80 --tcp-flags
> > > SYN,ACK,RST,FIN SYN -j SYNPROXY
> > >
> > > and sending a SYN packet to port 80:
> > > hping3 -S -d 64 1.2.3.4 -p 80
> > > 
> > > I get kernel panic:
> > > http://goo.gl/L6dCz6
> > >
> > > I'm using kernel v3.12.2 and iptables v1.4.21. Am I doing something wrong,
> > > or is it a bug?
> > 
> > You have to run this from the INPUT/FORWARD chain, SYNPROXY needs the
> > routing information to work.
> 
> Let's fix that:
> 
> From e5b31e75df3c3f9629900016a95336c04165d13f Mon Sep 17 00:00:00 2001
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 8 Dec 2013 16:49:36 +0000
> Subject: [PATCH] netfilter: SYNPROXY target: restrict to INPUT/FORWARD
> 
> Fix a crash in synproxy_send_tcp() when using the SYNPROXY target in the
> PREROUTING chain caused by missing routing information.

Applied, thanks Patrick!
