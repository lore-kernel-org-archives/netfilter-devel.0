From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: add and use a symbol version map
Date: Wed, 19 Nov 2014 14:42:24 +0100
Message-ID: <20141119134224.GA12289@salvia>
References: <1415797607-28793-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47929 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaKSNkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:40:25 -0500
Content-Disposition: inline
In-Reply-To: <1415797607-28793-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 12, 2014 at 02:06:47PM +0100, Jan Engelhardt wrote:
> It was possible to combine e.g. conntrackd-1.2.1 with
> libnetfilter_conntrack-0.0.101, causing libc to issue an exit from
> within conntrackd iff such a conntrackd was promoted to a master and
> tried to call nfexp_send, due to lazy symbol resolution in libc.

I wonder how you have reached such a situation. I can only think of
very broken packaging.

> Symbol versions enforce the checks at program startup, so add one.
>
> $ ldd -r /usr/sbin/conntrackd
> undefined symbol: nfexp_cmp     (/usr/sbin/conntrackd)
> undefined symbol: nfexp_send    (/usr/sbin/conntrackd)
>         libnetfilter_conntrack.so.3 => /usr/lib/libnetfilter_conntrack.so.3 (0x77fe7000)
>         libnfnetlink.so.0 => /usr/lib/libnfnetlink.so.0 (0x77fdf000)
>         libc.so.6 => /lib/libc.so.6 (0x77e7b000)
>         libdl.so.2 => /lib/libdl.so.2 (0x77e76000)
>         /lib/ld.so.1 (0x55555000)
> $ dpkg-query -W conntrackd libnetfilter-conntrack3
> conntrackd      1:1.2.1-1
> libnetfilter-conntrack3 0.0.101-1

Would you also convert libnetfilter_conntrack to use the same
EXPORT_SYMBOL() macro that we use in more recent libnetfilter_*
libraries for consistency?
