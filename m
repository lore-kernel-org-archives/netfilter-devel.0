From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 18:07:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625160742.GG7975@naboo.ols.wavesec.org>
References: <008201c21a96$88eb6520$0489cb8a@etbx180> <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu> <20020625124744.GB7975@naboo.ols.wavesec.org> <025001c21c50$763fa880$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <025001c21c50$763fa880$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 03:59:01PM +0200, Jean-Michel Hemstedt wrote:
> > ??? Why should listing an IP table try to reserve twice the size of the
> > conntrack table?
> 
> this is in nat_init (or so): nat takes the conntrack hash size to
> allocate 2 additional nat hashes 'bysource' and 'byisproto'.

Ah. I was not aware that you didn't have iptable_nat loaded before the 
command.  Just issuing the '-L' command with no nat loaded does not 
allocate anything big inside the kernel.

> The question is, why do we init it, if we don't use it (on a rule
> point of view)? This init step should occur only if we insert a rule
> using nat.

no. This is again something I regard as feature, not as bug. dont load
the module if you don't use it.

It's the same behaviour like conntrack.

> kr,
> -jmhe-

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
