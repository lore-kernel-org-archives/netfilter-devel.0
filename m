From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC] matching tproxied packets
Date: Wed, 5 Jun 2002 13:08:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020605110800.GA11057@balabit.hu>
References: <20020605102111.GA10760@balabit.hu> <Pine.LNX.4.33.0206051233530.8715-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206051233530.8715-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 05, 2002 at 01:02:44PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 5 Jun 2002, Balazs Scheidler wrote:
> 
> > ok, should I simply add fields somewhere in struct ip_conntrack, or there's
> > a bitfield I can add a flag to?
> 
> There is no such bitfield you could use at the moment.
> 
> > Looking at the struct I can't see a place general enough, so I can add a new
> > field just to hold a single bit, or a general "flags" field, which can be
> > used by other matches later.
> 
> This is a good question. Probably it is better to add a (general) 'flags'
> field. But I have no idea for what else we could use it :-)

As I added a flags argument to ip_nat_setup_info() (currently with a single
bit specifying that NAT helpers are to be bypassed), this flags could be
stored in ct->nat.flags

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
