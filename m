From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [conntrack_ftp] ftp _server_ behind dnat
Date: Sun, 20 Feb 2011 00:36:56 +0100
Message-ID: <4D605418.9050806@plouf.fr.eu.org>
References: <20110219152835.GC10969@ikki.ethgen.ch> <4D5FF16A.9060602@plouf.fr.eu.org> <20110219171502.GD10969@ikki.ethgen.ch> <4D6000F2.3040904@plouf.fr.eu.org> <20110219192916.GF10969@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Klaus Ethgen <Klaus+lkml@Ethgen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:54593 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab1BSXhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 18:37:00 -0500
In-Reply-To: <20110219192916.GF10969@ikki.ethgen.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Klaus Ethgen a =E9crit :
>=20
> Am Sa den 19. Feb 2011 um 18:42 schrieb Pascal Hambourg:
>
>> Connections on port 21 are control connections. Port 21 is used neit=
her
>> for active nor passive data connections.
>=20
> Hmm.. Yes. you are right. Nevertheless that port is only looked about=
 as
> src and not as dst.

If you were right then active mode would not work, as PORT commands are
sent to the destination port 21.

> But on a server the dst is port 21.

On a server the port 21 is the destination port for incoming packets an=
d
the source port for outgoing packets.

>>> As I read the code there seems no way to find a PORT command in out=
going
>>> connections. But that has to be detected when DNAT is used.
>> What do you mean by "outgoing connections" ?
>=20
> Well, a bit confusing, I admit.

Sorry to say, but all your explanations are confusing.

> On a client system I have SNAT so on INPUT on the external interface =
I
> see port 21.

Are you using SNAT directly on the client ? Why ?
What does SNAT have to do with INPUT ?
What is the exact rule ?

> On a server I have DNAT so on OUTPUT I see the (destination) port
> 21. But exactly that do not trigger the helper.

Are you using DNAT directly on the server ? Why ?
What does DNAT have to do with OUTPUT ?
What is the exact rule ?

> And exact that is what I find by tests. If I do an active connection =
the
> client is sending PORT to the server and the connection works well. B=
ut
> if I try to use passive the server sends the PORT command and the
> conntrack helper do never recognize the traffic as ftp related.

Huh ? The server sends a PORT command ?
This is not possible. A server does not send commands. It only replies
to commands received from the client.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
