From: Praet Paul <Paul.Praet@technicolor.com>
Subject: [PATCH 1/1] Replace 'owner' in SDP enums with more correct 'origin'
Date: Thu, 28 Jun 2012 08:05:19 +0200
Message-ID: <3F4910A77924AF44876B1A096ECC92A7D5502F24B5@MOPESMBX01.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:60646 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932662Ab2F1GK5 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:10:57 -0400
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

I found that in SIP-ALG related code everywhere SDP_OWNER is used instead of the more correct SDP_ORIGIN (cfr. RFC 4566)[Paul Praet] .

Best regards,

Paul Praet

--------



Signed-off-by: Paul Praet <paul.praet@technicolor.com>
---
 include/linux/netfilter/nf_conntrack_sip.h |    4 ++--
 net/ipv4/netfilter/nf_nat_sip.c            |    4 ++--
 net/netfilter/nf_conntrack_sip.c           |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 0ce91d5..06c47b0 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -95,9 +95,9 @@ enum sip_header_types {  enum sdp_header_types {
        SDP_HDR_UNSPEC,
        SDP_HDR_VERSION,
-       SDP_HDR_OWNER_IP4,
+       SDP_HDR_ORIGIN_IP4,
        SDP_HDR_CONNECTION_IP4,
-       SDP_HDR_OWNER_IP6,
+       SDP_HDR_ORIGIN_IP6,
        SDP_HDR_CONNECTION_IP6,
        SDP_HDR_MEDIA,
 };
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c index ea4a238..609eb5a 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -423,10 +423,10 @@ static unsigned int ip_nat_sdp_session(struct sk_buff *skb, unsigned int dataoff
        char buffer[sizeof("nnn.nnn.nnn.nnn")];
        unsigned int buflen;

-       /* Mangle session description owner and contact addresses */
+       /* Mangle session description origin and contact addresses */
        buflen = sprintf(buffer, "%pI4", &addr->ip);
        if (mangle_sdp_packet(skb, dataoff, dptr, datalen, sdpoff,
-                              SDP_HDR_OWNER_IP4, SDP_HDR_MEDIA,
+                              SDP_HDR_ORIGIN_IP4, SDP_HDR_MEDIA,
                               buffer, buflen))
                return 0;

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 93faf6a..6d10d27 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -686,9 +686,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
  */
 static const struct sip_header ct_sdp_hdrs[] = {
        [SDP_HDR_VERSION]               = SDP_HDR("v=", NULL, digits_len),
-       [SDP_HDR_OWNER_IP4]             = SDP_HDR("o=", "IN IP4 ", epaddr_len),
+       [SDP_HDR_ORIGIN_IP4]            = SDP_HDR("o=", "IN IP4 ", epaddr_len),
        [SDP_HDR_CONNECTION_IP4]        = SDP_HDR("c=", "IN IP4 ", epaddr_len),
-       [SDP_HDR_OWNER_IP6]             = SDP_HDR("o=", "IN IP6 ", epaddr_len),
+       [SDP_HDR_ORIGIN_IP6]            = SDP_HDR("o=", "IN IP6 ", epaddr_len),
        [SDP_HDR_CONNECTION_IP6]        = SDP_HDR("c=", "IN IP6 ", epaddr_len),
        [SDP_HDR_MEDIA]                 = SDP_HDR("m=", NULL, media_len),
 };
@@ -1061,7 +1061,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int dataoff,
                i++;
        }

-       /* Update session connection and owner addresses */
+       /* Update session connection and origin addresses */
        nf_nat_sdp_session = rcu_dereference(nf_nat_sdp_session_hook);
        if (nf_nat_sdp_session && ct->status & IPS_NAT_MASK)
                ret = nf_nat_sdp_session(skb, dataoff, dptr, datalen, sdpoff,
--
1.7.9.5

