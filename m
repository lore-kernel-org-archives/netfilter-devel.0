From: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Subject: Re: Set compile problem with kernel 2.6.23.1
Date: Sun, 21 Oct 2007 21:44:48 +0200
Message-ID: <1192995888.6054.1.camel@steven.kity.pl>
References: <1192979789.4860.0.camel@steven.kity.pl>
	 <Pine.LNX.4.64.0710212043040.477@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:35834 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJUTov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:44:51 -0400
In-Reply-To: <Pine.LNX.4.64.0710212043040.477@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Dnia 21-10-2007, nie o godzinie 20:44 +0200, Jozsef Kadlecsik
napisa=C5=82(a):
> Hi,
>=20
> On Sun, 21 Oct 2007, Krzysztof Mo=C5=9Bcicki wrote:
>=20
> > While trying to compile vanilla kernel 2.6.23.1 with
> > patch-o-matic-ng-20070828 or patch-o-matic-ng-20071020 (using exten=
sion
> > set) I'm getting following error:
> >=20
> >   CC [M]  net/ipv4/netfilter/ipt_SET.o
> >   CC [M]  net/ipv4/netfilter/ip_set.o
> > net/ipv4/netfilter/ip_set.c:1931: error: unknown field `use' specif=
ied
> > in initializer
>=20
> I have updated ipset in svn and added a new snapshot to=20
> ipset.netfilter.org, please use that: a compatibility fix was require=
d for=20
> 2.6.23 and upward.

Thx, it works


--=20
Krzysztof Mo=C5=9Bcicki

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
