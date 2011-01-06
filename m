From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] build: implement export symbols
Date: Thu, 06 Jan 2011 03:41:22 +0100
Message-ID: <4D252BD2.9010904@netfilter.org>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de> <1293752411-12923-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49653 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1AFClZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:41:25 -0500
In-Reply-To: <1293752411-12923-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:40, Jan Engelhardt wrote:
> This removed the rtnl symbols (7 pieces) that are not usable (there
> are no prototypes in libnfnetlink.h) from the .dynsym section of the
> library.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  .gitignore            |    1 +
>  Make_global.am        |    2 +-
>  configure.ac          |    2 +
>  m4/gcc4_visibility.m4 |   21 +++++++
>  src/iftable.c         |   23 ++++----
>  src/internal.h        |   12 ++++
>  src/libnfnetlink.c    |  159 ++++++++++++++++++++++++++++---------------------
>  7 files changed, 140 insertions(+), 80 deletions(-)
>  create mode 100644 m4/gcc4_visibility.m4
>  create mode 100644 src/internal.h

Making all in src
make[3]: se ingresa al directorio
`/home/pablo/devel/scm/git-netfilter/libnfnetlink/libnfnetlink-1.0.0/_build/src'
depbase=`echo libnfnetlink.lo | sed 's|[^/]*$|.deps/&|;s|\.lo$||'`;\
        /bin/sh ../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H
-I. -I../../src -I..  -I../../include  -Wall -fvisibility=hidden -g -O2
-MT libnfnetlink.lo -MD -MP -MF $depbase.Tpo -c -o libnfnetlink.lo
../../src/libnfnetlink.c &&\
        mv -f $depbase.Tpo $depbase.Plo
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../../src -I..
-I../../include -Wall -fvisibility=hidden -g -O2 -MT libnfnetlink.lo -MD
-MP -MF .deps/libnfnetlink.Tpo -c ../../src/libnfnetlink.c  -fPIC -DPIC
-o .libs/libnfnetlink.o
../../src/libnfnetlink.c:53:22: error: internal.h: No existe el fichero
o el directorio

Please, run `make distcheck' to check that everything's fine. We have to
add internal.h to noinst_HEADERS in src/Makefile.am

Could you fix this in your tree so can I pull from it with this problem
resolved?
