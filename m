From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC] matching tproxied packets
Date: Wed, 5 Jun 2002 12:21:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020605102111.GA10760@balabit.hu>
References: <20020604145036.GA1295@balabit.hu> <Pine.LNX.4.33.0206050852190.8715-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206050852190.8715-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 05, 2002 at 08:53:25AM +0200, Jozsef Kadlecsik wrote:
> On Tue, 4 Jun 2002, Balazs Scheidler wrote:
> > Possible solutions:
> >
> > * use a new state (called TPROXY), which would be applied to all TPROXYed
> >   packets (might interact badly with nat/conntrack).
> > * have the tproxy framework mark all packets with an fwmark, and let the
> >   packets in based on the value of fwmark
> > * have a separate match (called tproxy), which matches tproxied sessions
> >   based on some value stored in the associated conntrack entry
> >
> > which one do you prefer?
> 
> The latter seems to me the best solution.

ok, should I simply add fields somewhere in struct ip_conntrack, or there's
a bitfield I can add a flag to? 

Looking at the struct I can't see a place general enough, so I can add a new
field just to hold a single bit, or a general "flags" field, which can be
used by other matches later.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
