From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] pom-ng new release
Date: Tue, 4 May 2004 22:40:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405042238020.28629-100000@blackhole.kfki.hu>
References: <4097F545.9030207@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <4097F545.9030207@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 May 2004, Martijn Lievaart wrote:

> Jozsef Kadlecsik wrote:
>
> >      [Could any Perl guru explain in plain English while the code
> >
> >      for my $dep (@{$$patchlet{info}{depends}}) {
> >		$dep =~ s/^!//;
> >      }
> >
> >      modifies the content of array $patchlet{info}{depends} too??]
>
> Basic Perl actually, no guru knowledge needed. A for loop aliases the
> loop variable to the array element. Do a 'perldoc perlsyn' and look up
> foreach. As Patrick already noted, make a copy if you don't want this. I
> would use:

Ahh, yes, you are absolutely right! Thank you the explanation.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
