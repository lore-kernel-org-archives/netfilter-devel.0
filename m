From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFQUEUE target with --treat-accept-as-continue?
Date: Sun, 1 Apr 2012 19:51:59 +0200
Message-ID: <20120401175159.GA11401@1984>
References: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Amm Snort <ammdispose-snort@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2DARwC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:52:02 -0400
Content-Disposition: inline
In-Reply-To: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 31, 2012 at 10:09:42PM +0800, Amm Snort wrote:
> Hello all,
>=20
> I would like to suggest a feature (additional parameter) for NFQUEUE =
target.
>=20
> I am basically trying to use snort with NFQUEUE.
>=20
> Basic iptables rule is somewhat like this:
>=20
> iptables -A INPUT -i ppp1 -j NFQUEUE
> iptables -A INPUT -p tcp --dport 22 -j ACCEPT
> iptables -A INPUT -j DROP
>=20
> Idea is to pass all packets to snort first and then if snort detects =
trojan signature then
> it can DROP (IPS) the packet (drop rule of snort). If snort detects p=
ort scan it can
> LOG but still ACCEPT (IDS) (alert rule of snort). If snort ACCEPTs th=
e packet then
> continue processing next rule.
>=20
> On side note, this idea also reduces load on snort as it does not hav=
e to sniff every
> packet coming on network card and also we can pass only selected pack=
ets to snort.
>=20
>=20
> This idea however, DOES NOT work because currently when QUEUE program=
 (snort)
> gives verdict as NF_ACCEPT, iptables STOPS processing further rules a=
nd
> ACCEPTs the packet.
>=20
> This actually becomes security risk because default snort rules DO NO=
T DO port blocking.
> and ACCEPTs everything that is not EXPLICITLY dropped.
>=20
> And hence NFQUEUE target indirectly becomes ACCEPT target for all pac=
kets and
> full system gets exposed.
>=20
> So my request and suggestion is to add additional parameter to NFQUEU=
E
> say, --treat-accept-as-continue (or rule not matched)
>=20
>=20
> which means, if QUEUE program returns NF_ACCEPT then instead of ACCEP=
Ting
> the packet, continue processing next rule. (as if rule did=A0 not mat=
ch)
>=20
>=20
> I know there is NF_REPEAT, but that will PASS packet through all proc=
esing again
> and I will also have to do packet marking etc. Which is more like HAC=
K instead of
> sensible approach.
>=20
> And to use NF_REPEAT I will need to change whole snort code and rules=
=2E Which is
> impossible.
>
> So please consider my suggestion. As it opens up many other possibili=
ties as well.

That will not be straight forward to implement. The existing code does
not provide a way to resume packet filtering just after the rule that
enqueued the packet to user-space.

[...]
> PS:
> We can also extend this suggesion further with one more parameter as
> --treat-accept-as-return which becomes equivalent to RETURN target.

Same thing with RETURN.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
