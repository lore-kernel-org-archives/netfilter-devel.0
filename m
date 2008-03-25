From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/32]: nf_conntrack_sip: process ACK and PRACK methods
Date: Tue, 25 Mar 2008 15:15:20 +0100 (MET)
Message-ID: <20080325141520.10539.4555.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32948 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYCYOPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:21 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: process ACK and PRACK methods

Both may contains SDP offers/answers.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fc1d4b6b9937a801590c454b68317734a809be0b
tree c4b167a12ff72abae20998cb0be31157306b4ba8
parent bbec485758c30e4c7bc04dbc387ed9cea676bc24
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:56 +0100

 net/netfilter/nf_conntrack_sip.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 29a37d2..71f744a 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -624,9 +624,22 @@ static int process_update_response(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
+static int process_prack_response(struct sk_buff *skb,
+				  const char **dptr, unsigned int *datalen,
+				  unsigned int cseq, unsigned int code)
+{
+	if ((code >= 100 && code <= 199) ||
+	    (code >= 200 && code <= 299))
+		return process_sdp(skb, dptr, datalen, cseq);
+
+	return NF_ACCEPT;
+}
+
 static const struct sip_handler sip_handlers[] = {
 	SIP_HANDLER("INVITE", process_sdp, process_invite_response),
 	SIP_HANDLER("UPDATE", process_sdp, process_update_response),
+	SIP_HANDLER("ACK", process_sdp, NULL),
+	SIP_HANDLER("PRACK", process_sdp, process_prack_response),
 };
 
 static int process_sip_response(struct sk_buff *skb,
