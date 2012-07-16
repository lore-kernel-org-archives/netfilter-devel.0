From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 12:49:43 +0200
Message-ID: <20120716104943.GA11172@1984>
References: <50002CEF.508@googlemail.com>
 <1342194935.11019.12.camel@tiger.regit.org>
 <50016D84.5080207@googlemail.com>
 <1342300959.6098.8.camel@tiger.regit.org>
 <5002B688.4070907@googlemail.com>
 <1342385528.8476.2.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2GPKtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:49:51 -0400
Content-Disposition: inline
In-Reply-To: <1342385528.8476.2.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 15, 2012 at 10:52:08PM +0200, Eric Leblond wrote:
> Hello,
>=20
> Le dimanche 15 juillet 2012 =E0 13:24 +0100, Mr Dash Four a =E9crit :
> > > For NFCT, you simply need to have nfnetlink_conntrack loaded.
> > >  =20
> > I did, but I also made the mistake of including a few filters in th=
at=20
> > stack, which were incompatible and that was the reason I did not ge=
t any=20
> > NFCT logs. Once that was corrected I started seeing connection trac=
king=20
> > logged.
> >=20
> > I have another question with regards to this: Is it possible to lim=
it=20
> > (by a separate filter or otherwise) the reporting and restrict it, =
to=20
> > say, a specific set of interfaces or specific source/destination IP=
=20
> > addresses/subnets?
> >=20
> > Currently, NFCT reports absolutely everything, which is not what I=20
> > really want as I have to sift through thousands of logs, not to men=
tion=20
> > that by reporting everything the system load is much higher.
> >=20
> > So, is there a way for me to do that, somehow?
>=20
> Not now but I'm working on it: Pablo has made a filter system in
> libnetfilter_conntrack. I will used it to filter.

You can also use the CT target to filter conntrack events. It's a
global configurable parameter though, but it's easy.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
