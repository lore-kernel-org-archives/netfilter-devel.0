From: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Subject: RE: NTP server
Date: Sun, 26 Jul 2009 19:54:16 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB34D79A8736@INOAVREX11.ptin.corpPT.com>
References: <47A7F67C62706041BC49DB7822B1C9DB34D79A8733@INOAVREX11.ptin.corpPT.com>,<4A6A169A.9090704@solutti.com.br>
 <47A7F67C62706041BC49DB7822B1C9DB34D79A8735@INOAVREX11.ptin.corpPT.com>,<4A6BBB9A.909@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Leonardo Rodrigues <leolistas@solutti.com.br>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from owa.ptinovacao.pt ([194.65.138.99]:48551 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZGZSzn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Jul 2009 14:55:43 -0400
In-Reply-To: <4A6BBB9A.909@treenet.co.nz>
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm not the server, I'm the client I just wan't to forward the packets that come from the NTP server to the proper client on the LAN.
________________________________________
De: netfilter-devel-owner@vger.kernel.org [netfilter-devel-owner@vger.kernel.org] Em Nome De Amos Jeffries [squid3@treenet.co.nz]
Enviado: domingo, 26 de Julho de 2009 3:12
Para: Hugo Miguel Mendes
Cc: Leonardo Rodrigues; netfilter-devel@vger.kernel.org
Assunto: Re: NTP server

Hugo Miguel Mendes wrote:
> Thanks for you attention
>
> A response coming from another ip is exactly what happens in DCC protocol of IRC, and the module nf_conntrack_irc.ko and nf_nat_irc.ko make it possible by using in the source ip of the expectation the address 0.0.0.0 which works like a wildcard.
>
> Best Regards
>
> Hugo Mendes

That being IRC, a protocol where such behaviour is defined.

NTP is direct trusted peer to prevent abuse and protect the little
structure that depends on it called The Internet.

What would you expect to happen if all your server clocks accepted
random non-requested packets as truth?

Amos
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html