From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] fine grain locking for tcp helper
Date: Mon, 3 May 2004 16:49:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405031632300.24224-100000@blackhole.kfki.hu>
References: <40964F69.1040508@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40964F69.1040508@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, 3 May 2004, Pablo Neira wrote:

> Actually I was having a look at conntrack_locking for per bucket locking
> some days ago, I find it interesting. I had in mind to port them to 2.6
> but Patrick was faster :-).

:-)

> BTW, is there any problem in using both patches at the same time? If we
> have a machine with mostly tcp traffic, when we take a conntrack, two
> buckets will be locked (for original and reply tuples), but when calling
> tcp specific functions, it will spin until tcp_lock is released possibly
> by other conntrack.

I see, your're right. Actually, it seems I was blind, sorry. Both patches
could be used and your patch could give more speed.

> >Could you check and revive the patches
> >
> >conntrack_arefcount	- revised reference counting
>
> Is conntrack_locking dependent of this patch? in pom-ng is marked as
> dependent, but I don't understand why.

It's a must. Without the revised refcounting and well-separated
ip_conntrack_lock and ip_conntrack_expect_lock, per bucket locking cannot
simply be introduced. The locking patch cannot be applied without it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
