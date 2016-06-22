From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_MARK: Fix translation of --set-xmark option
Date: Wed, 22 Jun 2016 14:31:31 +0200
Message-ID: <1466598691-11071-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
	=?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: arturo.borrero.glez@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35453 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcFVMcJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:32:09 -0400
Received: by mail-wm0-f68.google.com with SMTP id a66so760131wme.2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 05:32:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

=46ix translation of MARK target's --set-xmark option.

Before:
  #iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x64/=
0xaf
  nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x64=
 and 0xaf

After:

  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x64=
/0xaf
  nft add rule ip mangle PREROUTING counter meta mark set mark and 0xff=
ffff50 \
  xor 0x64

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_MARK.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ec1ed05..bfcb030 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -261,8 +261,8 @@ static int mark_tg_xlate(const void *ip, const stru=
ct xt_entry_target *target,
 	else if (info->mask =3D=3D 0xffffffffU)
 		xt_xlate_add(xl, "0x%x ", info->mark);
 	else
-		xt_xlate_add(xl, "mark xor 0x%x and 0x%x ", info->mark,
-			     info->mask);
+		xt_xlate_add(xl, "mark and 0x%x xor 0x%x ", ~info->mask,
+			     info->mark);
=20
 	return 1;
 }
--=20
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
