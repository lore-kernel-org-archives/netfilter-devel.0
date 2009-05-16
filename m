From: =?UTF-8?Q?Jan_Rathousk=C3=BD?= <jan.rathousky@gmail.com>
Subject: port based routing for local generated connections
Date: Sun, 17 May 2009 01:28:03 +0200
Message-ID: <a14f8c120905161628i6b129e87m17f6db647115315c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:41527 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZEPX2D convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2009 19:28:03 -0400
Received: by bwz22 with SMTP id 22so2575301bwz.37
        for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2009 16:28:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everybody,
I'm looking for something that allows me routing based on destination
ports (for two OpenVPN tunnels).
=46irst I found nice howto [1] but there is one problem =E2=80=93 it wo=
rks only
with LAN traffic and I want it for one computer with two ISPs. Because
router decision is done before writing marks for local generated
packets. So this howto is not for me :(
I was told that "iptables -j ROUTE" is what I'm looking for.
But I'm not able to compile POM with actual iptables version and my
Debian Squeeze kernel.
Than I found xtables-addon which is much more "fresh" than POM. But it
doesn't have support for ROUTE action.
Do you plan to add it to xtables-addon?
or
Do you know something else that can help me with this situation?

Thanks for answers and for your work.

Jan

PS: does anyone try to contact someone from netfilter team to add a
link to xtables-addon instead of POM? It's quite hard to find this
project.


[1] http://www.linuxhorizon.ro/iproute2.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
