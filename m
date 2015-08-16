From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 07/12] nft: fill in doff and fix ihl/version template entries
Date: Sun, 16 Aug 2015 21:05:50 +0200
Message-ID: <1439751955-31190-8-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34748 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbHPTGN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:13 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to use

nft add rule ip filter input tcp doff 8

or similar.

Furhermore, ip version looked at hdrlen and vice versa.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 27ab4a2..82cce05 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -402,8 +402,10 @@ const struct proto_desc proto_tcp = {
 		[TCPHDR_DPORT]		= INET_SERVICE("dport", struct tcphdr, dest),
 		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
 		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
-		[TCPHDR_DOFF]		= {},
-		[TCPHDR_RESERVED]	= {},
+		[TCPHDR_DOFF]		= HDR_BITFIELD("doff", &integer_type,
+						       (12 * BITS_PER_BYTE) + 4, 4),
+		[TCPHDR_RESERVED]	= HDR_BITFIELD("reserved", &integer_type,
+						       (12 * BITS_PER_BYTE) + 0, 4),
 		[TCPHDR_FLAGS]		= HDR_BITFIELD("flags", &tcp_flag_type,
 						       13 * BITS_PER_BYTE,
 						       BITS_PER_BYTE),
@@ -501,8 +503,8 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
 	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
-- 
2.0.5

