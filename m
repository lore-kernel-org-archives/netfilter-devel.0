From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 16 Feb 2006 10:36:47 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F4426D.9060807@trash.net>
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

On Thu, 16 Feb 2006, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Thu, 16 Feb 2006, Patrick McHardy wrote:
> >
> >>Jozsef Kadlecsik wrote:
> >>
> >>>Couldn't the id be simply equal to the jiffies when creating the conntrack
> >>>entry? (And adding time_after/before when comparing ids, of course.)
> >>
> >>We can create more than one entry per jiffy, so that wouldn't be unique
> >>anymore.
> >
> > (jiffies, tuples) would be unique even in that case.
>
> Thats true. But what is the advantage over using the counter?

Currently nothing :-).

However, the counter poses an internal bottleneck in the overall system
when one attempts to replace the hashtable by hashtrie. (What I really
like about hashtrie is that it naturally implements the 'region locking'
suggested by Patrick Schaaf, compared to the 'brute force' per bucket
locking.)

As I see, we have got three bottlenecks in conntrack in SMP systems:
the hashtable approach, the id and the expectation list. The first two
could be eliminated by hashtrie and jiffies as ids.

Some clever solution should only be found to spread the expectations
over multiple, separatedly locked buckets...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
