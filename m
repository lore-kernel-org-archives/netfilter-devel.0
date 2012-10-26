From: Tamas Csillag <tamas.csillag@gcd.ie>
Subject: Re: H.239 support in the H.323 helper?
Date: Fri, 26 Oct 2012 11:06:49 +0000 (UTC)
Message-ID: <loom.20121026T125539-619@post.gmane.org>
References: <alpine.DEB.2.00.0909221132150.16779@blackhole.kfki.hu> <20090926091747.GV31123@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47003 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab2JZLfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:35:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TRiBt-0005lp-00
	for netfilter-devel@vger.kernel.org; Fri, 26 Oct 2012 13:35:05 +0200
Received: from 83.141.77.130 ([83.141.77.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Oct 2012 13:35:04 +0200
Received: from tamas.csillag by 83.141.77.130 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Oct 2012 13:35:04 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pasi K=C3=A4rkk=C3=A4inen <pasik <at> iki.fi> writes:

>=20
> On Tue, Sep 22, 2009 at 11:44:45AM +0200, Jozsef Kadlecsik wrote:
> > Hi,
> >=20
> > With the H.323 conntrack helper enabled on a machine running Gnugk,=
 it=20
> > cannot establish multiple channels for conferencing and presentatio=
n with=20
> > a Polycom MGC MCU. The device wants to use H.239 and the helper can=
not=20
> > decode/interpret the protocol:
> >=20
> > Sep 21 13:41:48 caladan kernel: nf_ct_h323: incomplete TPKT (fragme=
nted?)
> >=20
> > Could you consider to add H.239 support to the H.323 helper?
> >=20
>=20
> Hello.
>=20
> I don't know if anyone is working on adding H.239, but you could alwa=
ys
> start working on it yourself. You seem to have the needed equipment t=
o
> test it :)
>=20

Hi,

Was this ever implemented? Checked the 2.6.32 source, and didn't find a=
ny=20
reference to H.239.
We are experiencing random dropped calls from a Polycom HDX8000, sittin=
g behind=20
a Vyatta, running 2.6.32, with the same syslog messages.
If needed, I can do some limited testing (both systems are in productio=
n, not=20
dev...).

Regards,
Tamas

--

Tamas Csillag
systems administrator

Griffith College Dublin
South Circular Road
Dublin 8
Ireland

Phone:  +353 87 7373462
        +353  1 4163365
Email:  tamas.csillag@gcd.ie



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
