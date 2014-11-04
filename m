From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Date: Tue, 4 Nov 2014 09:11:57 -0500
Message-ID: <20141104091157.24066441@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141104080535.5f651713@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141104080535.5f651713@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 Nov 2014 08:05:35 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 29 Oct 2014 17:56:04 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > [ REQUEST FOR ACKS ]
> 
> Can any of the netfilter folks give me an Acked-by for this?
> 

I hope nobody expects Jozsef Kadlecsik to do this, as I'm getting "Mail
Delivery Failures" from him with this message:

>>> kadlec@blackhole.kfki.hu (after RCPT TO): 550 5.7.1 <kadlec@blackhole.kfki.hu>: Recipient address rejected: Access denied. Your site is banned because of the unsolicited mail messages received from it.  

Wow, seems they are banning all Time Warner Cable customers in my area!

-- Steve
