From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/3] flex_array: export some symbols for
 nfnetlink_queue use
Date: Fri, 09 Apr 2010 07:02:12 +0200
Message-ID: <1270789332.2458.23.camel@edumazet-laptop>
References: <4BBEA87B.4040807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47169 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0DIFCS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:02:18 -0400
In-Reply-To: <4BBEA87B.4040807@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 09 avril 2010 =C3=A0 12:09 +0800, Changli Gao a =C3=A9crit =
:
> export some symbols for nfnetlink_queue use
>=20
> export some symbols for nfnetlink_queue use.
>=20
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
> lib/Makefile | 4 ++--
> lib/flex_array.c | 5 +++++
> 2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/Makefile b/lib/Makefile
> index 0a6ab6f..0700e74 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o flex_array.o
> +	 is_single_threaded.o plist.o decompress.o
> =20

Hmm, could you instead add a lib-$(CONFIG_FLEX_ARRAY) +=3D flex_array.o
instead ?

And do the necessary Kconfig changes as well.

You should CC people who where involved with flex_array :

scripts/get_maintainer.pl -f lib/flex_array.c

Andrew Morton <akpm@linux-foundation.org>
David Rientjes <rientjes@google.com>
Dave Hansen <dave@linux.vnet.ibm.com>
Jonathan Corbet <corbet@lwn.net>
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
