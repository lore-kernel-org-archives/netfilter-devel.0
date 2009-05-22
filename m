From: Jan Engelhardt <jengelh@medozas.de>
Subject: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Fri, 22 May 2009 11:44:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: wintre <mikeacar@gmail.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51703 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZEVJok (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2009 05:44:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


once again, irc snatched this report:

|2009-05-20T20:56 < Wintre:#Netfilter>
|
|Specifically, when I add a DROP rule to the local firewall, send(2)
|starts getting EPERM. The netfilter core code includes
|nf_hook_slow(), which says:
|
| /* Returns 1 if okfn() needs to be executed by the caller,
|  * -EPERM for NF_DROP, 0 otherwise. */
|
|So, this seems kind of crazy to me. I always thought drop was
|supposed to be silent, and changing the return value of send(2),
|well. Bad. Anybody got a link to a discussion of this issue? Or is it
|just a plain old bug?

I agree with the user here. For now, one had to make use of the
=E2=80=9CSTEAL=E2=80=9D target [1] to get the real silent drop behavior=
 for the
OUTPUT chain. Surely that is not the ideal thing either.
Requesting comments from NF maintainers.

[1] http://xtables-addons.git.sourceforge.net/git/gitweb.cgi?p=3Dxtable=
s-addons;a=3Dblob;hb=3DHEAD;f=3Dextensions/xt_STEAL.c
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
