From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/21] libxt_dscp: restore inversion support
Date: Sun, 21 Aug 2011 13:09:23 +0200
Message-ID: <1313924977-8623-9-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38733 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1HULJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:48 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_dscp.c  |    5 +++--
 tests/options-most.rules |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 69533d6..02b22a4 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -43,9 +43,10 @@ static void dscp_help(void)
 static const struct xt_option_entry dscp_opts[] =3D {
 	{.name =3D "dscp", .id =3D O_DSCP, .excl =3D F_DSCP_CLASS,
 	 .type =3D XTTYPE_UINT8, .min =3D 0, .max =3D XT_DSCP_MAX,
-	 .flags =3D XTOPT_PUT, XTOPT_POINTER(struct xt_dscp_info, dscp)},
+	 .flags =3D XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_dscp_info, dscp)},
 	{.name =3D "dscp-class", .id =3D O_DSCP_CLASS, .excl =3D F_DSCP,
-	 .type =3D XTTYPE_STRING},
+	 .type =3D XTTYPE_STRING, .flags =3D XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
=20
diff --git a/tests/options-most.rules b/tests/options-most.rules
index ab7f586..4becc2a 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -20,8 +20,8 @@
 -A INPUT -p tcp -m connmark --mark 0x99
 -A INPUT -p tcp -m conntrack --ctstate INVALID --ctproto 6 --ctorigsrc=
 fe80::/64 --ctorigdst fe80::/64 --ctreplsrc fe80::/64 --ctrepldst fe80=
::/64 --ctorigsrcport 12 --ctorigdstport 13 --ctreplsrcport 14 --ctrepl=
dstport 15 --ctstatus EXPECTED --ctexpire 1:2 --ctdir REPLY
 -A INPUT -p tcp -m cpu --cpu 2
--A INPUT -p tcp -m dscp --dscp 0x04
--A INPUT -p tcp -m dscp --dscp 0x00
+-A INPUT -p tcp -m dscp --dscp 0x04 -m dscp ! --dscp 0x04
+-A INPUT -p tcp -m dscp --dscp 0x00 -m dscp ! --dscp 0x00
 -A INPUT -p tcp -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst =
5 --hashlimit-mode srcip,dstip --hashlimit-name f1 --hashlimit-htable-s=
ize 64 --hashlimit-htable-max 128 --hashlimit-htable-gcinterval 60 --ha=
shlimit-htable-expire 120 --hashlimit-srcmask 24 --hashlimit-dstmask 24
 -A INPUT -p tcp -m hashlimit --hashlimit-above 5/sec --hashlimit-burst=
 5 --hashlimit-name f1
 -A INPUT -p tcp -m helper --helper ftp
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
