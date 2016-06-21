From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_MARK: Fix translation of --set-xmark option
Date: Tue, 21 Jun 2016 23:03:43 +0200
Message-ID: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: arturo.borrero.glez@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35507 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbcFUVEQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2016 17:04:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id w130so7206522lfd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2016 14:04:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

=46ix translation of MARK target's --set-xmark option.

Before:

 # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x64/=
0xaf
  nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x64=
 and 0xaf

After:

  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x64=
/0xaf
  nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x64=
 and \
  0xffffff50

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_MARK.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ec1ed05..12ab94f 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -262,7 +262,7 @@ static int mark_tg_xlate(const void *ip, const stru=
ct xt_entry_target *target,
 		xt_xlate_add(xl, "0x%x ", info->mark);
 	else
 		xt_xlate_add(xl, "mark xor 0x%x and 0x%x ", info->mark,
-			     info->mask);
+			     ~info->mask);
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
