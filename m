From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 10:58:21 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040214212340.GC7756@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 14 Feb 2004, Harald Welte wrote:

> > The IP sets support is available from the netfilter cvs repository!
>
> Thanks a lot, I will take some time to review the code.
>
> One of the first issues that I ran into was the use of vmalloc.
> Please refer to http://lwn.net/Articles/57800/.

Thank you pointing out the article! Let's consider the current version of
ipset as the first, beta release (as it is :-). Actually, Linus'
description when vmalloc is valid fits to the vmalloc usage in ipset
(large arrays allocated), but I'll work on to eliminate it.

> Since ipset is sufficiently independent (in fact, totally independent)
> of iptables, we could make it a seperate package, and thus a seperate
> cvs module.  What do you think?

OK!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
