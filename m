From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/21] libxt_dccp: provide man pages options in short help too
Date: Sun, 21 Aug 2011 13:09:21 +0200
Message-ID: <1313924977-8623-7-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38729 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1HULJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:46 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This omission goes back to commit v1.3.4~11.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_dccp.c   |    5 ++++-
 extensions/libxt_dccp.man |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 09ef16e..4e52b38 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -37,7 +37,10 @@ static void dccp_help(void)
 "[!] --source-port port[:port]                          match source p=
ort(s)\n"
 " --sport ...\n"
 "[!] --destination-port port[:port]                     match destinat=
ion port(s)\n"
-" --dport ...\n");
+" --dport ...\n"
+"[!] --dccp-types type[,...]                            match when pac=
ket is one of the given types\n"
+"[!] --dccp-option option                               match if optio=
n (by number!) is set\n"
+);
 }
=20
 #define s struct xt_dccp_info
diff --git a/extensions/libxt_dccp.man b/extensions/libxt_dccp.man
index 82c3f70..71beb4b 100644
--- a/extensions/libxt_dccp.man
+++ b/extensions/libxt_dccp.man
@@ -9,4 +9,4 @@ list of packet types.  Packet types are:
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCA=
CK INVALID" .
 .TP
 [\fB!\fP] \fB\-\-dccp\-option\fP \fInumber\fP
-Match if DCP option set.
+Match if DCCP option set.
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
