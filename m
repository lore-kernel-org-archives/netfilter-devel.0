From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 17:22:49 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625152249.GB21293@balabit.hu>
References: <021a01c21c4b$47b2f2b0$0489cb8a@etbx180> <Pine.LNX.4.33.0206251636130.539-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206251636130.539-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 04:53:33PM +0200, Jozsef Kadlecsik wrote:
> On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:
> > PS: could anybody redo similar tests so that we can compare the results
> >     and stop killing the messenger, please? ;o)
> 
> Sorry if I look harsh, it's not my intention at all. We were simply over
> almost exaclty the same arguments several times. And those resulted
> neither pinpointing real flaws in the system, nor better algorithms.

no only head pointers for hashes are preallocated. conntrack structures
themselves are allocated by the slab allocator: kmem_cache_alloc() called in
init_conntrack() which initializes a single conntrack entry.

So the initial memory allocations for conntrack and nat are

conntrack: htable_size * 8 

(8 is sizeof(list_head))

nat: 2 * htable_size * 8

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
