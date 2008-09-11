From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 1/1] Remove old fixme.
Date: Thu, 11 Sep 2008 16:00:24 +0200
Message-ID: <1221141624.15090.66.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:60484 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYIKOc7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:32:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Chains _are_ sorted, binary search depend on it!

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index b68e48c..39c8e99 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1076,8 +1076,6 @@ static int parse_table(TC_HANDLE_T h)
 		}
 	}
 
-	/* FIXME: sort chains */
-
 	return 1;
 }
 
-- 
1.5.4.2


