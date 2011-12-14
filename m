From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 14:54:28 +0100
Message-ID: <1323870868.2334.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
	 <CAEyr1FREjhK=Y-A89GLictxLtw+Z5jixrVDa8J0BqJ6b0h_GOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, jengelh@medozas.de,
	thomas.jarosch@intra2net.com
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNNyc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:54:32 -0500
Received: by faar15 with SMTP id r15so1173160faa.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:54:31 -0800 (PST)
In-Reply-To: <CAEyr1FREjhK=Y-A89GLictxLtw+Z5jixrVDa8J0BqJ6b0h_GOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 14 d=C3=A9cembre 2011 =C3=A0 19:19 +0530, Anand Raj Manicka=
m a =C3=A9crit :
> A clarification :
> If its about flow based accounting , wont the below rules double the =
counter ?
> # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name
> http-traffic# iptables -I OUTPUT -p tcp --dport 80 -j NFACCT
> --nfacct-name http-traffic
>=20
>=20

Basically yes (if you want to account both input and output trafic)

If you want to separate counters, use :

# iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traf=
fic-in

# iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-tra=
ffic-out

?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
