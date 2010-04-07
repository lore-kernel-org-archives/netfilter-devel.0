From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Prerouting hook doesn't "see" all packets
Date: Wed, 07 Apr 2010 10:52:42 +0200
Message-ID: <4BBC47DA.4030005@plouf.fr.eu.org>
References: <y2yefcd93941004061610n9f6b0a90lec0209b794d5bc14@mail.gmail.com> <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: K-Gen <alphakgen@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:51168 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0DGIwp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:52:45 -0400
In-Reply-To: <alpine.LSU.2.01.1004070122000.31132@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Jan Engelhardt a =E9crit :
>=20
> The stable series did not exist before 2.6.11, so 2.6.8.1 did not=20
> exist.

It does exist. See
<http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.8.1>
Released the same day as 2.6.8 and contains a single patch, fixing a
severe bug I guess.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
