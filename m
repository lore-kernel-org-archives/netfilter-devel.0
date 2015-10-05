From: Guillaume Nault <g.nault@alphalink.fr>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 5 Oct 2015 20:14:29 +0200
Message-ID: <20151005181429.GB2882@alphalink.fr>
References: <cover.1443815157.git.g.nault@alphalink.fr>
 <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
 <alpine.DEB.2.10.1510051925090.13013@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:37569 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752084AbbJESOc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 14:14:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1510051925090.13013@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 07:27:46PM +0200, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Fri, 2 Oct 2015, Guillaume Nault wrote:
> 
> > Define mnl_socket_open2() so that user can pass a set of SOCK_* flags
> > at socket creation time.
> > 
> > Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
> > ---
> >  include/libmnl/libmnl.h |  3 ++-
> >  src/libmnl.map          |  1 +
> >  src/socket.c            | 41 ++++++++++++++++++++++++++++++++---------
> >  3 files changed, 35 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> > index 3a589bc..5adb13c 100644
> > --- a/include/libmnl/libmnl.h
> > +++ b/include/libmnl/libmnl.h
> > @@ -21,7 +21,8 @@ extern "C" {
> >  
> >  struct mnl_socket;
> >  
> > -extern struct mnl_socket *mnl_socket_open(int type);
> > +extern struct mnl_socket *mnl_socket_open(int bus);
> > +extern struct mnl_socket *mnl_socket_open2(int bus, int flags);
> >  extern struct mnl_socket *mnl_socket_fdopen(int fd);
> >  extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
> >  extern int mnl_socket_close(struct mnl_socket *nl);
> > diff --git a/src/libmnl.map b/src/libmnl.map
> > index 3c147a7..e5920e5 100644
> > --- a/src/libmnl.map
> > +++ b/src/libmnl.map
> > @@ -74,5 +74,6 @@ LIBMNL_1.1 {
> >  } LIBMNL_1.0;
> >  
> >  LIBMNL_1.2 {
> > +  mnl_socket_open2;
> >    mnl_socket_fdopen;
> >  } LIBMNL_1.1;
> 
> I think this breaks library ABI: you should introduce a new revision 
> instead.
> 
AFAIK, this revision hasn't been part of any official release yet.
That's why I've exported mnl_socket_open2() there. I don't mind
incrementing the ABI version, but should we really do that for every
commit exporting a new function between two releases?
