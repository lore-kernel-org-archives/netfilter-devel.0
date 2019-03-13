Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5C8C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859772147C
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:21:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u/BfbIDE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfCMIVF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:21:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37102 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfCMIVE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 04:21:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id s22so849833pfh.4
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2019 01:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DBwNgKjpHJxBNMQjQuhSfSVVBPGWgb4iShoG+anTEEk=;
        b=u/BfbIDEyd3asR5OgJDqMnhc8fxmJi4WWDMidnaCtSRzhh6DOn0REXxN/G9x0ARDL7
         /rjmY8GAnPoQpqdNPPPR5wXG5dB+kEKvPe2RDbTfA8VH1KJvNTSmcYOo3CNwtiV9WtuF
         eymfcrtggf2v61AYM+AsQYGzbbBaPIbU3FmRbQd+F+DM8yimyxG4nSQIjQyaZFk1PHuU
         Yo5Xgq7SiPBPibZIR0wy7/c54ozCPvuI2pf3icFPpYi9QAxaKa8/ycbNSZ9keB85fy/7
         53QbiCFBYQ23jJCiLZY7KE3CjRlDB/fz8/3Epwh1sTjuO/rCG2LEg8xotRvqu/Ju4yLH
         kbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DBwNgKjpHJxBNMQjQuhSfSVVBPGWgb4iShoG+anTEEk=;
        b=bN69wuvXV89id7I+7+bQKhnl2XbAStqDj2dZEm7ekxHCoW1bIMvIlgJpmnx3teHWoY
         ts983FU0Jote7+F3CTBb/amcNfBOGn+lvKVDnnSO3FTQv+/IuN/St/q0oIpJ9wXmnS4n
         LzH4F9qwIZHOe3bmkNrD2d5i24eZmCKcuTH3K16aMjw1gY6vOeHR3sKd5t5KcDJVh1jy
         eCpSNFFvepEiQUlZD3Nn2vHPV22e72fqinY3/RXED9EOpnqO2WeEmnYYwn9bu1Q19yvj
         WeEIrFtpsl0hMcZ8DFTHC7ZtYN4td25T+A6PqEn9M6YD+ZerYLwxSVxkmrQRZ7m2aS/t
         IQcA==
X-Gm-Message-State: APjAAAUkqUaohUjaNPTw7U5/y2T9zRbiS5l3RI+NEMye03ECs0ZpKAjL
        yhqA6uSsdL8tfS34Tyv+4qg=
X-Google-Smtp-Source: APXvYqzkgH7drcdAjZ4VAZ7NcVOG7qAVpTSr480smY3il3gdP9R7yCw8bee4vrOP9Y7c84BIBDy/3w==
X-Received: by 2002:a65:6654:: with SMTP id z20mr38308747pgv.390.1552465264126;
        Wed, 13 Mar 2019 01:21:04 -0700 (PDT)
Received: from localhost ([124.206.234.161])
        by smtp.gmail.com with ESMTPSA id v15sm17694973pfa.75.2019.03.13.01.21.02
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 13 Mar 2019 01:21:03 -0700 (PDT)
From:   xiao ruizhu <katrina.xiaorz@gmail.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
Cc:     xiao ruizhu <katrina.xiaorz@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_sip: fix rtcp expectation clash
Date:   Wed, 13 Mar 2019 16:24:10 +0800
Message-Id: <1552465450-21583-1-git-send-email-katrina.xiaorz@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An unexpected RTCP expectation clash happens in the following scenario.

           |      INVITE SDP (g711A g739 telephone-event)      |
      5060 |<--------------------------------------------------|5060
           |                 100 Trying                        |
      5060 |-------------------------------------------------->|5060
  S        |  183 Session Progress SDP (g711A telephone-event) |
      5060 |-------------------------------------------------->|5060
  E        |                    PRACK                          |      C
     50601 |<--------------------------------------------------|5060
  R        |                  200 OK (PRACK)                   |      P
     50601 |-------------------------------------------------->|5060
  V        |                  200 OK (INVITE)                  |      E
      5060 |-------------------------------------------------->|5060
  E        |                      ACK                          |
     50601 |<--------------------------------------------------|5060
  R        |                                                   |
           |<------------------ RTP stream ------------------->|
           |                                                   |
           |                 INVITE SDP (t38)                  |
     50601 |-------------------------------------------------->|5060

With a certain configuration in the CPE, SIP messages "183 with SDP" and
"re-INVITE with SDP t38" in the scenario will trigger the ALG to create
expectations for RTP and RTCP.

It is okay to create RTP&RTCP expectations for "183", whose master
connection source port is 5060, and destination port is 5060.

In this "183" message, port in Contact header changes to 50601 (from the
original 5060). So the following requests e.g. PRACK are sent to port
50601. It has a different master connection (let call 2nd master
connection) from the original INVITE (let call 1st master connection) due
to the port difference.

When "re-INVITE with SDP t38" arrives to create RTP&RTCP expectations,
current ALG implementation will firstly check whether there is a RTP
expectation with the same tuples already exists for a different master
connection. If yes, it will skip RTP&RTCP expects creation; otherwise it
will create a new RTP&RTCP expectation pairs.

In the scenario above, there is RTP stream but no RTCP stream for the 1st
master connection, so the RTP expectation created upon "183" is cleared,
and RTCP expectation created for the 1st master connection retains.

Basing on current ALG implementation, it only checks RTP expectation
existence but not for RTCP. So when "re-INVITE with SDP t38" arrives, it
will continue to create a new RTP&RTCP expectation pairs for the 2nd master
connection, which will result in a detection of expectation clash for RTCP
(same tuples and different master), and then a failure in processing of
that re-INVITE.

The fixing here is to check both RTP and RTCP expectation existence before
creation. When there is an old expectation with same tuples for a different
master, release the old expectation. Then a new one will be created for the
current master.

Signed-off-by: xiao ruizhu <katrina.xiaorz@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b..0771ea0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -799,6 +799,20 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
 	return 1;
 }
 
+static void release_conflicting_expect(const struct nf_conn *ct,
+				       const struct nf_conntrack_expect *expect,
+				       const enum sip_expectation_classes class)
+{
+	struct nf_conntrack_expect *exp;
+	struct net *net = nf_ct_net(ct);
+
+	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);
+	if (exp && exp->master != ct &&
+	    nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
+	    exp->class == class)
+		nf_ct_unexpect_related(exp);
+}
+
 static int refresh_signalling_expectation(struct nf_conn *ct,
 					  union nf_inet_addr *addr,
 					  u8 proto, __be16 port,
@@ -980,6 +994,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 				       datalen, rtp_exp, rtcp_exp,
 				       mediaoff, medialen, daddr);
 	else {
+		release_conflicting_expect(ct, rtp_exp, class);
+		release_conflicting_expect(ct, rtcp_exp, class);
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
-- 
1.9.1

