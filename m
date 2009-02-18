From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 18 Feb 2009 18:20:15 +0100
Message-ID: <m37i3nslv4.fsf@neo.luffy.cx>
References: <20090214192936.11718.44732.stgit@Decadence>
	<49994643.8010001@trash.net> <499971CC.6040903@netfilter.org>
	<49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>
	<499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>
	<499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net>
	<499AC0B3.5040902@netfilter.org> <499BDF5D.2010809@trash.net>
	<499BEBBF.7080705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:54605 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbZBRRUT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:20:19 -0500
In-Reply-To: <499BEBBF.7080705@netfilter.org> (Pablo Neira Ayuso's message of
	"Wed, 18 Feb 2009 12:06:39 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OoO Pendant  le temps de midi  du mercredi 18 f=C3=A9vrier  2009, vers =
12:06,
Pablo Neira Ayuso <pablo@netfilter.org> disait=C2=A0:

>> OK, that explains why you want to handle it this way. I don't want
>> to merge the proc file part though, so until the daemons get smarter=
,
>> people will have to use multiple rules.

> :(

A solution would be to give the  mask on the command line. The HA daemo=
n
will output  the assigned nodes to a  file and the content  of this fil=
e
will be computed into a mask.
--=20
THE BOYS ROOM IS NOT A WATER PARK
THE BOYS ROOM IS NOT A WATER PARK
THE BOYS ROOM IS NOT A WATER PARK
-+- Bart Simpson on chalkboard in episode 3F03
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
