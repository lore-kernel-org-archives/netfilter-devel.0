From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 18 Feb 2009 18:25:57 +0100
Message-ID: <499C44A5.9040700@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence>	<49994643.8010001@trash.net> <499971CC.6040903@netfilter.org>	<49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>	<499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>	<499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net>	<499AC0B3.5040902@netfilter.org> <499BDF5D.2010809@trash.net>	<499BEBBF.7080705@netfilter.org> <m37i3nslv4.fsf@neo.luffy.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Vincent Bernat <bernat@luffy.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZBRR0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:26:00 -0500
In-Reply-To: <m37i3nslv4.fsf@neo.luffy.cx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vincent Bernat wrote:
> OoO Pendant  le temps de midi  du mercredi 18 f=E9vrier  2009, vers 1=
2:06,
> Pablo Neira Ayuso <pablo@netfilter.org> disait :
>=20
>>> OK, that explains why you want to handle it this way. I don't want
>>> to merge the proc file part though, so until the daemons get smarte=
r,
>>> people will have to use multiple rules.
>=20
>> :(
>=20
> A solution would be to give the  mask on the command line. The HA dae=
mon
> will output  the assigned nodes to a  file and the content  of this f=
ile
> will be computed into a mask.

Indeed. Just a bitmask (is 64 nodes max enough?) should be fine.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
