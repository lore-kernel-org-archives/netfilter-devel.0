From: Patrick McHardy <kaber@trash.net>
Subject: Re: Compil error Linux 2.6.22.9
Date: Tue, 02 Oct 2007 16:36:08 +0200
Message-ID: <47025758.2030800@trash.net>
References: <ddee6b1d0710020724p7f63332exf0f5dd8f3150e99d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: GNULinuxSlackware <gnulinuxslackware@free.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXJBOgL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:36:11 -0400
In-Reply-To: <ddee6b1d0710020724p7f63332exf0f5dd8f3150e99d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

GNULinuxSlackware wrote:
> Hello, I have a problem when I compil my Linux kernel 2.6.22.9.
> I do :
> $ make allyesconfig
> $ make
> Then, after a while, I have this error :
> ---
> [...]
>   CC      net/ipv4/netfilter/ipt_REJECT.o
> make[3]: *** Pas de r=E8gle pour fabriquer la cible =AB
> net/ipv4/netfilter/ipt_TOS.o =BB, n=E9cessaire pour =AB net/ipv4/netf=
ilter/built-
> in.o =BB. Arr=EAt.
> make[2]: *** [net/ipv4/netfilter] Erreur 2
> make[1]: *** [net/ipv4] Erreur 2
> make: *** [net] Erreur 2
> ---
> How to resolve this problem?


As a start, send to the proper list (and this does *not* include
coreteam@) and don't post error messages in french.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
