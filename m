From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Fri, 11 Oct 2002 15:06:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
References: <1034286048.25146.40.camel@tux>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1034286048.25146.40.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On 10 Oct 2002, Martin Josefsson wrote:

> What's the lockingrules for ip_conntrack_expect_list?

As far as I remember, the guiding rules were the following:
ip_conntrack_lock is always held when we do something with the
expectations. If it's write-locked, then there is no need for additional
locking. If it's read-locked, then we use the additional
ip_conntrack_expect_tuple_lock to protect the expectation lists.

> I've gone through 2.4.20-pre8aa2 which was the kernel the bugreport was
> from. And I've found some inconsistencies.

> init_conntrack
> 	first:
> 		WRITE_LOCK(&ip_conntrack_lock);
> 		READ_LOCK(&ip_conntrack_expect_tuple_lock);
> 		LIST_FIND

Read-locking ip_conntrack_expect_tuple_lock is unnecessary here then.

> 	later:
> 		WRITE_LOCK(&ip_conntrack_lock);
> 		LIST_DELETE
>
> ip_conntrack_expect_related
> 	WRITE_LOCK(&ip_conntrack_lock);
> 	LIST_FIND
> 	LIST_FIND
> 	list_prepend
>
> ip_conntrack_change_expect
> 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> 	LIST_FIND
>
> 	FAILS!! called from nat-helpers which only hold their own locks 	if any
> at all.

Well spotted! It's a locking bug then.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
