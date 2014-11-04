From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Date: Tue, 4 Nov 2014 09:31:50 -0500
Message-ID: <20141104093150.7410f6d0@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141104080535.5f651713@gandalf.local.home>
	<20141104142236.GA10239@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141104142236.GA10239@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 Nov 2014 15:22:36 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Tue, Nov 04, 2014 at 08:05:35AM -0500, Steven Rostedt wrote:
> > On Wed, 29 Oct 2014 17:56:04 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > [ REQUEST FOR ACKS ]
> > 
> > Can any of the netfilter folks give me an Acked-by for this?
> 
> If Florian's concern were addressed, then:

Yeah, the change he mentioned was done is 3/8. As that was written by
Joe Perches, I did some work that he missed and put it before his
patch, which showed a discrepancy between the two functions. After all
patches are applied, it should be consistent to his liking.

> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> to this patch and 4/8.

Thanks for this!

Can I get someone to ack 3/8?

Thanks again,

-- Steve
