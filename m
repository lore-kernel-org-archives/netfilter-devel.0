From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] autotools conversion fixups
Date: Wed, 12 Nov 2014 13:01:43 +0100
Message-ID: <20141112120143.GA32549@salvia>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org>
 <1415564772-8873-1-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: giorgio.nicole@arcor.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaKLL7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:59:47 -0500
Content-Disposition: inline
In-Reply-To: <1415564772-8873-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 09, 2014 at 09:26:12PM +0100, giorgio.nicole@arcor.de wrote:
> From: root <root@lord_casco.spaceball>
> 
> Add some missing Makefile.am's under the include directory.
> 
> Now it is possible to build 'nftables' from a separate build directory
> and produce a release tar archive with a 'make distcheck'.

Thanks. I have merged this update to nftables/autotools branch:

git.netfilter.org/nftables/commit/?h=autotools&id=85035b6c6a1618e7ba726fe6306c804fc1b6c4e8

> diff --git a/autogen.sh b/autogen.sh
> index a62e737..4b6b92d 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,4 +1,11 @@
>  #!/bin/bash
>  
> -autoreconf -fi;
> +srcdir=`dirname $0`
> +test -z "$srcdir" && srcdir=.
> +
> +ORIGDIR=`pwd`
> +cd $srcdir
> +
> +autoreconf -vfi || exit 1
>  rm -Rf autom4te*.cache config.h.in~
> +cd $ORIGDIR || exit $?

The need for this chunk was not justified, I kept this back.
