From: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Subject: RE: NTP server
Date: Sat, 25 Jul 2009 20:43:13 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB34D79A8735@INOAVREX11.ptin.corpPT.com>
References: <47A7F67C62706041BC49DB7822B1C9DB34D79A8733@INOAVREX11.ptin.corpPT.com>,<4A6A169A.9090704@solutti.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Leonardo Rodrigues <leolistas@solutti.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.ptinovacao.pt ([194.65.138.99]:59068 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZGYTp5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:45:57 -0400
In-Reply-To: <4A6A169A.9090704@solutti.com.br>
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for you attention

A response coming from another ip is exactly what happens in DCC protoc=
ol of IRC, and the module nf_conntrack_irc.ko and nf_nat_irc.ko make it=
 possible by using in the source ip of the expectation the address 0.0.=
0.0 which works like a wildcard.

Best Regards

Hugo Mendes
________________________________________
De: Leonardo Rodrigues [leolistas@solutti.com.br]
Enviado: sexta-feira, 24 de Julho de 2009 21:16
Para: Hugo Miguel Mendes
Cc: netfilter-devel@vger.kernel.org
Assunto: Re: NTP server

Hugo Miguel Mendes escreveu:
> Dear all,
>
> I'm running netfilter on a router operating OpenWRT Kamikaze 8.09, ke=
rnel 2.6.25.17.
>
> I have two computers on the router LAN which are programmed to get th=
e time from an NTP server. This NTP server has a load balancing mechani=
sm, so the computer that responds to the NTP request is not the same to=
 where was sent the request. So the response is blocked by netfilter, b=
ecause that connection wasn't started from the LAN. But the NTP server =
always keeps the same ports and always listens on port 123. So if you m=
ake the request from port 1024 to the port 123 of the server the respon=
se will come from 123 to 1024.

    the load balancing mechanism for this NTP server is fucking broke.
The load balancing mechanism is the one that should be fixed, not your
netfilter module.

    this kind of responde, coming from another ip, wont be allowed by
any possible firewall, which in the last 6-7-8 years probably, are all
statefull ones.



--


        Atenciosamente / Sincerily,
        Leonardo Rodrigues
        Solutti Tecnologia
        http://www.solutti.com.br

        Minha armadilha de SPAM, N=C3O mandem email
        gertrudes@solutti.com.br
        My SPAMTRAP, do not email it--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
