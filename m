From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Tue, 29 Jan 2008 13:55:27 +0100
Message-ID: <479F223F.3070107@trash.net>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr> <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr> <47980A57.2020702@uls.co.za> <47984409.9020204@trash.net> <479852DD.9000304@uls.co.za> <47986158.7050202@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jaco Kroon <jaco@uls.co.za>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54217 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762586AbYA2NLZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:11:25 -0500
In-Reply-To: <47986158.7050202@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pascal Hambourg wrote:
> Hello,
>=20
> Jaco Kroon a =E9crit :
>>
>> possibly add a "--clamp-to-mtu mtu_value" or "--clamp-to-mss=20
>> mss_value" option (I'd prefer --clamp-to-mtu), which works like --se=
t,=20
>> but only if the new mss value is less than the existing one.
>=20
> Doesn't the patch "xt_TCPMSS: don't allow netfilter --setmss to incre=
ase=20
> mss" applied to 2.6.25 about a month ago already do this ?

It should.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
