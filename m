From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Thu, 26 Aug 2004 11:23:45 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408261103190.17019@blackhole.kfki.hu>
References: <20040818223233.GA317@cerbere.dyndns.info>
	<20040819094720.GZ3921@sunbeam.de.gnumonks.org>
	<4127E920.2080100@trash.net>
	<Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
	<20040824104945.GR26877@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
	<Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
	<Pine.LNX.4.61.0408241647300.9087@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408241647300.9087@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Henrik Nordstrom wrote:

> On Tue, 24 Aug 2004, Jozsef Kadlecsik wrote:
>
> > Using the directory scheme and logic above, how you could express that
> > foo.c is required up to 2.6.8 but not above?
>
> Place it in linux-2.6.1 (or from whatever version is required), and create
> a linux-2.6.9 directory not having this file.
>
> If there is other releases between 2.6.1 and 2.6.9 for the file into each
> release.

The assumption is that the file is required for all releases up to 2.6.8.

We can't put the file into linux/, because then it'd be added to 2.6.9.
We can't put the file into linux-2.4/ and linux-2.6/ either, from the same
reason.

If we put the file into each linux-x.y.z directory up to 2.6.8, we are
copying the same file between directories in spite of the efforts of
avoiding that.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
