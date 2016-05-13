From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] include: constify nlexpr field in location structure
Date: Fri, 13 May 2016 20:08:29 +0200
Message-ID: <1463162909-23139-2-git-send-email-pablo@netfilter.org>
References: <1463162909-23139-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35285 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcEMSIo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 14:08:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A33A11EFDA4
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92B0B2687DA
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 983BB2687D6
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:08:39 +0200 (CEST)
In-Reply-To: <1463162909-23139-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The location shouldn't ever alter the expression.

And this fixes this compilation warning:

netlink_delinearize.c: In function =E2=80=98netlink_parse_expr=E2=80=99=
:
netlink_delinearize.c:1008:10: warning: assignment discards =E2=80=98co=
nst=E2=80=99 qualifier from pointer target type
  loc.nle =3D nle;
          ^
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/nftables.h b/include/nftables.h
index cf19de8..d3f471b 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -52,7 +52,7 @@ struct location {
 			unsigned int		last_column;
 		};
 		struct {
-			void			*nle;
+			const void		*nle;
 		};
 	};
 };
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
