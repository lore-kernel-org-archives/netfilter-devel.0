From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Fri, 5 Jul 2002 16:21:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705142127.GK21280@naboo.ists.dartmouth.edu>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu> <20020704235831.GO20357@naboo.ists.dartmouth.edu> <200207051201.21457.fabrice@celestix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Fabrice MARIE <fabrice@celestix.com>
Content-Disposition: inline
In-Reply-To: <200207051201.21457.fabrice@celestix.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 05, 2002 at 12:01:21PM +0800, Fabrice MARIE wrote:
> 
> Hello Harald,
> 
> On Friday 05 July 2002 07:58, Harald Welte wrote:
> > [...]
> > yes. But then, how do we distinguish between terminating targets [where
> > we can have only one per rule] and non-terminating targets AKA actions,
> > where we can have multiple.
> 
> You could just add a boolean field 'terminating' to the iptables_target.
> Then, make sure iptables abort and complains if it sees more than one
> terminating target being requested in a single rule.

no, it's not about how to distinguish it internally.  It was more like:
How does the user know which targets terminate and which don't [just by
looking at the name or it's usage]

> But now, if you don't want to use the match piggybacking trick that
> Jozsef & Henrik mentionned, then we can't implement that right now.

no.  There is no reason in implementing it right now anyway.  A change
like this would not appeear in 2.4.x anyway...

> Do you think multiple targets is worth including in the design of the next
> netfilter framework ?

it's not a big issue anyway. Instead of a fixed single target entry,
there is a linked list.  I'm already working on that code..

> I bielieve we should do that, multiple actions for one condition is
> very natural, and I believe the usage of a custom chain for each of
> theses rules is a bit overkill..

yes, it helps in some cases, but not in all.

> Any thoughts ?
> Fabrice.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
