From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFQUEUE target with --treat-accept-as-continue?
Date: Mon, 2 Apr 2012 11:13:03 +0200
Message-ID: <20120402091303.GA14599@1984>
References: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com>
 <20120401175159.GA11401@1984>
 <1333336294.99244.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Amm Snort <ammdispose-snort@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2DBJNM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:13:12 -0400
Content-Disposition: inline
In-Reply-To: <1333336294.99244.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 02, 2012 at 11:11:34AM +0800, Amm Snort wrote:
> ----- Original Message -----
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> >>  So my request and suggestion is to add additional parameter to NF=
QUEUE
> >>  say, --treat-accept-as-continue (or rule not matched)
> >>=20
> >>=20
> >>  which means, if QUEUE program returns NF_ACCEPT then instead of A=
CCEPTing
> >>  the packet, continue processing next rule. (as if rule did=A0 not=
 match)
>=20
>=20
> >=20
> > That will not be straight forward to implement. The existing code d=
oes
> > not provide a way to resume packet filtering just after the rule th=
at
> > enqueued the packet to user-space.
>=20
> Umm. so how does NFLOG (libnetfilter_log) do it?
>=20
> From man page: (for NFLOG)
> =A0=A0=A0 Like LOG, this is=A0 a=A0 non-terminating=A0 target, i.e. r=
ule traversal continues at the next rule.
>=20
> If I am not wrong, NFLOG and NFQUEUE are much similar. If NFLOG can a=
llow to continue to
> next rule, may be NFQUEUE can, as well.

NFLOG delivers the log using netlink multicast and it doesn't wait
for user-space to issue any verdict on the log message.

> We already have --queue-bypass option which bypasses to next rule of =
QUEUE is not present.
> May be we can have modification to code, which bypasses when NF_ACCEP=
T is received from
> userspace.

I know, but that's a completely different situation.

> Just a suggestion, I am not sure if this would need changes at kernel=
 level.

As said, this is not straight forward. Look at the code at you'll see
why I'm telling you this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
