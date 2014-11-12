From: giorgio.nicole@arcor.de
Subject: Aw: Re: [PATCH 1/1] autotools conversion fixups
Date: Wed, 12 Nov 2014 17:36:59 +0100 (CET)
Message-ID: <414025497.559015.1415810219751.JavaMail.ngmail@webmail12.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:33996 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbaKLQhB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:37:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 


----- Original Nachricht ----
Von:     Pablo Neira Ayuso <pablo@netfilter.org>
An:      giorgio.nicole@arcor.de
Datum:   12.11.2014 13:01
Betreff: Re: [PATCH 1/1] autotools conversion fixups

> On Sun, Nov 09, 2014 at 09:26:12PM +0100, giorgio.nicole@arcor.de wrote:
> > From: root <root@lord_casco.spaceball>
> > 
> > Add some missing Makefile.am's under the include directory.
> > 
> > Now it is possible to build 'nftables' from a separate build directory
> > and produce a release tar archive with a 'make distcheck'.
> 
> Thanks. I have merged this update to nftables/autotools branch:
> 
> git.netfilter.org/nftables/commit/?h=autotools&id=85035b6c6a1618e7ba726fe630
> 6c804fc1b6c4e8
> 
> > diff --git a/autogen.sh b/autogen.sh
> > index a62e737..4b6b92d 100755
> > --- a/autogen.sh
> > +++ b/autogen.sh
> > @@ -1,4 +1,11 @@
> >  #!/bin/bash
> >  
> > -autoreconf -fi;
> > +srcdir=`dirname $0`
> > +test -z "$srcdir" && srcdir=.
> > +
> > +ORIGDIR=`pwd`
> > +cd $srcdir
> > +
> > +autoreconf -vfi || exit 1
> >  rm -Rf autom4te*.cache config.h.in~
> > +cd $ORIGDIR || exit $?
> 
> The need for this chunk was not justified, I kept this back.
> 
Hi,

the use of this slightly more complex 'autogen.sh' is to be able to call it even
from a different directory, typically an empty build directory, as in the following
shell session:

# git clone /sources/git/nftables.git -b autotools /tmp/nftables
# mkdir /tmp/build
# cd /tmp/build
# /tmp/nftables/autogen.sh
# /tmp/nftables/configure --prefix=/tmp/nft_inst
# make -j
...

The implementation of the script was taken from the 'libX11.git'
(see the repo. git://anongit.freedesktop.org/xorg/lib/libX11.git).

giorgio
