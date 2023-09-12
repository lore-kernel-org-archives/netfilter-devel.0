Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91106CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 11:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbjILLqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 07:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbjILLp6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 07:45:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B2FF10C9
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 04:45:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     devel@linux-ipsec.org, tobias@strongswan.org,
        steffen.klassert@secunet.com, antony@phenome.org,
        thomas.egerer@secunet.com
Subject: [iproute2] xfrm: add udp standalone encapsulation mode
Date:   Tue, 12 Sep 2023 13:45:43 +0200
Message-Id: <20230912114543.7683-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch enables two new encapsulation modes:

- espinudp-tx, for the sender side, this requires the source and
  destination ports to be specified, to be placed in the UDP header.
- espinudp-rx, for the receiver side, this requires only the source port
  which is used for the listener in-kernel UDP socket.

The following example shows how to configure the SAs:

  ip xfrm state add src 192.168.10.10 dst 192.168.10.11 proto esp spi 1 \
        encap espinudp-tx 9999 9999 0.0.0.0 \
        if_id 0x1 reqid 1 replay-window 1  mode tunnel aead 'rfc4106(gcm(aes))' \
        0x1111111111111111111111111111111111111111 96 \
        sel src 10.141.10.0/24 dst 10.141.11.0/24

  ip xfrm state add src 192.168.10.11 dst 192.168.10.10 proto esp spi 2 \
        encap espinudp-rx 9999 0 0.0.0.0 \
        if_id 0x1 reqid 2 replay-window 10 mode tunnel aead 'rfc4106(gcm(aes))' \
        0x2222222222222222222222222222222222222222 96

People work around this by creating dummy userspace daemon such
as in smallish programs to work around this limitation, see:

  https://github.com/nilcons/ipsec-stun-explain/blob/master/tools/orig_ipsec_decap.pl

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/udp.h |  2 ++
 ip/ipxfrm.c              | 10 ++++++++++
 ip/xfrm_state.c          |  2 +-
 man/man8/ip-xfrm.8       |  4 ++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index d0a7223a0119..8ff9b547733c 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -43,5 +43,7 @@ struct udphdr {
 #define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
 #define UDP_ENCAP_RXRPC		6
 #define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
+#define UDP_ENCAP_ESPINUDP_RX	8
+#define UDP_ENCAP_ESPINUDP_TX	9
 
 #endif /* _LINUX_UDP_H */
diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index b78c712dfd73..50ae147c333f 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -751,6 +751,12 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family, FILE *fp,
 		case TCP_ENCAP_ESPINTCP:
 			fprintf(fp, "espintcp ");
 			break;
+		case UDP_ENCAP_ESPINUDP_RX:
+			fprintf(fp, "espinudp-rx ");
+			break;
+		case UDP_ENCAP_ESPINUDP_TX:
+			fprintf(fp, "espinudp-tx ");
+			break;
 		default:
 			fprintf(fp, "%u ", e->encap_type);
 			break;
@@ -1212,6 +1218,10 @@ int xfrm_encap_type_parse(__u16 *type, int *argcp, char ***argvp)
 		*type = UDP_ENCAP_ESPINUDP;
 	else if (strcmp(*argv, "espintcp") == 0)
 		*type = TCP_ENCAP_ESPINTCP;
+	else if (strcmp(*argv, "espinudp-rx") == 0)
+		*type = UDP_ENCAP_ESPINUDP_RX;
+	else if (strcmp(*argv, "espinudp-tx") == 0)
+		*type = UDP_ENCAP_ESPINUDP_TX;
 	else
 		invarg("ENCAP-TYPE value is invalid", *argv);
 
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index aa0dce072dff..eaadf86cc913 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -96,7 +96,7 @@ static void usage(void)
 		"LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n"
 		"LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n"
 		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n"
-		"ENCAP := { espinudp | espinudp-nonike | espintcp } SPORT DPORT OADDR\n"
+		"ENCAP := { espinudp | espinudp-nonike | espintcp | espinudp-rx | espinudp-tx } SPORT DPORT OADDR\n"
 		"DIR := in | out\n");
 
 	exit(-1);
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index 3270f336d070..92e82ddb9534 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -219,7 +219,7 @@ ip-xfrm \- transform configuration
 
 .ti -8
 .IR ENCAP " :="
-.RB "{ " espinudp " | " espinudp-nonike " | " espintcp " }"
+.RB "{ " espinudp " | " espinudp-nonike " | " espintcp " | " espinudp-rx " | " espinudp-tx " }"
 .IR SPORT " " DPORT " " OADDR
 
 .ti -8
@@ -580,7 +580,7 @@ sets limits in seconds, bytes, or numbers of packets.
 .TP
 .I ENCAP
 encapsulates packets with protocol
-.BR espinudp ", " espinudp-nonike ", or " espintcp ","
+.BR espinudp ", " espinudp-nonike ", " espintcp ", " or " espinudp-rx " | " espinudp-tx ","
 .RI "using source port " SPORT ", destination port "  DPORT
 .RI ", and original address " OADDR "."
 
-- 
2.30.2

