From: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
Subject: [PATCH] netfilter: sctp chunk mapping doesn't work
Date: Thu, 05 Feb 2009 10:26:58 +0100
Message-ID: <498AB0E2.50507@dev.6wind.com>
Reply-To: nicolas.dichtel@dev.6wind.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020709010100030801050002"
To: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020709010100030801050002
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

When user tries to map all chunks given in argument, kernel works on a copy of 
the chunkmap, but at the end it doesn't check the copy, but the orginal one.

Signed-off-by: Qu Haoran <haoran.qu@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

--------------020709010100030801050002
Content-Type: text/x-patch;
 name="x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.diff"

--- linux-2.6.28.2/net/netfilter/xt_sctp.c	2009-01-24 19:42:07.000000000 -0500
+++ linux-2.6.28.2-new/net/netfilter/xt_sctp.c	2009-02-05 04:13:31.000000000 -0500
@@ -105,7 +105,7 @@ match_packet(const struct sk_buff *skb,
 
 	switch (chunk_match_type) {
 	case SCTP_CHUNK_MATCH_ALL:
-		return SCTP_CHUNKMAP_IS_CLEAR(info->chunkmap);
+		return SCTP_CHUNKMAP_IS_CLEAR(chunkmapcopy);
 	case SCTP_CHUNK_MATCH_ANY:
 		return false;
 	case SCTP_CHUNK_MATCH_ONLY:

--------------020709010100030801050002--
