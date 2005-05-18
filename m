From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 18 May 2005 08:45:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505180842420.9582@blackhole.kfki.hu>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net> <4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net> <427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net> <427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <428A1807.8070708@ufomechanic.net>
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

> KOVACS Krisztian wrote:
> >   Probably Patrick was referring to a possible problem where the
> > following happens: a new connection is established and destroyed in a
> > very short time. If a new connection with the same tuple is created
> > before the timestamp increases (which is perfectly possible IMHO if you
> > have some slow embedded HW with no high precision timer available)
>
> After further reading I think this scenario is highly unlikely.
>
> I don't mean improbable, I mean, is there any such hardware?
> If a socket is not to be reused until TCP_TIME_WAIT which is recommended
> to be in the region of 4 minutes, is there really any hardware that
> can't time to that resolution? Is there really any devices that will
> re-use a TCP socket in the same timer tick as they closed it?

We have to deal with other protocols as well, not just TCP. For example
using UDP one could fairly easily trigger the described situation.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
