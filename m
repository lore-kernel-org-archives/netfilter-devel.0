From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nf_conntrack_tcp] Export ip_ct_tcp_state variables to
 userspace
Date: Tue, 17 Dec 2013 15:30:59 +0100
Message-ID: <20131217143059.GA13342@localhost>
References: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
 <20131217131640.GA8894@localhost>
 <CAKfDRXg2uok+E8+O+GsSJfBmNVyQR03iw=+EtT77su0LJcUbaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab3LQObF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:31:05 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXg2uok+E8+O+GsSJfBmNVyQR03iw=+EtT77su0LJcUbaw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 17, 2013 at 03:22:50PM +0100, Kristian Evensen wrote:
> Hi Pablo,
> 
> Thank you very much for your reply.
> 
> On Tue, Dec 17, 2013 at 2:16 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > We have limited bandwidth in the event path and this information would
> > be also included in those messages.
> 
> Ah, I see, I missed that one. Thanks for letting me know.
>
> > Looking at the existing Netfilter userspace software that we have now,
> > I cannot see how we can benefit from this proposed feature.
> 
> One example application I thought of was a "middlebox/router-version"
> of ss, with some added logic for for example identifying TCP
> connections.

I guess that application you refer can be the conntrack [1] userspace
tool.

I still don't see how that information can be useful to be included in
that output as it changes very fast and by polling you will only get
stale snapshots of what it's actually happening in the TCP tracking
subsystem.

[1] http://www.netfilter.org/projects/conntrack-tools/index.html
