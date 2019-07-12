Return-Path: <SRS0=tLP1=VJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08375C742B3
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD74208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Fuy4KgQ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfGLKpb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:45:31 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46886 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfGLKpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 06:45:31 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9579B1A0EB2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2019 03:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1562928330; bh=7J1ARePg3G/TkG4N80nQYtFG54P8hWhwcX6O0uWLkos=;
        h=From:To:Cc:Subject:Date:From;
        b=Fuy4KgQ2dNykiXRnRuBQWFjUKWdmIDNkm6bC3IYq83ZN/ttzuV2KjIskkbrVXbvQ3
         igJeJeCczeSV13R82fR2Oge4v92Z88sXC+SQiRclWqgDSEfo1j6t1LmZDC5KR/pWuY
         4WGAgRISvMbgVjdkKW4eZF1//INlbeXIVNNJTt6M=
X-Riseup-User-ID: BF7265C576101C8A1C83CAAAFB91BFF046F1E953B065E0E44101D16C3085E7F4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 8BCE0120578;
        Fri, 12 Jul 2019 03:45:28 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf v2] netfilter: synproxy: fix rst sequence number mismatch
Date:   Fri, 12 Jul 2019 12:45:14 +0200
Message-Id: <20190712104513.11683-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
4023580551, win 64240, options [mss 1460,sackOK,TS val 2149563785 ecr
0,nop,wscale 7], length 0
14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
727560212, ack 4023580552, win 0, options [mss 1460,sackOK,TS val 355031 ecr
2149563785,nop,wscale 7], length 0
14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1, win
502, options [nop,nop,TS val 2149563785 ecr 355031], length 0
14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.], seq
3567407084, ack 1, win 0, length 0
14:51:00.231196 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1, win
502, options [nop,nop,TS val 2149563992 ecr 355031], length 0
14:51:00.647911 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1, win
502, options [nop,nop,TS val 2149564408 ecr 355031], length 0
14:51:01.474395 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1, win
502, options [nop,nop,TS val 2149565235 ecr 355031], length 0

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6676a3842a0c..b0930d4aba22 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -687,7 +687,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
@@ -1111,7 +1111,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
-- 
2.20.1

