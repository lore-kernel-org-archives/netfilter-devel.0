From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: tcp-window-tracking for 2.6? (Re: [PATCH] patch-o-matic-ng reorganization and updated patches)
Date: Fri, 20 Feb 2004 22:23:14 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <029801c3f7a3$ee1920e0$2601010a@bluereef.local>
References: <Pine.LNX.4.33.0402201000370.16037-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	"Nuutti Kotivuori" <naked@iki.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef,

There seems to be a dependancy on nf_log for the tcp-windowing patch? Using
the latest CVS patch-o-matic and 2.6, the nf_log patch seems to fail ( says
it's missing one needed file). Is this intentional or should we expect the
2.6 nf_log+tcp-windowing patches to install cleanly now?

Thanks,
Andrew.
----- Original Message -----
From: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
To: "Nuutti Kotivuori" <naked@iki.fi>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Friday, February 20, 2004 8:12 PM
Subject: Re: tcp-window-tracking for 2.6? (Re: [PATCH] patch-o-matic-ng
reorganization and updated patches)


> On Thu, 19 Feb 2004, Nuutti Kotivuori wrote:
>
> > > - 2.6 ports of tcp-window-tracking and conntrack_foo patches
> >
> > I am personally very interested in the state of the
> > tcp-window-tracking patch, especially for 2.6 kernels. It is very nice
> > to know it is being ported for 2.6.
> >
> > What I would be doing would either be a patch that depends on the
> > tcp-window-tracking patch to work at all - or it would do something
> > similar itself which would most probably make it conflict with the
> > tcp-window-tracking patch.
> >
> > Does anyone know of the status it? How far is it from being integrated
> > into the mainline netfilter? Are there any blocking issues why it
> > cannot be or will not be integrated?
>
> Weren't it be ported to 2.6, couldn't it been submitted into
> inclusion :-).
>
> Thanks to Willy Tarreau's suggestions, patches and heavy testings, the
> patch matured a lot. I'd say there is nothing against submitting it into
> the kernel in the near future.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>
>
