From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 9/18] Netfilter: Clean up the kmod handling code in
	iptables.c
Date: Thu, 6 Jan 2005 02:30:31 +0100
Message-ID: <20050106013031.GT26856@postel.suug.ch>
References: <1104896029.20582.72.camel@localhost.localdomain>
	<20050105181249.GS26856@postel.suug.ch>
	<1104973817.20582.110.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Linus Torvalds <torvalds@osdl.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@cyberus.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1104973817.20582.110.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Rusty Russell <1104973817.20582.110.camel@localhost.localdomain> 2005-01-06 12:10
> On Wed, 2005-01-05 at 19:12 +0100, Thomas Graf wrote:
> > * Rusty Russell <1104896029.20582.72.camel@localhost.localdomain> 2005-01-05 14:33
> > > Name: Clean up the kmod handling code in iptables.c
> > > Status: Tested under nfsim
> > > 
> > > 4) Remove __ipt_mutex_up() and __ipt_find_target_lock() which weren't
> > >    used (even in patch-o-matic AFAICT).
> > 
> > Those are used by ipt action (net/sched/ipt.c).
> > 
> > Readds __ipt_find_target_lock() and __ipt_mutex_up() and adapts ipt.c
> > to correctly use it. module must be given back properly upon cleanup.
> > removes the comments demanding for proper module refcnt since
> > find_target_lock() takes care of this now.
> 
> OK, thanks.  You missed a module_put in the check_entry-failed error
> path though.

Agreed, thanks.

> I looked harder at this, and I prefer this patch:

Looks fine to me.
