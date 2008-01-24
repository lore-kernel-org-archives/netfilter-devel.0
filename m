From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Thu, 24 Jan 2008 10:58:48 +0100
Message-ID: <47986158.7050202@plouf.fr.eu.org>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr> <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr> <47980A57.2020702@uls.co.za> <47984409.9020204@trash.net> <479852DD.9000304@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-234-thursday.dmz.nerim.net ([195.5.254.234]:61122 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753852AbYAXKev (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 05:34:51 -0500
Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [62.4.17.104])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id 22C81265B0
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jan 2008 11:00:50 +0100 (CET)
In-Reply-To: <479852DD.9000304@uls.co.za>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Jaco Kroon a =E9crit :
>=20
> possibly add a "--clamp-to-mtu=20
> mtu_value" or "--clamp-to-mss mss_value" option (I'd prefer=20
> --clamp-to-mtu), which works like --set, but only if the new mss valu=
e=20
> is less than the existing one.

Doesn't the patch "xt_TCPMSS: don't allow netfilter --setmss to increas=
e=20
mss" applied to 2.6.25 about a month ago already do this ?
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
