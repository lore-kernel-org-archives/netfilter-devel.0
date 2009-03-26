From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nftables-goes-automake patch series
Date: Thu, 26 Mar 2009 10:45:30 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903261044230.10634@fbirervta.pbzchgretzou.qr>
References: <1237937468-31476-1-git-send-email-jengelh@medozas.de> <49CA2D68.20601@trash.net> <alpine.LSU.2.00.0903251447320.13559@fbirervta.pbzchgretzou.qr> <49CA40B2.5010300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48026 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZCZJpe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:45:34 -0400
In-Reply-To: <49CA40B2.5010300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-03-25 15:33, Patrick McHardy wrote:
>
>>> It also doesn't build anymore on my system, the
>>> parser.h file is not generated:
>>>
>>> ...
>>> scanner.l:23:20: Fehler: parser.h: Datei oder Verzeichnis nicht gef=
unden
>>> <stdout>:1395: Fehler: expected specifier-qualifier-list before =C2=
=BBYYSTYPE=C2=AB
>>> <stdout>:1454: Fehler: expected =C2=BB=3D=C2=AB, =C2=BB,=C2=AB, =C2=
=BB;=C2=AB, =C2=BBasm=C2=AB or =C2=BB__attribute__=C2=AB
>>> before
>>> =C2=BB*=C2=AB token...
>
> I tried both pulling your tree into mine, as well as a fresh clone of
> your tree. Let me know if you need more information.
>
I rebased and updated the tree now (top: 247566dd) with some info I=20
found in the automake manual, see if that works for you.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
