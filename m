From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 17:13:02 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625151302.GA21293@balabit.hu>
References: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180> <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 04:17:54PM +0200, Jozsef Kadlecsik wrote:
> On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:
> > > The book-keeping overhead is at least doubled compared to the
> > > conntrack-only case - this explains pretty well the results you got.
> >
> > what do you mean by 'book-keeping' ?
> > Does NAT do a lookup even if there are no rules?
> 
> I have to write again: even if there are no any rules, NULL
> mapping happens and new connections must be put into both nat hashes.

This should not explain the performance degradation others found. If no
rules are found in the table, the conntrack entry is added to the NAT
hashes. (place_in_hashes() function), this involves adding the entry to two
linked lists (changes two pointers per list), and then calling do_bindings()
which does nothing (num_manips == 0) except for calling helpers, which
should be none, if helper modules are not loaded.

Adding entries to the NAT hashes doesn't involve memory allocation (NAT info
is stored in ip_conntrack), therefore I don't see the reason for the 50%
performance decrease.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
