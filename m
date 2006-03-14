From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Tue, 14 Mar 2006 12:35:31 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603141155320.11147@blackhole.kfki.hu>
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

> I've added some very simple debug-code and here's what I've found so far
> when testing with random src/dst ip/port.
[...]
> Summary:
> 121904 buckets that are 148% used.
> 40542 buckets that are 100% used.
> 99698 buckets that are 62% used.
>
> So the jenkins hash doesn't seem to be able to distribute the entries
> very well.

I wrote first such words out of frustation, but actually I think the
jenkins hash is fine. It was selected after a lot of testing, checking,
comparison. There might of course be flaws in it, but

> This leads to the allocation of 121904 children for just 291689 entries,
> that's a huge waste of memory. But even if we are able to come up with a
> better hash algorithm for this we'll still have this problem when we
> start expanding deeper, the size of the tree simply explodes.

we may simply see the consequences of the inherent behaviour of hashtree
*and* the goodness of the jenkins hash: as part of the hash keys clash
(they do because HASHSHIFT is relatively small) and as the tree grows,
there will be too many empty branches (the whole hash key is pretty
unique, there are to *few* near-clashes at the higher levels). But that's
an assumption only.

> One idea I've played with earlier is to change the number of buckets per
> child depending on the depth, so we have larger children at the top of
> the tree and then they get smaller further down. I'll have to revive
> that code (should be somewhere in svn) in order to say if it helped the
> memory usage or not, I know it made things a bit slower.

Usually we trade speed for memory. Double hashing does not help really
either, because it slows down the lookups too :-( - I learnt it at ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
