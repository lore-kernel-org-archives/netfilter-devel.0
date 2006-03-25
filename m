From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Sat, 25 Mar 2006 09:39:26 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603250927490.31915@blackhole.kfki.hu>
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
	<Pine.LNX.4.58.0603231206090.28275@blackhole.kfki.hu>
	<1143148057.3840.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1143148057.3840.43.camel@localhost.localdomain>
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

On Thu, 23 Mar 2006, Martin Josefsson wrote:

[...]
> A lot of your changes should go into svn, you have full freedom to
> change whatever you want.

OK, I'll commit it sometime at the weekend. :-)

> I see that you have tested with HASHSHIFT 3, 4, 5, 6 and a 32byte
> cachelinesize.
> That gives:
>
> HASHSHIFT = 3
> 	HASHNUM (buckets per child) = 8
> 	childsize = HASHNUM * bucketsize (cachelinesize) = 256 bytes
[...]
> The original idea was to allocate PAGE_SIZE (4096 on i386) bytes at a
> time so it would be interesting to test HASHSHIFT = 7 (assuming a 32byte
> cachelinesize)

I just wanted to see the effect of different HASHSHIFT values. But I'll
add HASHSHIFT = 7, that's just some new lines.

> Another idea is to have varible number of buckets (HASHNUM) in the
> nodes, more buckets at the top of the trie and then decrease the number
> of buckets as we descend deeper into the trie. I've tried this earlier
> but with lowered performance, I don't remember anything about the change
> in memory-usage, and I don't trust my memory so it should be tested
> again.
>
> HASHSHIFT=8 or 9 or even larger at depth 0 would be interesting to test.

I'm going into that direction: probably even higher HASHSHIF value at
depth = 0 was fairer. The slow insert time compared to hashtable may come
from the preallocated large hash in hashtable.

> Yes, this matches the results I've seen as well. I've also run it under
> the cachegrind module of valgrind and among other things it keeps
> statistics on the number of instructions executed, and hashtrie executes
> a lot more instructions than the plain hashtable during lookup, yet
> hashtrie gets better performance in some cases due to the fact that it
> gets less cachemisses.

I'm thinking on an array-version, where instead of chaining of pointers,
basically an array of ip_conntrack_tuple is used in the hashtable to
avoid clashing. And IPv6 should be taken into account, too.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
