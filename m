From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Conntrack proc interface for tuple removal
Date: Wed, 18 May 2005 08:51:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505180847060.9582@blackhole.kfki.hu>
References: <11148.217.169.232.210.1115923639.squirrel@hupie.xs4all.nl>
	<4284378B.8080401@eurodev.net> <428A151E.9090107@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <428A151E.9090107@ufomechanic.net>
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

On Tue, 17 May 2005, Amin Azez wrote:

> Pablo Neira wrote:
> > - READ_LOCK'ing while trying to delete a conntrack is racy, you must use
> > write_lock instead. Someone else could be reading the conntrack table
> > while you try to delete a conntrack.
> > - check the value returned by del_timer, currently racy as well.
> > - Deadlock on SMP: calling conntrack->timeout.function
> > (death_by_timeout) is illegal if you've got ip_conntrack_lock.
>
> Where should one read to learn about the rules and intricacies of such
> locking dependancies.

Rusty's 'Unreliable Guide To Locking' is an excellent paper on the locking
issues in the Linux kernel.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
