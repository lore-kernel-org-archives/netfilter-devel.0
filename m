From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH arptables 2/2] src: fix compilation warning
Date: Thu,  2 Apr 2015 10:51:17 +0200
Message-ID: <1427964677-5887-2-git-send-email-pablo@netfilter.org>
References: <1427964677-5887-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhangcy@cn.fujitsu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbbDBIrW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 04:47:22 -0400
In-Reply-To: <1427964677-5887-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libarptc/libarptc.c: In function =E2=80=98dump_entry=E2=80=99:
libarptc/libarptc.c:137:9: warning: format =E2=80=98%lu=E2=80=99 expect=
s argument of type =E2=80=98long unsigned int=E2=80=99, but argument 2 =
has type =E2=80=98__u64=E2=80=99 [-Wformat]
libarptc/libarptc.c:137:9: warning: format =E2=80=98%lu=E2=80=99 expect=
s argument of type =E2=80=98long unsigned int=E2=80=99, but argument 3 =
has type =E2=80=98__u64=E2=80=99 [-Wformat]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 arptables.c         |    7 ++++---
 libarptc/libarptc.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arptables.c b/arptables.c
index 845e226..f820ffa 100644
--- a/arptables.c
+++ b/arptables.c
@@ -2164,16 +2164,17 @@ int do_command(int argc, char *argv[], char **t=
able, arptc_handle_t *handle)
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
=20
-			if (sscanf(pcnt, "%"PRIu64, &fw.counters.pcnt) !=3D 1)
+			if (sscanf(pcnt, "%"PRIu64,
+				   (uint64_t *)&fw.counters.pcnt) !=3D 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
=20
-			if (sscanf(bcnt, "%"PRIu64, &fw.counters.bcnt) !=3D 1)
+			if (sscanf(bcnt, "%"PRIu64,
+				   (uint64_t *)&fw.counters.bcnt) !=3D 1)
 				exit_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
-		=09
 			break;
=20
=20
diff --git a/libarptc/libarptc.c b/libarptc/libarptc.c
index 2dcaaef..0025a75 100644
--- a/libarptc/libarptc.c
+++ b/libarptc/libarptc.c
@@ -134,7 +134,7 @@ dump_entry(STRUCT_ENTRY *e, const TC_HANDLE_T handl=
e)
 	printf("Flags: %02X\n", e->arp.flags);
 	printf("Invflags: %02X\n", e->arp.invflags);
 	printf("Counters: %"PRIu64" packets, %"PRIu64" bytes\n",
-	       e->counters.pcnt, e->counters.bcnt);
+	       (uint64_t)e->counters.pcnt, (uint64_t)e->counters.bcnt);
 /*
 	printf("Cache: %08X ", e->nfcache);
 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
