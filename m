From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Wed, 26 Jun 2002 10:18:22 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020626081822.GA25269@balabit.hu>
References: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180> <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu> <20020625151302.GA21293@balabit.hu> <20020625190647.GL7975@naboo.ols.wavesec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020625190647.GL7975@naboo.ols.wavesec.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 09:06:47PM +0200, Harald Welte wrote:
> On Tue, Jun 25, 2002 at 05:13:02PM +0200, Balazs Scheidler wrote:
> > On Tue, Jun 25, 2002 at 04:17:54PM +0200, Jozsef Kadlecsik wrote:
> > > On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:
> > > > what do you mean by 'book-keeping' ?
> > > > Does NAT do a lookup even if there are no rules?
> > > 
> > > I have to write again: even if there are no any rules, NULL
> > > mapping happens and new connections must be put into both nat hashes.
> > 
> > This should not explain the performance degradation others found. If no
> > rules are found in the table, the conntrack entry is added to the NAT
> > hashes. (place_in_hashes() function), this involves adding the entry to two
> > linked lists (changes two pointers per list), and then calling do_bindings()
> > which does nothing (num_manips == 0) except for calling helpers, which
> > should be none, if helper modules are not loaded.
> > 
> > Adding entries to the NAT hashes doesn't involve memory allocation (NAT info
> > is stored in ip_conntrack), therefore I don't see the reason for the 50%
> > performance decrease.
> 
> think about the lock contention on SMP system. The 'null binding'
> approach for nat (and for example, that nat helpers are called for
> connections with 'null binding') is a poor design.  
> 
> I've recently did some testing which try to avoid the null binding, but 
> as I'm not entirely sure they don't break something else I haven't been
> releasing them yet.

The original test machine used to gather performance information was not
SMP:

"
here is my test bed:

tested target:
 -kernel 2.4.18 + non_local_bind + small conntrack timeouts...
 -PIII~500MHz, RAM=256MB
 -2*100Mb/s NIC

"

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
