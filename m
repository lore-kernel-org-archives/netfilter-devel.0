From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Date: Tue, 4 Nov 2014 15:46:32 +0100
Message-ID: <20141104144632.GA11096@salvia>
References: <20141029215602.535533597@goodmis.org>
 <20141029220107.465008329@goodmis.org>
 <20141104080535.5f651713@gandalf.local.home>
 <20141104142236.GA10239@salvia>
 <20141104093150.7410f6d0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaKDOor (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:44:47 -0500
Content-Disposition: inline
In-Reply-To: <20141104093150.7410f6d0@gandalf.local.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 04, 2014 at 09:31:50AM -0500, Steven Rostedt wrote:
> On Tue, 4 Nov 2014 15:22:36 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Tue, Nov 04, 2014 at 08:05:35AM -0500, Steven Rostedt wrote:
> > > On Wed, 29 Oct 2014 17:56:04 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > 
> > > > [ REQUEST FOR ACKS ]
> > > 
> > > Can any of the netfilter folks give me an Acked-by for this?
> > 
> > If Florian's concern were addressed, then:
> 
> Yeah, the change he mentioned was done is 3/8. As that was written by
> Joe Perches, I did some work that he missed and put it before his
> patch, which showed a discrepancy between the two functions. After all
> patches are applied, it should be consistent to his liking.
> 
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > to this patch and 4/8.
> 
> Thanks for this!
> 
> Can I get someone to ack 3/8?

I don't see any 3/8 in my inbox, only 2/8 and 4/8.

Let me know, thanks.
