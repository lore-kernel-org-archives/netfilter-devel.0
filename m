From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 2/3] meta: fix endianness in priority
Date: Sun, 29 May 2016 18:08:08 +0800
Message-ID: <1464516489-21616-2-git-send-email-zlpnobody@163.com>
References: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:36217 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbcE2KJP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2016 06:09:15 -0400
In-Reply-To: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For example, after we add rule to set priority 1:2, it will be displayed in network
byte order as 0200:0100, this is wrong:

  # nft add rule filter test meta priority set 1:2
  # nft list chain filter test
  table ip filter {
      chain test {
          meta priority set 0200:0100
      }
  }

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index b8db0f8..74d2b4c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -128,7 +128,7 @@ static const struct datatype tchandle_type = {
 	.type		= TYPE_TC_HANDLE,
 	.name		= "tc_handle",
 	.desc		= "TC handle",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= tchandle_type_print,
-- 
2.5.5


