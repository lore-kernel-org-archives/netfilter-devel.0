From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Wed, 30 Oct 2002 03:59:30 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030115930.24839.qmail@web40910.mail.yahoo.com>
References: <20021030100457.X8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021030100457.X8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald,

--- Harald Welte <laforge@gnumonks.org> wrote:
> On Tue, Oct 29, 2002 at 10:43:07PM -0600, allen wrote:
> > 
> > 
> > On Tuesday 29 October 2002 12:54 pm, Stephane Ouellette wrote:
> > >    I developped last week a new extension to Netfilter in order to
> > > enable or disable a set of rules using /proc files.
> > 
> > 
> > Yeah, as others have said, the idea is definitely cool.
> 
> Though the idea is cool, I think we are solving a problem the wrong way.  Why
> add complexity to the kernel for a problem which can be solved without
> any problem from userspace?
> 
> Where is the problem in having a couple of different rulesets (e.g. created
> with iptables-save) which are then loaded using an iptables-restore
> commandline or a script at the shell of the firewall?

Because right now the method of reloading rules is still inefficient. What if you
have a ruleset of 1000-10000 rules and only want to toggle 5? Removing those rules
would require a full replacement of the ruleset for the table and chain the rules
were placed in (IIRC). Doing it this way allows you to disable/enable rules without
having to actually modify them.

Maybe once nfnetlink goes into the 2.7 kernel this will go away, but that's a long
time IMHO.....

> 
> 
> -- 
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/

Brad



=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________________________
Do you Yahoo!?
HotJobs - Search new jobs daily now
http://hotjobs.yahoo.com/
