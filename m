From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2 3/3] example: removed printf rule function
Date: Sat, 08 Mar 2014 16:22:48 +0100
Message-ID: <20140308152239.18827.18277.stgit@Ph0enix>
References: <20140308152106.18827.23707.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38981 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHPXD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:23:03 -0500
Received: by mail-bk0-f45.google.com with SMTP id na10so1055657bkb.18
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2014 07:23:01 -0800 (PST)
Received: from [127.0.1.1] ([2001:bf0:c001:30:3d1f:93c2:7e21:8d5c])
        by mx.google.com with ESMTPSA id dj6sm5905405bkc.5.2014.03.08.07.23.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Mar 2014 07:23:00 -0800 (PST)
In-Reply-To: <20140308152106.18827.23707.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Removed this code because with that we have a strange
output. Example:

we have a rule with handle 4 and we execute
nft-rule-del ip filter input 4

Output: unknown filter input 4 0

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-rule-del.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index b29c757..cec9440 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -81,10 +81,6 @@ int main(int argc, char *argv[])
 	if (argc =3D=3D 5)
 		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, atoi(argv[4]));
=20
-	char tmp[1024];
-	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("%s\n", tmp);
-
 	batch =3D mnl_nlmsg_batch_start(buf, sizeof(buf));
=20
 	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
