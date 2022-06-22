Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00DCC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jun 2022 20:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbiFVUC4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiFVUCz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jun 2022 16:02:55 -0400
X-Greylist: delayed 352 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Jun 2022 13:02:47 PDT
Received: from cargova.sijanec.eu (cargova.sijanec.eu [93.103.235.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8731F403E3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 13:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sijanec.eu; s=mail;
        t=1655927809; bh=S3WryCVQLoD2Sly4OH8kyrC22P5nmXGsxsAneLHnrsw=;
        h=Date:From:To:Subject:From;
        b=BsxRRzoyBkrFat1QidHnmQuEr/rUde7473vX8bKLeXyiIekFb7H+nRuhdeoMklSH/
         G297W+/SsKp7EMBCcjuY8ti+5BHLiTaKdU9OAJH17yMKFhESsMHHLEk4j8hJwDzrmU
         IBon9peHWUTpKwbD66jUaes9OkATywxqc7uKocemdDh5TR08Lc0tmp8Kf5lD8lwEx6
         +pY8zi1uwdn42GrWk8tC4YJXT0Cfw/aeSkAG7yuxU+bzh2ZlWw163LDGDuCQYEjvXQ
         qtrSYgdeX72PuFMJmfQZNwPTYCkMvaUuO3MaExiLjcpDuCwd1hi/OM9nLW0lVFFPEo
         +Z85yvGfriWgg==
Date:   Wed, 22 Jun 2022 21:56:47 +0200
From:   Anton Luka =?UTF-8?B?xaBpamFuZWM=?= <anton@sijanec.eu>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] xtables-monitor: add missing spaces in printed str
Message-ID: <20220622215647.5d996055@varovalka>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archive: No
X-No-Archive: Yes
X-Face: W%?.c0z<^"^iL51:]$qinn#Qg"hoo"ls4ROyFmgZTNa,416rVqk]"&JuYi}MI0D,~{j_Zx%
 p;PV5v7tV0Bb01AxV+VeriVd=LQb$Z/N/./N2"3z3c"t'~bF:s=bdjK3?$1LLej7@0+?NfbZ!`rgz$
 yW[M,eth4!Z_5&p*)(@N67tYwd8&??n7Ck|>4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

when printing the ID and OPTs in iptables/xtables-monitor.c, a space is
missing after the string, thereby concatenating the number with the next
item in the printed PACKET line.

Signed-off-by: Anton Luka =C5=A0ijanec <anton@sijanec.eu>
---
 iptables/xtables-monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 905bb7fe..a1eba2f4 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -339,7 +339,7 @@ static void trace_print_packet(const struct nftnl_trace=
 *nlt, struct cb_arg *arg
 			inet_ntop(AF_INET, &iph->daddr, addrbuf, sizeof(addrbuf));
 			printf("DST=3D%s ", addrbuf);
=20
-			printf("LEN=3D%d TOS=3D0x%x TTL=3D%d ID=3D%d", ntohs(iph->tot_len), iph=
->tos, iph->ttl, ntohs(iph->id));
+			printf("LEN=3D%d TOS=3D0x%x TTL=3D%d ID=3D%d ", ntohs(iph->tot_len), ip=
h->tos, iph->ttl, ntohs(iph->id));
 			if (iph->frag_off & htons(0x8000))
 				printf("CE ");
 			if (iph->frag_off & htons(IP_DF))
@@ -362,7 +362,7 @@ static void trace_print_packet(const struct nftnl_trace=
 *nlt, struct cb_arg *arg
 				printf("OPT (");
 				for (i =3D 0; i < optsize; i++)
 					printf("%02X", op[i]);
-				printf(")");
+				printf(") ");
 			}
 			break;
 		}
--=20
2.35.1

