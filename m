From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH v2] internal: fix SNPRINTF_BUFFER_SIZE macro
Date: Tue, 13 May 2014 09:08:15 +0200
Message-ID: <20140513070735.16866.22056.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50594 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750743AbaEMHI3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 03:08:29 -0400
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

While at it, let's add a check to know if the last snprintf call failed.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: return if ret < 0. Increment size later.

 src/internal.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index 6595e70..b06f166 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -183,10 +183,12 @@ struct nft_set_elem {
 };
 
 #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
-	size += ret;					\
+	if (ret < 0)					\
+		return ret;				\
+	offset += ret;					\
 	if (ret > len)					\
 		ret = len;				\
-	offset += ret;					\
+	size += ret;					\
 	len -= ret;
 
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))

