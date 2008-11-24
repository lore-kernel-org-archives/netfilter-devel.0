From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 17:23:46 +0100
Message-ID: <492AD512.1030401@plouf.fr.eu.org>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net> <20081124152458.GA20442@linuxace.com> <492AC919.7070005@trash.net> <alpine.LNX.1.10.0811241653370.15363@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:49862 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYKXQao (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:30:44 -0500
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 9973A39DDFB
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2008 17:23:45 +0100 (CET)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kjZ8YyJeeUTV for <netfilter-devel@vger.kernel.org>;
	Mon, 24 Nov 2008 17:23:44 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by poutre.nerim.net (Postfix) with ESMTP id 3A63539DDCD
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2008 17:23:44 +0100 (CET)
In-Reply-To: <alpine.LNX.1.10.0811241653370.15363@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Jan Engelhardt a =E9crit :
>=20
> Well, each packet (or rather, every new line) should be a "123 " code=
,
> followed by whatever text plus a newline.

Don't you mean "each reply" ? BTW, multi-line replies start with "123-"=
,=20
only the last line starts with "123 ".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
