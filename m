From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] internal: fix SNPRINTF_BUFFER_SIZE macro
Date: Fri, 09 May 2014 13:58:06 +0200
Message-ID: <20140509115806.2467.11788.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43267 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752858AbaEIL6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 07:58:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to store in 'offset' the complete amount of characters as returned
from _snprintf. The value means how many characters long needs the buffer to be
in order to store the corresponding string expansion.

Before this patch, in cases where the buffer is smaller than the
expansion, then ret > len, and therefore ret = len.
So when incrementing offset, we do it with a wrong value.

All previous versions of libnftnl are unable to handle this situations: small
buffers (or long string expansion).

BTW, if a caller must reallocate a buffer to the returned value of snprintf, it
should be ret + 1.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/internal.h b/src/internal.h
index 6595e70..43d61ca 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -184,9 +184,9 @@ struct nft_set_elem {
 
 #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
 	size += ret;					\
+	offset += ret;					\
 	if (ret > len)					\
 		ret = len;				\
-	offset += ret;					\
 	len -= ret;
 
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))

