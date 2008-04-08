From: Patrick McHardy <kaber@trash.net>
Subject: Re: DCCP conntrack/NAT
Date: Tue, 08 Apr 2008 12:33:35 +0200
Message-ID: <47FB49FF.3000806@trash.net>
References: <47F64C0D.5080700@trash.net> <20080407215017.GB8682@gerrit.erg.abdn.ac.uk> <47FAA40D.7010905@trash.net> <20080408092717.GB6265@gerrit.erg.abdn.ac.uk> <47FB4962.60300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040505020903000000020202"
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34341 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYDHKdi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:33:38 -0400
In-Reply-To: <47FB4962.60300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040505020903000000020202
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> The attached patch contains the changes I've made so far
> based on your review. I'll go through the remaining points
> now.
> 

New version attached that doesn't only update the comments
but also the actual state transitions :)


--------------040505020903000000020202
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 44c8aa6..e17bd4f 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -70,7 +70,7 @@ static unsigned int dccp_timeout[CT_DCCP_MAX + 1] __read_mostly = {
 	[CT_DCCP_REQUEST]	= 2 * DCCP_MSL,
 	[CT_DCCP_RESPOND]	= 4 * DCCP_MSL,
 	[CT_DCCP_PARTOPEN]	= 4 * DCCP_MSL,
-	[CT_DCCP_OPEN]		= 5 * 86400 * HZ,
+	[CT_DCCP_OPEN]		= 12 * 3600 * HZ,
 	[CT_DCCP_CLOSEREQ]	= 64 * HZ,
 	[CT_DCCP_CLOSING]	= 64 * HZ,
 	[CT_DCCP_TIMEWAIT]	= 2 * DCCP_MSL,
@@ -142,12 +142,12 @@ dccp_state_table[IP_CT_DIR_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] = {
 		 * 			got lost after we saw it) or reincarnation
 		 * sPO -> sIG		Request during PARTOPEN state, server will ignore it
 		 * sOP -> sIG		Request during OPEN state: server will ignore it
-		 * sCR -> sIG		MUST respond with Close to CloseReq (8.3.)
+		 * sCR -> sIG		FIXME MUST respond with Close to CloseReq (8.3.)
 		 * sCG -> sIG
-		 * sTW -> sIG		Time-wait
+		 * sTW -> sRQ		Reincarnation
 		 *
 		 *	sNO, sRQ, sRS, sPO. sOP, sCR, sCG, sTW, */
-			sRQ, sRQ, sRS, sIG, sIG, sIG, sIG, sIG,
+			sRQ, sRQ, sRS, sIG, sIG, sIG, sIG, sRQ,
 		},
 		[DCCP_PKT_RESPONSE] = {
 		/*
@@ -188,7 +188,7 @@ dccp_state_table[IP_CT_DIR_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] = {
 		/*
 		 * sNO -> sIV		No connection
 		 * sRQ -> sIV		No connection
-		 * sRS -> sIV		No connection
+		 * sRS -> sPO		Ack for Response, move to PARTOPEN (8.1.5.)
 		 * sPO -> sPO		Remain in PARTOPEN state
 		 * sOP -> sOP		Regular DataAck packet in OPEN state
 		 * sCR -> sCR		DataAck in CLOSEREQ MAY be processed (8.3.)
@@ -196,7 +196,7 @@ dccp_state_table[IP_CT_DIR_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] = {
 		 * sTW -> sIV
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIV, sIV, sIV, sPO, sOP, sCR, sCG, sIV
+			sIV, sIV, sPO, sPO, sOP, sCR, sCG, sIV
 		},
 		[DCCP_PKT_CLOSEREQ] = {
 		/*
@@ -320,11 +320,11 @@ dccp_state_table[IP_CT_DIR_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] = {
 		 * sPO -> sOP -> sCR	Move directly to CLOSEREQ (8.1.5.)
 		 * sOP -> sCR		CloseReq in OPEN state
 		 * sCR -> sCR		Retransmit
-		 * sCG -> sIV		Already closing
+		 * sCG -> sCR		Simultaneous close, client sends another Close
 		 * sTW -> sIV		Already closed
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIV, sIV, sIV, sCR, sCR, sCR, sIV, sIV
+			sIV, sIV, sIV, sCR, sCR, sCR, sCR, sIV
 		},
 		[DCCP_PKT_CLOSE] = {
 		/*
@@ -333,12 +333,12 @@ dccp_state_table[IP_CT_DIR_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] = {
 		 * sRS -> sIV		No connection
 		 * sPO -> sOP -> sCG	Move direcly to CLOSING
 		 * sOP -> sCG		Move to CLOSING
-		 * sCR -> sCG		Waiting for close from client
+		 * sCR -> sIV		Close after CloseReq is invalid
 		 * sCG -> sCG		Retransmit
 		 * sTW -> sIV		Already closed
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIV, sIV, sIV, sCG, sCG, sCG, sCG, sIV
+			sIV, sIV, sIV, sCG, sCG, sIV, sCG, sIV
 		},
 		[DCCP_PKT_RESET] = {
 		/*

--------------040505020903000000020202--
