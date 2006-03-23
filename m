From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Thu, 23 Mar 2006 12:27:21 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603231206090.28275@blackhole.kfki.hu>
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
	<1141503111.3881.61.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
	<1141580938.3881.129.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
	<1141756438.3881.158.camel@localhost.localdomain>
	<1142189345.3881.181.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1142189345.3881.181.camel@localhost.localdomain>
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

On Sun, 12 Mar 2006, Martin Josefsson wrote:

[...]
> I've also tried making the buckets larger and decreasing HASHSHIFT in
> order to not exceed 4kB allocations, this allows the buckets to absorb
> the imperfectness of the hashing and memory usage goes down a _lot_.
> But... this is will simply destroy performance on machines with small
> cachelines as it will lead to lots of cachemisses per bucket.
>
> Any ideas?

I took your code and messed with it: added input parameters
(hashsize/number of elements), HASHNUM-dependent variants of hashtrie,
added Paul Hsiesh's superfasthash function and an implementation of the
shared-node fast hash from a SIGCOMM article. Then ran the different
methods with increasing number of elements (table is half, full, two and
four times more entry than hashsize) and created some graphs by gnuplot.

The results are at http://people.netfilter.org/kadlec/hashtrie/

What I could conclude is that hashtable requires the least memory and the
fastest at inserting elements. Hashtrie is better in looking up entries
when there are more than two times entries in the hash than the hashsize
of the hashtable.

Something is required to improve hashtrie, so that it'd require less
memory. Without losing speed, but possibly gaining, at insertion.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
