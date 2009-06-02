From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 2 Jun 2009 14:09:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906021405510.11925@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu> <4A2514EA.6000100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:35260 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZFBMJV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:21 -0400
In-Reply-To: <4A2514EA.6000100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Jun 2009, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Sun, 31 May 2009, Jozsef Kadlecsik wrote:
> > 
> > > ---
> > >  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
> > >  net/netfilter/nf_conntrack_proto_tcp.c     |   97
> > > +++++++++++++++++-----------
> > >  2 files changed, 61 insertions(+), 38 deletions(-)
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > 
> > Sorry, that line was not added.
> 
> Applied to nf-next.git, thanks Jozsef. I've made two minor changes:
> 
> - keep TCP_CONNTRACK_LISTEN around to avoid userspace compilation
>   errors and make the new state a #define to be able to check for
>   it using the preprocessor:
> 
> 	TCP_CONNTRACK_LISTEN,	/* obsolete */
> #define TCP_CONNTRACK_SYN_SENT2	TCP_CONNTRACK_LISTEN
> 
> - fixed a compilation error resulting from a missing '{':
> 
> >  		.proc_handler	= proc_dointvec_jiffies,
> >  	},
> > +		.procname	= "ip_conntrack_tcp_timeout_syn_sent2",
> > +		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT2],

That's a copy-paste bug, sorry: I have to run a slighty older kernel 
release on my test system and I selected the paste area one line off.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
