From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iptables v2] libxt_sctp: fix array out of range in print_chunk
Date: Mon, 13 Nov 2017 14:27:54 +0100
Message-ID: <20171113132754.14911-1-nicolas.dichtel@6wind.com>
References: <20171113123854.GA7570@salvia>
Cc: netfilter-devel@vger.kernel.org,
        huaibin Wang <huaibin.wang@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:37589 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754230AbdKMN2J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 08:28:09 -0500
In-Reply-To: <20171113123854.GA7570@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: huaibin Wang <huaibin.wang@6wind.com>

For chunk type ASCONF, ASCONF_ACK and FORWARD_TSN, sctp_chunk_names[].chunk_type
is not equal to the corresponding index in sctp_chunk_names[]. Using this field
leads to a segmentation fault (index out of range).

Example
$ iptables -A INPUT -p sctp --chunk-type all ASCONF,ASCONF_ACK,FORWARD_TSN -j ACCEPT
$ iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Segmentation fault

Signed-off-by: huaibin Wang <huaibin.wang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v1 -> v2:
 uncomment corresponding tests

 extensions/libxt_sctp.c | 2 +-
 extensions/libxt_sctp.t | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index df1936be8b83..140de2653b1e 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -370,7 +370,7 @@ print_chunk(uint32_t chunknum, int numeric)
 
 		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (sctp_chunk_names[i].chunk_type == chunknum)
-				printf("%s", sctp_chunk_names[chunknum].name);
+				printf("%s", sctp_chunk_names[i].name);
 	}
 }
 
diff --git a/extensions/libxt_sctp.t b/extensions/libxt_sctp.t
index 2f75e2a68e8e..4016e4fb1880 100644
--- a/extensions/libxt_sctp.t
+++ b/extensions/libxt_sctp.t
@@ -23,10 +23,7 @@
 -p sctp -m sctp --chunk-types all COOKIE_ACK;=;OK
 -p sctp -m sctp --chunk-types all ECN_ECNE;=;OK
 -p sctp -m sctp --chunk-types all ECN_CWR;=;OK
-# ERROR: iptables-save segfaults: iptables -A INPUT -p sctp -m sctp --chunk-types all ASCONF
-# -p sctp -m sctp --chunk-types all ASCONF;=;OK
-# ERROR: iptables-save segfaults: iptables -A INPUT -p sctp -m sctp --chunk-types all ASCONF_ACK
-# -p sctp -m sctp --chunk-types all ASCONF_ACK;=;OK
-# ERROR: iptables-save segfaults: iptables -A INPUT -p sctp -m sctp --chunk-types all FORWARD_TSN
-# -p sctp -m sctp --chunk-types all FORWARD_TSN;=;OK
+-p sctp -m sctp --chunk-types all ASCONF;=;OK
+-p sctp -m sctp --chunk-types all ASCONF_ACK;=;OK
+-p sctp -m sctp --chunk-types all FORWARD_TSN;=;OK
 -p sctp -m sctp --chunk-types all SHUTDOWN_COMPLETE;=;OK
-- 
2.13.2

