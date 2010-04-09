From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 1/3] flex_array: fix the panic issue when calling flex_array_alloc()
 without __GFP_ZERO
Date: Fri, 09 Apr 2010 12:05:46 +0800
Message-ID: <4BBEA79A.3020307@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48820 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0DIEFy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:05:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fix the panic issue when calling flex_array_alloc() without __GFP_ZERO.

memset is called with the wrong address, then kernel panics.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
lib/flex_array.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
index 66eef2e..6fbb514 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -99,7 +99,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE,
+		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }


