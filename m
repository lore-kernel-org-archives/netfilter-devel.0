Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC30C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 08:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 909C820651
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 08:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XoNAkjMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfDOId2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:33:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44972 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOId2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 04:33:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id i2so8209224pgj.11
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 01:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AuT3fVE8P9G0gLYwub593Ko2o/tEFAQBKLEEDrUGWhM=;
        b=XoNAkjMOVec8aGBWL0y88ReLQKE7Dl0Rud6/SyhUeq1UVycwwvcK+WPRqL6JFgrkmj
         EgsRSV8ewqbqWvo+NVMOdbPIhLgjPsQkQGWroT5Gw4Z55I7RWNLmj43wRIampWDqLFgH
         fDofGCZXRoXNEd4NrN0YO5xXhRq8wTfoeNwr24ph+8cjQGzXKfUIR7Ny8eVL40aUDXyO
         5qBIhtCHL2KvilFAXNj/PwvzM2hqRqfyZ3oQSwDyUgQPoiBh0tzGEUlC9ojehEVztSjq
         L3yaQlGiBPA8hdFzAGoGsqq9rOGLb1tFF30yQG+EbMlSUiICcuXYJXbrCI3rR/znlT/8
         Pr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AuT3fVE8P9G0gLYwub593Ko2o/tEFAQBKLEEDrUGWhM=;
        b=k9z5kjlZKIcWJDitUhAOM6Es5MTqSyraO8OkqabGodF58Ctyym2RwJN1mgQEXiWZY7
         m922Bzxarr5kayowcIop87FmJbUTWjL/4kYguxypFGyNP3BWe+NqX0zBAUswf9DjyN64
         IQYYZeSph/MIPoAsC7+nmQ/Woyr3h7N5kEORmczfipqrDHNegQHByfHLoiPKuXxZcc5L
         rXi4m7O5IVkSiHdRp99Lpfoea9Sc8z+UQHEM3HREzXjBqioyrckJK+5qmND7xCHWRTAZ
         ghJQQQMt5sgZFIqjIJ+kg2Ny4GsyOKaBrJToA4F9ZsRXwnF2v3yJ3jUH64VOOJ/NYu2E
         MM1g==
X-Gm-Message-State: APjAAAV1tYUkeVpser8evGgQHJ4bUbOqko1IkawASAtl1O+Ua6FAJgBH
        N57uZErS8oToHCR7zdKNimy/TREL
X-Google-Smtp-Source: APXvYqyQZUg1Hri0oeZ68ZQ+/30zsZz7LQeDQhhP5sJ5ac7ocsbCw+JERDu+kfbUF7q/iQfyF9lKmw==
X-Received: by 2002:a62:2587:: with SMTP id l129mr74333062pfl.151.1555317207301;
        Mon, 15 Apr 2019 01:33:27 -0700 (PDT)
Received: from localhost ([124.206.234.206])
        by smtp.gmail.com with ESMTPSA id f87sm101373073pff.56.2019.04.15.01.33.25
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 15 Apr 2019 01:33:26 -0700 (PDT)
From:   xiao ruizhu <katrina.xiaorz@gmail.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, alin.nastac@gmail.com,
        netfilter-devel@vger.kernel.org
Cc:     xiao ruizhu <katrina.xiaorz@gmail.com>
Subject: [PATCH v3] netfilter: nf_conntrack_sip: fix expectation clash
Date:   Mon, 15 Apr 2019 16:33:00 +0800
Message-Id: <1555317180-3074-1-git-send-email-katrina.xiaorz@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20190321105607.dwj3wtxe32cenglo@salvia>
References: <20190321105607.dwj3wtxe32cenglo@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thanks a lot for your feedback.

There are some changes in the implementation and please find my answers and
the patch v3 below.

>
>
>On Thu, Mar 21, 2019 at 06:56PM, Pablo Neira Ayuso <pablo@netfilter.org>
>wrote:
>Hi,
>...
>> +/* Remove conflicting expect created by sip helper for another master
>> + * conntrack, most likely related to this master.
>
>Hm, this comment is confusing. Code here that checks that master is
>not the same, however, this suggests this is likely the same master,
>however, it is related to a different master?

Yes, I meant it is related to a different master. The function and comments
are changed and please find them in the new patch below.

>
>We need to hold the nf_conntrack_expect_lock here, two CPUs may race
>to destroy this expectation, unlikely but possible still.

Thanks for the reminding. Ok, will hold nf_conntrack_expect_lock as
proposed.

>
>> +     exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);
>> +     if (exp && exp->master != ct &&
>> +         nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
>> +         exp->class == class)
>
>I'd suggest you place this into a function that we can reuse from
>set_expected_rtp_rtcp(), eg.
>
>static bool
>nf_ct_sip_expect_exists(const struct nf_conntrack_expect *expect,
>                        const struct nf_conn *ct)
>{
>        return (exp && exp->master != ct &&
>                nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
>                exp->class == class);
>}
>
>So we can reuse it from L927 in set_expected_rtp_rtcp()?

Ok, it will be placed into a function as proposed.

>
>> +             nf_ct_unexpect_related(exp);
>
>Use nf_ct_remove_expect() instead of nf_ct_unexpect_related(), while
>holding the spinlock.

The implementation changes to reuse the expect but not to remove and
recreate, so the call here will be removed.

>
>And a more general question: Given the scenario you describe is quite
>specific, is it not possible to handle this case from
>process_sip_response() -> process_prack_response().
>

In this case the issue happens no matter there is PRACK or not.
Actually, this issue may happen when the master conntrack changes during a
dialog. So I think it is more of a generic issue and would be better to
keep the handling in set_expected_rtp_rtcp().
Please find the details blow. Thanks.

---
Hereunder is the patch v3
---
When conntracks change during a dialog, SDP messages may be sent from
different conntracks to establish expects with identical tuples. In this
case expects conflict may be detected for the 2nd SDP message and end up
with a process failure.

The fixing here is to check both RTP and RTCP expect existence before
creation. When there is an existing expect with the same tuples for a
different conntrack, reuse it.

Here are two scenarios for the case.

1)
         SERVER                   CPE

           |      INVITE SDP       |
      5060 |<----------------------|5060
           |      100 Trying       |
      5060 |---------------------->|5060
           |      183 SDP          |
      5060 |---------------------->|5060    ===> Conntrack 1
           |       PRACK           |
     50601 |<----------------------|5060
           |    200 OK (PRACK)     |
     50601 |---------------------->|5060
           |    200 OK (INVITE)    |
      5060 |---------------------->|5060
           |        ACK            |
     50601 |<----------------------|5060
           |                       |
           |<--- RTP stream ------>|
           |                       |
           |    INVITE SDP (t38)   |
     50601 |---------------------->|5060    ===> Conntrack 2

With a certain configuration in the CPE, SIP messages "183 with SDP" and
"re-INVITE with SDP t38" will go through the sip helper to create
expects for RTP and RTCP.

It is okay to create RTP and RTCP expects for "183", whose master
connection source port is 5060, and destination port is 5060.

In the "183" message, port in Contact header changes to 50601 (from the
original 5060). So the following requests e.g. PRACK and ACK are sent to
port 50601. It is a different conntrack (let call Conntrack 2) from the
original INVITE (let call Conntrack 1) due to the port difference.

In this example, after the call is established, there is RTP stream but no
RTCP stream for Conntrack 1, so the RTP expect created upon "183" is
cleared, and RTCP expect created for Conntrack 1 retains.

When "re-INVITE with SDP t38" arrives to create RTP&RTCP expects, current
ALG implementation will call nf_ct_expect_related() for RTP and RTCP. The
expects tuples are identical to those for Conntrack 1. RTP expect for
Conntrack 2 succeeds in creation as the one for Conntrack 1 has been
removed. RTCP expect for Conntrack 2 fails in creation because it has
idential tuples and 'conflict' with the one retained for Conntrack 1. And
then result in a failure in processing of the re-INVITE.

2)

    SERVER A                 CPE

       |      REGISTER     |
  5060 |<------------------| 5060  ==> CT1
       |       200         |
  5060 |------------------>| 5060
       |                   |
       |   INVITE SDP(1)   |
  5060 |<------------------| 5060
       | 300(multi choice) |
  5060 |------------------>| 5060                    SERVER B
       |       ACK         |
  5060 |<------------------| 5060
                                  |    INVITE SDP(2)    |
                             5060 |-------------------->| 5060  ==> CT2
                                  |       100           |
                             5060 |<--------------------| 5060
                                  | 200(contact changes)|
                             5060 |<--------------------| 5060
                                  |       ACK           |
                             5060 |-------------------->| 50601 ==> CT3
                                  |                     |
                                  |<--- RTP stream ---->|
                                  |                     |
                                  |       BYE           |
                             5060 |<--------------------| 50601
                                  |       200           |
                             5060 |-------------------->| 50601
       |   INVITE SDP(3)   |
  5060 |<------------------| 5060  ==> CT1

CPE sends an INVITE request(1) to Server A, and creates a RTP&RTCP expect
pair for this Conntrack 1 (CT1). Server A responds 300 to redirect to
Server B. The RTP&RTCP expect pairs created on CT1 are removed upon 300
response.

CPE sends the INVITE request(2) to Server B, and creates an expect pair
for the new conntrack (due to destination address difference), let call
CT2. Server B changes the port to 50601 in 200 OK response, and the
following requests ACK and BYE from CPE are sent to 50601. The call is
established. There is RTP stream and no RTCP stream. So RTP expect is
removed and RTCP expect for CT2 retains.

As BYE request is sent from port 50601, it is another conntrack, let call
CT3, different from CT2 due to the port difference. So the BYE request will
not remove the RTCP expect for CT2.

Then another outgoing call is made, with the same RTP port being used (not
definitely but possibly). CPE firstly sends the INVITE request(3) to Server
A, and tries to create a RTP&RTCP expect pairs for this CT1. In current ALG
implementation, the RTCP expect for CT1 fails in creation because it
'conflicts' with the residual one for CT2. As a result the INVITE request
fails to send.

Signed-off-by: xiao ruizhu <katrina.xiaorz@gmail.com>
---
Changes in v3:
- take Pablo's advice about the comments, nf_conntrack_expect_lock and
  nf_ct_sip_expect_exists()
- change the policy to reuse the exising expect(s) instead of removal then
  recreation, to avoid CPU cycle waste
Changes in v2:
- add a comment on release_conflicting_expect functionality
- move local variable errp to the beginning of the block
v1:
- original patch
---
 net/netfilter/nf_conntrack_sip.c | 45 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b..0e17c14 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -799,6 +799,31 @@ static int ct_sip_parse_sdp_addr(const struct nf_conn *ct, const char *dptr,
 	return 1;
 }
 
+static bool nf_ct_sip_expect_exists(const struct nf_conntrack_expect *expect,
+				    const struct nf_conn *ct,
+				    enum sip_expectation_classes class)
+{
+	return (expect && expect->master != ct &&
+		nfct_help(expect->master)->helper == nfct_help(ct)->helper &&
+		expect->class == class);
+}
+
+/* Look for an expect with identical tuple but for a different master. */
+static bool nf_ct_sip_expect_found(const struct nf_conntrack_expect *expect,
+				   const struct nf_conn *ct)
+{
+	struct nf_conntrack_expect *exp;
+	struct net *net = nf_ct_net(ct);
+	bool found = 0;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &expect->tuple);
+	found = nf_ct_sip_expect_exists(exp, ct, expect->class);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
+	return found;
+}
+
 static int refresh_signalling_expectation(struct nf_conn *ct,
 					  union nf_inet_addr *addr,
 					  u8 proto, __be16 port,
@@ -929,9 +954,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	do {
 		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
-		if (!exp || exp->master == ct ||
-		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
-		    exp->class != class)
+		if (!nf_ct_sip_expect_exists(exp, ct, class))
 			break;
 #ifdef CONFIG_NF_NAT_NEEDED
 		if (!direct_rtp &&
@@ -983,11 +1006,23 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
+		 * It also works in the case that SDP messages are sent with
+		 * identical expect tuples but for different master conntracks.
 		 */
-		int errp = nf_ct_expect_related(rtp_exp);
+		int errp;
+
+		if (nf_ct_sip_expect_found(rtp_exp, ct))
+			errp = -EALREADY;
+		else
+			errp = nf_ct_expect_related(rtp_exp);
 
 		if (errp == 0 || errp == -EALREADY) {
-			int errcp = nf_ct_expect_related(rtcp_exp);
+			int errcp;
+
+			if (nf_ct_sip_expect_found(rtcp_exp, ct))
+				errcp = -EALREADY;
+			else
+				errcp = nf_ct_expect_related(rtcp_exp);
 
 			if (errcp == 0 || errcp == -EALREADY)
 				ret = NF_ACCEPT;
-- 
1.9.1

