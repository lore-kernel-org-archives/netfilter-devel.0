Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298CDC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 03:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC2A20854
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 03:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1VlkMgU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfCND0M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 23:26:12 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:37485 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfCND0M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 23:26:12 -0400
Received: by mail-pf1-f169.google.com with SMTP id s22so2862473pfh.4
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2019 20:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Oo93hlr/FmWERkmE4Zf4+cQhNKerLS/s8gUSd8pzdUU=;
        b=f1VlkMgUYVE4E113be4/L5VYy3n/1R5IwS6n8tx7S58oD1lNWZACPpHUgDefAVGB0S
         NQtuGed4F09v1FC98A15oEFIpqd5iB6BtWIdqyYS58hcD+YVQJRdSiI6lT3Numo7syir
         HVXTQ1gZ8uqfR9+7UENGPQnz9Lu33/J2+PK20ga9w8TnzJ6C3AZrhcEwPoero6sqLyWV
         zKCGc22Z9FyLNoqMVdnkJQD7WNfLezjDU+5HrSackDSu/AqJrqXJd+pecYPnkq2cSROs
         QXo41JLVVPbKWxRDG8zdROiNOFAebnhnUj5YMRnCMjZUSmIG8RcW2serH8aYmu1BfZeI
         Zj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Oo93hlr/FmWERkmE4Zf4+cQhNKerLS/s8gUSd8pzdUU=;
        b=UPq4GFWS/hLt8IdDIsnp/is5GSLEb4l1D7FAQw3v4v9B+pXNa1KZ5LP4uKXz9y/4hD
         XBegXxvnZLOvBd6LySWQ0vJZuXQKf8aX9vgrKGbnQSGH56VRLCuqaWgx+rgLEt11jMVz
         gEJRRtwNG4fsPGb9ePADnX8xkGb/v/UeNEmBiji4iIceu2tO8JBw0kglP519L1rOmo0i
         5cpZtSkJfD6tZ7w/o+MzDwK8rE6lS54kQvlrKLHY7IAFNhLHcHpTGreVRDY56KWCdvvW
         excXqqrBxoFNd7yoQh0GLVZ0E0MDMe92RCt6WihIOPnY5eYGTbYkYR8Nsft71ba3UiKa
         HCFQ==
X-Gm-Message-State: APjAAAURX+fEhcOPKpQpNJrUH645MeoeoRH68v5T1DqeoBH6UWejrJln
        MhZfWsKdArb8ouQy66X7S98=
X-Google-Smtp-Source: APXvYqxoxzQZC9c4uc2PKwE639cWbEac+f+1l0JzZ+bls/tMedjO5PVLWZA/WpbZIngKBf2Qdcz8tQ==
X-Received: by 2002:aa7:8491:: with SMTP id u17mr11177745pfn.128.1552533971069;
        Wed, 13 Mar 2019 20:26:11 -0700 (PDT)
Received: from localhost ([124.206.234.161])
        by smtp.gmail.com with ESMTPSA id p2sm28295252pfi.95.2019.03.13.20.26.09
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 13 Mar 2019 20:26:10 -0700 (PDT)
From:   xiao ruizhu <katrina.xiaorz@gmail.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
Cc:     xiao ruizhu <katrina.xiaorz@gmail.com>
Subject: [PATCH v2] netfilter: nf_conntrack_sip: fix rtcp expectation clash
Date:   Thu, 14 Mar 2019 11:28:44 +0800
Message-Id: <1552534124-31407-1-git-send-email-katrina.xiaorz@gmail.com>
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
Changes in v2:
- add a comment on release_conflicting_expect functionality
- move local variable errp to the beginning of the block
v1:
- original patch
---
 net/netfilter/nf_conntrack_sip.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b..4398a53 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -799,6 +799,23 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
 	return 1;
 }
 
+/* Remove conflicting expect created by sip helper for another master
+ * conntrack, most likely related to this master.
+ */
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
@@ -980,11 +997,16 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 				       datalen, rtp_exp, rtcp_exp,
 				       mediaoff, medialen, daddr);
 	else {
+		int errp;
+
+		release_conflicting_expect(ct, rtp_exp, class);
+		release_conflicting_expect(ct, rtcp_exp, class);
+
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
 		 */
-		int errp = nf_ct_expect_related(rtp_exp);
+		errp = nf_ct_expect_related(rtp_exp);
 
 		if (errp == 0 || errp == -EALREADY) {
 			int errcp = nf_ct_expect_related(rtcp_exp);
-- 
1.9.1

