From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Fri, 11 Oct 2002 16:07:39 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210111559050.29766-100000@blackhole.kfki.hu>
References: <1034344573.25146.55.camel@tux>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1034344573.25146.55.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 11 Oct 2002, Martin Josefsson wrote:

> But is it really neccessary to hold ip_conntrack_lock when we are only
> going to change an expectation and not touch anything else?
> If we enforce that we always hold a readlock or writelock on
> ip_conntrack_expect_tuple_lock when we touch it we should be safe?

We wanted to avoid possible cross-locking bugs by keeping a strict
hierarchy of the locks. Sometimes too complicated functions are called
while a lock is held.

> I think Rusty has changed the lockingrules in his conntrack-optimization
> patch to only require that we hold the ip_conntrack_expect_tuple_lock.

The other way around: he removed ip_conntrack_expect_tuple_lock
completely. I think that is the proper way, but it implies that later
the fine-grained locking is introduced in order to remove the dependency
of everything on the single ip_conntrack_lock.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
