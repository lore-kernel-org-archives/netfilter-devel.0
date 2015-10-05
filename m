From: Guillaume Nault <g.nault@alphalink.fr>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 5 Oct 2015 18:33:42 +0200
Message-ID: <20151005163342.GA2882@alphalink.fr>
References: <cover.1443815157.git.g.nault@alphalink.fr>
 <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
 <20151005153715.GA22955@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:33939 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752903AbbJEQdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 12:33:45 -0400
Content-Disposition: inline
In-Reply-To: <20151005153715.GA22955@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 05, 2015 at 05:37:15PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 02, 2015 at 10:12:33PM +0200, Guillaume Nault wrote:
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
> 
> Looks good, but we should be using 'unsigned int flags' instead, right?
> 
> Or am I missing anything?

Generally speaking, I'd also consider unsigned integers to be more
appropriate for flag parameters.

But all socket() parameters are signed integers, including "type" which
is bitwise OR-ed with "flags". Furthermore, others libc's functions
introduced for the same purpose (race-free setting of CLOEXEC flag),
also use a signed integer as flag parameter (like dup3()).

So I've used int for consistency. But I can repost if you prefer.
