From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] iptables cannot be compiled with 2.6.7
Date: Wed, 23 Jun 2004 14:45:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406231440410.5967-100000@blackhole.kfki.hu>
References: <08dc01c458c9$38c19ce0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	<netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
In-Reply-To: <08dc01c458c9$38c19ce0$2601010a@bluereef.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 23 Jun 2004, Andrew Hall wrote:

> This patch was already there.

I sent my mail just after I committed the patch in cvs. However my mail
was delayed by 4 days on the mailing list server.

> It is the 07_linux patch that seems to be missing..

Yes. There are problems in creating a proper 07_linux patch. It seems
either we add a really huge patch to the cvs or we have to spend a lot of
time to shrink it, without breaking the kernel.

Pleas do not top-post.

Best regards,
Jozsef

> ----- Original Message -----
> From: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
> To: <netfilter-devel@lists.netfilter.org>; <netfilter@lists.netfilter.org>
> Sent: Saturday, June 19, 2004 5:44 AM
> Subject: [PATCH] iptables cannot be compiled with 2.6.7
>
> > Hello,
> >
> > The 08_linux-2.6.7-user_attr.patch has been added to patch-o-matic-ng,
> > which fixes the compile-problem of iptables using 2.6.7 source tree.
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : KFKI Research Institute for Particle and Nuclear Physics
> >           H-1525 Budapest 114, POB. 49, Hungary

-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
