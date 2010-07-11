From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv2] extensions: libxt_CHECKSUM extension
Date: Sun, 11 Jul 2010 22:59:24 +0300
Message-ID: <20100711195924.GC12202@redhat.com>
References: <20100711151453.GA7563@redhat.com>
 <alpine.LSU.2.01.1007111755250.22644@obet.zrqbmnf.qr>
 <20100711190630.GA11358@redhat.com>
 <alpine.LSU.2.01.1007112157300.10108@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0GKUEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:04:39 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1007112157300.10108@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 11, 2010 at 09:57:51PM +0200, Jan Engelhardt wrote:
> 
> On Sunday 2010-07-11 21:06, Michael S. Tsirkin wrote:
> >> >
> >> >The problem happens in the field with virtualized applications. For 
> >> >reference, see Red Hat bz 605555, as well as 
> >> >http://www.spinics.net/lists/kvm/msg37660.html
> >> 
> >> Added to Xtables-addons.
> >
> >Looks like .man file is missing. Intentional?
> >It's there in v3 of the patch.
> 
> 21:57 yaguchi:../addons/extensions > l *CHEC*
> -rw-r--r-- 1 jengelh users 2358 Jul 11 21:29 libxt_CHECKSUM.c
> -rw-r--r-- 1 jengelh users  409 Jul 11 21:29 libxt_CHECKSUM.man
> -rw-r--r-- 1 jengelh users 1862 Jul 11 21:29 xt_CHECKSUM.c
> -rw-r--r-- 1 jengelh users  481 Jul 11 21:29 xt_CHECKSUM.h

See it now. Sorry about the noise.
