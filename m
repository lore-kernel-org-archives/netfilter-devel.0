From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Fri, 17 Feb 2006 09:45:16 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
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

On Fri, 17 Feb 2006, Jozsef Kadlecsik wrote:

> > > Some clever solution should only be found to spread the expectations
> > > over multiple, separatedly locked buckets...
> >
> > I've talked to Harald about this and as a start we can start by
> > allowing masks only for the source part of the tuple. That
> > means we can hash by destinations.
>
> That's actually fine! Now I should complete that hashtrie/hashtable
> testing I have been planning...

Great that you are testing hashtrie, it works fine in all my simple tests
but there might still be a lot of bugs in it, especially in the forced
eviction, it might not be optimal, me and rusty tried to come up with a
way to make it fair wrt the depth in the tree we are evicting at.

If you have any suggestions and/or patches, please let me know :)

Are you using the 060104 version, that's the latest version I have of the
userspace code.
I have an old untested patch against nf_conntrack as well but it needs
some rewriting of the conntrack locking in order to avoid an SMP deadlock.

/Martin
