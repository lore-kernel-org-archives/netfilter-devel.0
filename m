From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/32]: nf_conntrack_sip: process ACK and PRACK methods
Date: Thu, 28 Feb 2008 13:00:26 +0100 (MET)
Message-ID: <20080228120017.29267.47448.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50019 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYB1MA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:27 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: process ACK and PRACK methods

Both may contains SDP offers/answers.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5d5f4ed24fac49a4787ca44f31058bb9ffd9ef2f
tree 539efdcec64feb403e8e32961bc332a790bb5518
parent 66f5a5cc25fd9279c23d5e4560c216b8fdd72684
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:28 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:28 +0100

 net/netfilter/nf_conntrack_sip.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d0c6b3d..567ac78 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -633,9 +633,22 @@ static int process_update_response(struct sk_buff *skb,
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
