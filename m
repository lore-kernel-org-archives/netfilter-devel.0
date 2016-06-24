From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: netfilter: spanning tree: Add
 masked_ether_addr_equal and neatening
Date: Fri, 24 Jun 2016 10:57:52 +0200
Message-ID: <20160624085752.GB1939@salvia>
References: <f39576f17e9f5dee35258917917f2d740e820a77.1466024030.git.joe@perches.com>
 <20160623173659.GA3474@salvia>
 <1466708400.1847.15.camel@perches.com>
 <20160624085128.GA1939@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbcFXI57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2016 04:57:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1911E1682F5
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 10:57:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E1830266720
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 10:57:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E2AB41B3256
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 10:57:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160624085128.GA1939@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:51:28AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 23, 2016 at 12:00:00PM -0700, Joe Perches wrote:
> > On Thu, 2016-06-23 at 19:36 +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Jun 15, 2016 at 01:58:45PM -0700, Joe Perches wrote:
> > > >=20
> > > > There is code duplication of a masked ethernet address comparis=
on here
> > > > so make it a separate function instead.
> > > >=20
> > > > Miscellanea:
> > > >=20
> > > > o Neaten alignment of FWINV macro uses to make it clearer for t=
he reader
> > > Applied, thanks.
> > >=20
> > > >=20
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > > ---
> > > >=20
> > > > This masked_ether_addr_equal function could go into etherdevice=
=2Eh,
> > > > but I don't see another use like it in kernel code.=A0=A0Is the=
re one?
> > >
> > > This is specific of iptables, not even nftables would use this. S=
o I
> > > would keep this in the iptables tree.
> >=20
> > Did you see the other patch that adds a generic
> > ether_addr_equal_masked() and uses it in a few
> > more files?
>=20
> You mean this one:
>=20
>         http://patchwork.ozlabs.org/patch/636208/
>=20
> OK, so I'll toss the previous and will take this one instead.
>=20
> As I said my opinion is that ether_addr_equal_masked() is only
> required by netfilter, but thinking it well I don't really mind in
> what header this function is placed given that these are our internal
> headers.

git am reports patch I get from patchwork is corrupt at line 37.
Tried a couple of tricks to fix it but this didn't work.

Would you mind resubmitting this patch?

Sorry for the inconvenience.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
