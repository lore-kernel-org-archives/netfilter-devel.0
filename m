From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 5 Oct 2015 20:38:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1510052037440.13515@blackhole.kfki.hu>
References: <cover.1443815157.git.g.nault@alphalink.fr> <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr> <alpine.DEB.2.10.1510051925090.13013@blackhole.kfki.hu> <20151005181147.GA23848@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Guillaume Nault <g.nault@alphalink.fr>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44182 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJEShO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 14:37:14 -0400
In-Reply-To: <20151005181147.GA23848@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 5 Oct 2015, Pablo Neira Ayuso wrote:

> On Mon, Oct 05, 2015 at 07:27:46PM +0200, Jozsef Kadlecsik wrote:
> > Hi,
> > 
> > On Fri, 2 Oct 2015, Guillaume Nault wrote:
> > 
> > > Define mnl_socket_open2() so that user can pass a set of SOCK_* flags
> > > at socket creation time.
> > > 
> > > Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
> > > ---
> > >  include/libmnl/libmnl.h |  3 ++-
> > >  src/libmnl.map          |  1 +
> > >  src/socket.c            | 41 ++++++++++++++++++++++++++++++++---------
> > >  3 files changed, 35 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> > > index 3a589bc..5adb13c 100644
> > > --- a/include/libmnl/libmnl.h
> > > +++ b/include/libmnl/libmnl.h
> > > @@ -21,7 +21,8 @@ extern "C" {
> > >  
> > >  struct mnl_socket;
> > >  
> > > -extern struct mnl_socket *mnl_socket_open(int type);
> > > +extern struct mnl_socket *mnl_socket_open(int bus);
> > > +extern struct mnl_socket *mnl_socket_open2(int bus, int flags);
> > >  extern struct mnl_socket *mnl_socket_fdopen(int fd);
> > >  extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
> > >  extern int mnl_socket_close(struct mnl_socket *nl);
> > > diff --git a/src/libmnl.map b/src/libmnl.map
> > > index 3c147a7..e5920e5 100644
> > > --- a/src/libmnl.map
> > > +++ b/src/libmnl.map
> > > @@ -74,5 +74,6 @@ LIBMNL_1.1 {
> > >  } LIBMNL_1.0;
> > >  
> > >  LIBMNL_1.2 {
> > > +  mnl_socket_open2;
> > >    mnl_socket_fdopen;
> > >  } LIBMNL_1.1;
> > 
> > I think this breaks library ABI: you should introduce a new revision 
> > instead.
> 
> This would be part of the new interfaces for the next release:

That's right then, sorry for the noise :-)

Best regards,
Jozsef

> diff --git a/src/libmnl.map b/src/libmnl.map
> index dbc332e..e5920e5 100644
> --- a/src/libmnl.map
> +++ b/src/libmnl.map
> @@ -72,3 +72,8 @@ local: *;
>  LIBMNL_1.1 {
>    mnl_attr_parse_payload;
>  } LIBMNL_1.0;
> +
> +LIBMNL_1.2 {
> +  mnl_socket_open2;
> +  mnl_socket_fdopen;
> +} LIBMNL_1.1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
