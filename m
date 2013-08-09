From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 03/13] src: expr: change wrong value in data_reg
Date: Fri, 09 Aug 2013 13:12:19 +0200
Message-ID: <20130809111219.29819.20842.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38640 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967774Ab3HILM2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:28 -0400
Received: by mail-wi0-f181.google.com with SMTP id en1so1508678wid.14
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:12:26 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Changed wrong value in data_reg_chain snprintf

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/data_reg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index fceec5a..825e474 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -359,8 +359,8 @@ int nft_data_reg_snprintf(char *buf, size_t size, u=
nion nft_data_reg *reg,
 		case NFT_RULE_O_JSON:
 			return snprintf(buf, size,
 					"\"data_reg\": { \"type\" : \"chain\", "
-						"\"chain\" : %d"
-					"}", reg->verdict);
+						"\"chain\" : \"%s\""
+					"}", reg->chain);
 		default:
 			break;
 		}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
