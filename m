From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/21] libxt_dccp: restore missing XTOPT_INVERT tags for options
Date: Sun, 21 Aug 2011 13:09:18 +0200
Message-ID: <1313924977-8623-4-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38724 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1HULJm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:42 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This regression goes back to v1.4.11~19^2.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_dccp.c  |    5 +++--
 tests/options-most.rules |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 28c59b9..0fc5f7d 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -50,9 +50,10 @@ static const struct xt_option_entry dccp_opts[] =3D =
{
 	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
 	{.name =3D "dport", .id =3D O_DEST_PORT, .type =3D XTTYPE_PORTRC,
 	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
-	{.name =3D "dccp-types", .id =3D O_DCCP_TYPES, .type =3D XTTYPE_STRIN=
G},
+	{.name =3D "dccp-types", .id =3D O_DCCP_TYPES, .type =3D XTTYPE_STRIN=
G,
+	 .flags =3D XTOPT_INVERT},
 	{.name =3D "dccp-option", .id =3D O_DCCP_OPTION, .type =3D XTTYPE_UIN=
T8,
-	 .min =3D 1, .max =3D UINT8_MAX, .flags =3D XTOPT_PUT,
+	 .min =3D 1, .max =3D UINT8_MAX, .flags =3D XTOPT_INVERT | XTOPT_PUT,
 	 XTOPT_POINTER(s, option)},
 	XTOPT_TABLEEND,
 };
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 4a3cd99..ab7f586 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -46,6 +46,7 @@
 -A INPUT -m ipv6header --header hop-by-hop --soft -m rt --rt-type 2 --=
rt-segsleft 2 --rt-len 5 -m rt --rt-type 0 --rt-segsleft 2 --rt-len 5 -=
-rt-0-res --rt-0-addrs ::1 --rt-0-not-strict -m rt --rt-type 0 --rt-seg=
sleft 2 --rt-len 5 --rt-0-res --rt-0-addrs ::1,::2 --rt-0-not-strict
 -A INPUT -p tcp -m cpu --cpu 1 -m tcp --sport 1:2 --dport 1:2 --tcp-op=
tion 1 --tcp-flags FIN,SYN,RST,ACK SYN -m cpu --cpu 1
 -A INPUT -p dccp -m cpu --cpu 1 -m dccp --sport 1:2 --dport 3:4 -m cpu=
 --cpu 1
+-A INPUT -p dccp -m dccp ! --sport 1:2 ! --dport 3:4 ! --dccp-types RE=
QUEST,RESPONSE ! --dccp-option 1
 -A INPUT -p udp -m cpu --cpu 1 -m udp --sport 1:2 --dport 3:4 -m cpu -=
-cpu 1
 -A INPUT -p sctp -m cpu --cpu 1 -m sctp --sport 1:2 --dport 3:4 --chun=
k-types all INIT,SACK -m cpu --cpu 1
 -A INPUT -p esp -m esp --espspi 1:2
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
