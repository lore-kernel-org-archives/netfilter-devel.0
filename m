From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipt_ROUTE build fix
Date: Thu, 10 Jun 2004 10:36:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406101036280.1962-100000@blackhole.kfki.hu>
References: <1086855832.570.2.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1086855832.570.2.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 10 Jun 2004, Cedric de Launois wrote:

> Le dim 30/05/2004 a 02:04, Willy Tarreau a ecrit :
> > Hi all,
> >
> > I had to include the following patch to build ipt_ROUTE as a module
> > under 2.4.27-pre3 (ip_fast_csum not found). I believe it broke not too
> > long ago but was lazy enough to check when since the patch is 1-line.
> > Patch against pom-ng-040528.
>
> Ok. Thanks. The rediff-ed patch is attached.
>
> Jozsef ? please apply,

Patch is applied, thank you.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
