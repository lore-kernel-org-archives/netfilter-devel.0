From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Fri, 5 Jul 2002 01:58:31 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020704235831.GO20357@naboo.ists.dartmouth.edu>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 03, 2002 at 01:24:46PM +0200, Jozsef Kadlecsik wrote:
> Also, no one answered the question yet on how to name an action module
> without breaking the current clear distiction in name between match and
> target modules.

i would just make them use uppercase, like targets.

> If the pseudo targets were converted to match modules, most of them
> could be unified with an already existing match module, which would
> result a more compact codebase (tcpmss/TCPMSS, ttl/TTL, tos/TOS, etc,
> etc.). I just repeat myself: the recent match is a nice example for
> this approach.

no, i really don't like this approach. unifying the codebase can be done
differently [like implementing match+target in one .c file]

> > > - multiple targets
> > >
> > >   It has been rejected several times with good reasons: too error-prone
> > >   for the users and it would require heavy modifications both in the
> > >   kernel and the userspace.
> >
> > the 'too heavy modification' issue is not really a problem anymore,
> > since the undergoing 'pkt_tables' rewrite [shared infrastructure for
> > iptables, ip6tables, arptables] and the linked-list rewrite.
> 
> Then one should consider this approach as well. If we had the possibility
> to specify multiple targets then the current clean concepts could be kept
> as well.

yes. But then, how do we distinguish between terminating targets [where
we can have only one per rule] and non-terminating targets AKA actions,
where we can have multiple.

> new action class:
> 	pro: no ordering problem
> 	pro: clean separation of functionalities
> 	con: naming issue
> 
> match module:
> 	pro: no naming issue, current well known concepts can be kept
> 	pro: couple of modules can be unified
> 	con: ordering issue

it just breaks the concept.  a match is by definition something which
matches against a certain criteria. it is not supposed to do anything.

> Jozsef

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
