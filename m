From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipt_ROUTE fix for 2.6 kernels [was: IPROUTE compilation
 problem]
Date: Fri, 14 May 2004 15:43:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405141543110.21804-100000@blackhole.kfki.hu>
References: <1084520305.1841.16.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
In-Reply-To: <1084520305.1841.16.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 May 2004, Cedric de Launois wrote:

> Le jeu 13/05/2004 =E0 23:28, Daniel 'NebuchadnezzaR' Dehennin a =E9crit :
> > The IPROUTE patch failed to build (latest CVS + 2.6.6):
>
> Yes, I know. The ROUTE target is not yet converted to kernel 2.6 series.
> Here is a patch that updates it.
> Changes include :
>  - conversion from struct rt_key to struct flowi
>  - checksum fix from Rickard Molin
>
> Please apply ;)

Patch is applied, thank you Cedric.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
