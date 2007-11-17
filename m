From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sat, 17 Nov 2007 16:29:01 +0100
Message-ID: <473F08BD.7080108@plouf.fr.eu.org>
References: <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com> <20071116.161926.00949588.davem@davemloft.net> <m38x4x6yvu.fsf@ursa.amorsen.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-236-saturday.dmz.nerim.net ([195.5.254.236]:53873 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753889AbXKQPbG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:31:06 -0500
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [62.4.17.106])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id F32722630F
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2007 16:30:57 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by mallaury.nerim.net (Postfix) with ESMTP id 13F964F42A
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2007 16:28:52 +0100 (CET)
In-Reply-To: <m38x4x6yvu.fsf@ursa.amorsen.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Benny Amorsen a =E9crit :
>=20
> DM> I disagree, passive ftp is extremely pervasive, there is no reaso=
n
> DM> to use traditional ftp these days.

So what ? The FTP helper is useful in both active and passive modes.

> Active FTP needs helpers on the client side, passive FTP needs helper=
s
> on the server side.

If you want to restrict outgoing connections you also need the FTP=20
conntrack helper regardless of whether you're on the server or client s=
ide.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
