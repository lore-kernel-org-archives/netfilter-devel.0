From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] iptables 1.4.15 release
Date: Fri, 3 Aug 2012 10:46:34 +0200
Message-ID: <20120803084634.GA9363@1984>
References: <20120731112531.GA3493@1984>
 <201208030820.40088.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49337 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2HCIqi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:46:38 -0400
Content-Disposition: inline
In-Reply-To: <201208030820.40088.arekm@maven.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 03, 2012 at 08:20:39AM +0200, Arkadiusz Mi=C5=9Bkiewicz wro=
te:
> On Tuesday 31 of July 2012, Pablo Neira Ayuso wrote:
> > Hi!
> >=20
> > The Netfilter project proudly presents:
> >=20
> >         iptables 1.4.15
> >=20
> > This release includes support for new features now present in the
> > Linux kernel 3.5 and one major bugfix (that shows up with gcc-4.7).
>=20
> Hm but 3.5 doesn't contain ip_queue.h anymore:
>=20
> In file included from libipq.c:34:0:
> ../include/libipq/libipq.h:33:43: fatal error:=20
> linux/netfilter_ipv4/ip_queue.h: No such file or directory

That doesn't necessarily means we have to remove libipq from the tree.

You can still use new iptables version with old Linux kernels.

I've fixed this:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Diptables.git;a=3Dcommit=
;h=3Dad8858c0d3ef875e2c118ebcc69487070fb87f72
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
