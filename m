From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 15:51:13 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625135113.GE7975@naboo.ols.wavesec.org>
References: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu> <021a01c21c4b$47b2f2b0$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <021a01c21c4b$47b2f2b0$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 03:21:56PM +0200, Jean-Michel Hemstedt wrote:
> > > loading a module, doesn't mean using it (lsmod reports it as 'unused'
> > > in my tests). So, does it really 'sounds as expected', when you see
> > 
> > From where do you think that the module usage counter reports how many
> > packets/connections are handled (currently? totally?) by the module.
> > There is no whatsoever connection!
> 
> module usage counter increases when a TARGET needs it (i.e. ipt_REDIRECT).
> In this test, no rule was defined, and no target module was loaded.
> So I did not expect NAT to process any packet.

the way NAT is implemented currently, it always processes every packet
the same way.  For a NEW packet where we don't find a nat rule, we
allocate a 'null binding' telling the nat code that there is no nat 
transformation to be made .

> But this raises one additional problem: 
> 1) the hash index size and the hash total size should be configurable 
> separately (get rid of that factor 8, and use a free list for the tuple 
> allocation).
> 2) NAT hash sizes should also be configurable independently from conntrack.
> Normally the nat hashes are smaller than conntrack hash, since conntrack
> is based on ports, while nat is not.

both of this is already true. look at the module loadtime parameters of
ip_conntrack.o and iptable_nat.o

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
