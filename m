From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Wed, 12 Jun 2002 11:23:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206121115150.11580-100000@blackhole.kfki.hu>
References: <015d01c21055$82f7aed0$6501a8c0@multisofteducation.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Oskar Andreasson <blueflux@koffein.net>
In-Reply-To: <015d01c21055$82f7aed0$6501a8c0@multisofteducation.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 10 Jun 2002, Oskar Andreasson wrote:

> Sorry for the late reply. I never suggested that this usage (see
> below) is only theoretical and I'm very sorry if it was misinterpreted
> as that.

Oh, no! I wanted to *second* you in this argument.

Regards,
Jozsef

> ----- Original Message -----
>
> > On Fri, 7 Jun 2002, Oskar Andreasson wrote:
> >
> > > Another, related, usage is
> > > if we have a redundant firewall (I haven't seen this discussed so far
> > > so.... Consider this:
> > >
> > > 1 main firewall
> > > 1 router
> > > and a secondary firewall.
> > >
> > > The three are set up in a routing zone. If the main firewall goes
> > > down, the router will notice, and route packets through the redundant
> > > firewall. If the NEW target was to allow only SYN packets, this would
> > > be impossible as you can understand from this.
> >
> > We have been using such a redundant setup for more than a year.
> > It's *not* theoretical.
> >
> > Regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> > WWW-Home: http://www.kfki.hu/~kadlec
> > Address : KFKI Research Institute for Particle and Nuclear Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
> >
> >
>

-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
