From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 15:10:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
References: <20040818223233.GA317@cerbere.dyndns.info>
 <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net>
 <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
 <20040824104945.GR26877@sunbeam.de.gnumonks.org>
 <Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Henrik Nordstrom wrote:

> On Tue, 24 Aug 2004, Harald Welte wrote:
>
> > Mh, do you still remember the precise reason for this? I would like to
> > have this resolved in a cleaner way than copying everything over and
> > over...
>
> I don't remember, and also do not see any reason why there can not be a
> shared directory or even hierarchy.
>
> My suggestion
>
> linux		version independent files
> linux-2.4	linux-2.4 specific
> linux-2.6	linux-2.6 specific
> linux-2.6.8	linux-2.6.8 or later specific
>
> where if you are on linux-2.6.9 the files are the sum of linux, linux-2.4
> and linux-2.6.8, where the same file in a more specific version overrides
> the less specific version.
>
> This should not be very complex to accomplish, and is open to several
> different ways of maintaining the versions depending on the authors
> preference.

> > As far as I remember the main problem was how to express when a file
> > was *not* required in specific versions or above a given version.

> I propose that in such case the file need to be forked into the
> respective version trees where it should be used.

Using the directory scheme and logic above, how you could express that
foo.c is required up to 2.6.8 but not above?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
