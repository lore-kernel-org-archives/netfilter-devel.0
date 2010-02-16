From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: kernel stack  trace using conntrack
Date: Tue, 16 Feb 2010 10:51:29 +0100
Message-ID: <1266313889.3045.1.camel@edumazet-laptop>
References: <7EF5DBE4C76A7B4DA655334E9F2BFD26CED7BC8D04@FRSPX100.fr01.awl.atosorigin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Ramblewski David <David.Ramblewski@atosorigin.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61739 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0BPJve (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:51:34 -0500
Received: by bwz5 with SMTP id 5so1738252bwz.1
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2010 01:51:32 -0800 (PST)
In-Reply-To: <7EF5DBE4C76A7B4DA655334E9F2BFD26CED7BC8D04@FRSPX100.fr01.awl.atosorigin.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 16 f=C3=A9vrier 2010 =C3=A0 10:11 +0100, Ramblewski David a =C3=
=A9crit :
> Hi all,
>=20
> This issue has not yet been answered. Does anyone know something abou=
t it?
> We are using netfilter conntrack product on our production sites. The=
 main goal is to deploy it to hundreds of servers but we are actually w=
aiting for your feedback.
>=20
> If anyone can help...
>=20

Please post "lsmod" output, because I cannot reproduce the problem here=
=2E
It is probably dependent on your netfilter config.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
