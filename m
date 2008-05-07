From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: nf_conntrack_sip: restrict RTP expect flushing on
 error to last request
Date: Wed, 07 May 2008 09:47:32 +0200
Message-ID: <48215E94.7070308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020107030102090000030606"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776AbYEGHsH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2008 03:48:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020107030102090000030606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

These two patches contain a workaround for the SIP helper for
some slightly odd behaviour of some Innovaphone phones and a
minor improvement to the DCCP/SCTP conntrack Kconfig defaults.

Please apply, thanks.


--------------020107030102090000030606
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack_sip: restrict RTP expect flushing on error to last request

Some Inovaphone PBXs exhibit very stange behaviour: when dialing for example
"123", the device sends INVITE requests for "1", "12" and "123" back to back.
The first requests will elicit error responses from the receiver, causing
the SIP helper to flush the RTP expectations even though we might still see
a positive response.

Note the sequence number of the last INVITE request that contained a media
description and only flush the expectations when receiving a negative
response for that sequence number.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3f6886bf0dcfb06f81de3b27b607a45143c27916
tree 4bbd983368efb38a3fad2f1cdbc57fd458897ad6
parent 358c12953b88c5a06a57c33eb27c753b2e7934d1
author Patrick McHardy <kaber@trash.net> Tue, 06 May 2008 09:18:54 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 06 May 2008 09:18:54 +0200

 include/linux/netfilter/nf_conntrack_sip.h |    1 +
 net/netfilter/nf_conntrack_sip.c           |   22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 5da04e5..23aa2ec 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -7,6 +7,7 @@
 
 struct nf_ct_sip_master {
 	unsigned int	register_cseq;
+	unsigned int	invite_cseq;
 };
 
 enum sip_expectation_classes {
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 9f49000..2f9bbc0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -870,6 +870,7 @@ static int process_sdp(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
 	unsigned int matchoff, matchlen;
 	unsigned int mediaoff, medialen;
 	unsigned int sdpoff;
@@ -959,6 +960,9 @@ static int process_sdp(struct sk_buff *skb,
 	if (nf_nat_sdp_session && ct->status & IPS_NAT_MASK)
 		ret = nf_nat_sdp_session(skb, dptr, sdpoff, datalen, &rtp_addr);
 
+	if (ret == NF_ACCEPT && i > 0)
+		help->help.ct_sip_info.invite_cseq = cseq;
+
 	return ret;
 }
 static int process_invite_response(struct sk_buff *skb,
@@ -967,14 +971,14 @@ static int process_invite_response(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
 
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
-	else {
+	else if (help->help.ct_sip_info.invite_cseq == cseq)
 		flush_expectations(ct, true);
-		return NF_ACCEPT;
-	}
+	return NF_ACCEPT;
 }
 
 static int process_update_response(struct sk_buff *skb,
@@ -983,14 +987,14 @@ static int process_update_response(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
 
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
-	else {
+	else if (help->help.ct_sip_info.invite_cseq == cseq)
 		flush_expectations(ct, true);
-		return NF_ACCEPT;
-	}
+	return NF_ACCEPT;
 }
 
 static int process_prack_response(struct sk_buff *skb,
@@ -999,14 +1003,14 @@ static int process_prack_response(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn_help *help = nfct_help(ct);
 
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, dptr, datalen, cseq);
-	else {
+	else if (help->help.ct_sip_info.invite_cseq == cseq)
 		flush_expectations(ct, true);
-		return NF_ACCEPT;
-	}
+	return NF_ACCEPT;
 }
 
 static int process_bye_request(struct sk_buff *skb,

--------------020107030102090000030606--
