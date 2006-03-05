From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Sun, 5 Mar 2006 10:49:43 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603051026320.28988@blackhole.kfki.hu>
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
	<Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
	<Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
	<Pine.LNX.4.58.0602171921540.31400@blackhole.kfki.hu>
	<1141489406.3881.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1141489406.3881.23.camel@localhost.localdomain>
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

Hi Martin,

On Sat, 4 Mar 2006, Martin Josefsson wrote:

> I'll move my svn tree to the netfilter svn sometime soon.

That'll be great!

> > - there should be some (whatever artifical) tests to study the
> >   dynamical behaviour of the hashtrie: say all the entries are
> >   added, then half of them deleted and added back again, but
> >   in reverse order. Will the maxdepth grow?
>
> I've performed some simple tests with this and here are the results:
>
> First I tried removing the upper half of the conntrack entries (it's the
> conntrack entries index in the test array that's printed out in the
> "Removing" line below)
>
> Number of entries in hashtrie: 819200
> Number of children in hashtrie: 27345
> Maxdepth of hashtrie: 3 (0 == root)
> Removing entries between 204800 and 409599.
> Adding entries between 409599 and 204800.
> insert (half reverse): time: 1484 cyc, 929 ns (1076184/s)
> Number of entries in hashtrie: 819200
> Number of children in hashtrie: 27345
> Maxdepth of hashtrie: 3 (0 == root)
>
> No diffrence at all which is a bit weird, I had to doublecheck the code
> to see that I really readded the entries in reverse order and I did.

That's really weird: same maxdepth and exactly the same number of
children!

> Then I tried it with the lower half of the conntrack entries, those
> lower in the tree and got this:
>
> Number of entries in hashtrie: 819200
> Number of children in hashtrie: 27273
> Maxdepth of hashtrie: 3 (0 == root)
> Removing entries between 0 and 204799.
> Adding entries between 204799 and 0.
> insert (half reverse): time: 1627 cyc, 1018 ns (981869/s)
> Number of entries in hashtrie: 819200
> Number of children in hashtrie: 29189
> Maxdepth of hashtrie: 3 (0 == root)
>
> Here wee see that the number of child-nodes has increased from 27273 to
> 29189, that's a 7.0% increase, but the max depth hasn't increased in
> this particular test. Given the right sitation the maxdepth will
> probably increase, it's likely to occur sometimes since the number of
> child-nodes has increased.

Half of the entries were removed then re-added and it produced 7% increase
in the number of the child nodes. That might be good or bad as well.

[...]
> More testing is clearly needed.

Yes, one is somehow uneasy. Hm. What about filling up the hashtrie and
then some long loop of deleting 10% at random and adding *new* random
entries? We could measure the change in maxdepth/childnodes after every
delete/add cycle. What were the peak numbers? At what numbers would it
stabilize?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
