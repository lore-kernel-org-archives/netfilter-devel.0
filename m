From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [patch] iptables -L --rules to print command line version of
	rules
Date: Mon, 12 May 2008 12:21:41 +0200
Message-ID: <1210587701.11742.41.camel@henriknordstrom.net>
References: <1210548143.23433.41.camel@henriknordstrom.net>
	 <alpine.LNX.1.10.0805121030040.25441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:49855 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbYELKVp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 06:21:45 -0400
In-Reply-To: <alpine.LNX.1.10.0805121030040.25441@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On m=C3=A5n, 2008-05-12 at 10:37 +0200, Jan Engelhardt wrote:

>   CC       ip6tables.o
> ../ip6tables.c: In function =E2=80=98do_command6=E2=80=99:
> ../ip6tables.c:1730: error: =E2=80=98struct ip6t_entry=E2=80=99 has n=
o member named =E2=80=98ip=E2=80=99

Sorry about that. Should be ipv6.

> Other than that, I do not see a real difference the patch
> makes over iptables-save.

The difference is that iptables can dump a single chain, while
iptables-save only a whole table.

The other difference is that this gives "save" like capability to
iptables-restore when used in a pipe, makging iptables-restore a more
complete batch interface for talking to iptables which was the main
motivation behind this.

But you have a point in that chains and policies should be included in
the output, just as they are in the human readable output.

Additionally the count output format should probably be using -c when
invoked by the iptables command..

Regards
Henrik


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
