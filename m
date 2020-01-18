Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D153C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 12:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED31B24656
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 12:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgARMKy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 07:10:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:37886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgARMKy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 07:10:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AF8DEB2E3;
        Sat, 18 Jan 2020 12:10:52 +0000 (UTC)
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 9E1751E435; Sat, 18 Jan 2020 13:10:50 +0100 (CET)
Date:   Sat, 18 Jan 2020 13:10:50 +0100
From:   Jiri Wiesner <jwiesner@suse.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH nf] netfilter: conntrack: sctp: use distinct states for new
 SCTP connections
Message-ID: <20200118121050.GA22909@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The netlink notifications triggered by the INIT and INIT_ACK chunks
for a tracked SCTP association do not include protocol information
for the corresponding connection - SCTP state and verification tags
for the original and reply direction are missing. Since the connection
tracking implementation allows user space programs to receive
notifications about a connection and then create a new connection
based on the values received in a notification, it makes sense that
INIT and INIT_ACK notifications should contain the SCTP state
and verification tags available at the time when a notification
is sent. The missing verification tags cause a newly created
netfilter connection to fail to verify the tags of SCTP packets
when this connection has been created from the values previously
received in an INIT or INIT_ACK notification.

A PROTOINFO event is cached in sctp_packet() when the state
of a connection changes. The CLOSED and COOKIE_WAIT state will
be used for connections that have seen an INIT and INIT_ACK chunk,
respectively. The distinct states will cause a connection state
change in sctp_packet().

Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0399ae8f1188..4f897b14b606 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -114,7 +114,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sCW, sCW, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
 /* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
 /* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
 /* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
@@ -130,7 +130,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 /*	REPLY	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
 /* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
 /* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
 /* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
 /* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
@@ -316,7 +316,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
-		ct->proto.sctp.state = new_state;
+		ct->proto.sctp.state = SCTP_CONNTRACK_NONE;
 	}
 
 	return true;
-- 
2.16.4

