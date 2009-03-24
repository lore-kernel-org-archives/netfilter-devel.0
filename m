From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.3.1
Date: Tue, 24 Mar 2009 22:32:22 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903242224390.26397@fbirervta.pbzchgretzou.qr>
References: <49C8DB3B.909@netfilter.org> <200903242112.56886.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35893 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZCXVcY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:32:24 -0400
In-Reply-To: <200903242112.56886.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-24 22:12, Steven Jan Springl wrote:

>Is there a problem with mss in this release?
>If I specify rule:
>-A OUTPUT -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1000:1500 -j =
ACCEPT
>I get error:
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Invalid mss '1000' spe=
cified.
>
>It appears that mss values less than 65536 are rejected, while values =
of 65536=20
>or greater are accepted. Is this not the wrong way around?

Indeed. There is an uncommon coding pattern (compared to the rest of=20
the iptables sources) in the function at hand. Patch below.

usually:
	if (!strtoui(...))
		you_fail;
	return ok;
libxt_tcpmss:
	if (strtoui(...))
		return ok;
	you_fail;

Pullable from the usual location at git://dev.medozas.de/iptables

Updating 6e70f46..ed7925b
=46ast forward
 extensions/libxt_tcpmss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

parent 6e70f46f2a146bb7c657f71724c999147a5925dc (v1.4.3.1)
commit ed7925b77010dd17531ea0424b49d2b72af4add9
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Mar 24 22:26:25 2009 +0100

libxt_tcpmss: fix an inversion while parsing --mss

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tcpmss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 43a4a0d..46529f9 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -26,7 +26,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 {
 	unsigned int mssvaluenum;
=20
-	if (!xtables_strtoui(mssvalue, NULL, &mssvaluenum, 0, UINT16_MAX))
+	if (xtables_strtoui(mssvalue, NULL, &mssvaluenum, 0, UINT16_MAX))
 		return mssvaluenum;
=20
 	xtables_error(PARAMETER_PROBLEM,
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
