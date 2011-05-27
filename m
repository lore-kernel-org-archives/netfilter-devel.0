From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.11
Date: Fri, 27 May 2011 09:58:11 +0200
Message-ID: <20110527075811.GA3103@lutz.bln.innominate.local>
References: <4DDE857E.40807@trash.net>
 <4DDE8814.7090201@trash.net>
 <20110526200020.GA5988@lutz.bln.innominate.local>
 <alpine.LNX.2.01.1105262210150.30203@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:42539 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1E0H6M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 03:58:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1105262210150.30203@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 26, 2011 at 10:10:36PM +0200, Jan Engelhardt wrote:
> On Thursday 2011-05-26 22:00, Lutz Jaenicke wrote:
>=20
> >On Thu, May 26, 2011 at 07:04:20PM +0200, Patrick McHardy wrote:
> >> Am 26.05.2011 18:53, schrieb Patrick McHardy:
> >> > The netfilter coreteam presents:
> >> >=20
> >> >     iptables version 1.4.10
> >>=20
> >> That's supposed to read 1.4.11 of course :)
> >
> >Hmm. For reasons I do not (yet?) understand I do not get the
> >tag with "git pull" and configure.ac stays at 1.4.10 in
> >"master".
> >
> >What am I doing wrong?
>=20
> That there is no tag, or even commit a potential tag could refer to.
> Someone must have forgotten push.

Maybe. If I perform a "git clone" the tag is in the packed refs.
The tag itself (also see gitweb) includes the modification of config.ac
to reflect the bumped version number...

Best regards,
	Lutz
--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
