Return-Path: <SRS0=Jws3=UK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC10C43218
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jun 2019 05:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3383120665
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jun 2019 05:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgkiM3gD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbfFKFVK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 01:21:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33876 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391044AbfFKFVJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 01:21:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id p10so409939pgn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 22:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ujY9/8XoR3Iv8EGTPSuBKb7R1LeiLsEc5bl2RvuZ4BY=;
        b=NgkiM3gD1NvshlhpVHLt40DIThLy6KUEnYo9htbLkFXpHM8cEI6IwDRjmVsGbSJH77
         4Lx6BExG4OKTS2H9I9wni2Lv8ZsrmkrN+tQ6e0dq4chLzGfQK1aN3obcnkwp1qwb8tbB
         H5zj1Qu1oiNCLuuG25UrPuNGQcc7B+Mx8GWhhxlP2rUOnMXHbXQhEOf/jg47Xy3y7KGE
         PBoq+fjbRYOHyvGRwW1HonoJ/A1vhVBHmkkj7FywNC2aT3GKEQNbKajtm1CDBe0B5SWm
         OJuij9c2StM/Vg2WKckyfHLljnhc0tpQBPxWU2MbNceJgHqsXQIPH6iUfp7M4LWPdTFJ
         SZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ujY9/8XoR3Iv8EGTPSuBKb7R1LeiLsEc5bl2RvuZ4BY=;
        b=uabdqxhB061WEMSy49cYFbRZ03LOwBRqhp01jnTP6aor7MENfq05MwgD5xhpKs8E4T
         0NCnoBowlSkWo+j+u135MRMHmrmPbM4HhMJeOFUHbIWkJxxHTC7AiaLxhNAFoj+9VawO
         jnWqv3oWnQa7NWxtjUTduYTMcfNmkz3Q/1qK0Pq05Isa/1Nbwb4X9ijt63iN7aP/E5mt
         gaE3Rq8wqENczAouLSrnQlvJGgaORrwt2OWZ/pkW5ihjIs7aRS1Vv9AUxho28+4K5Jc5
         0+QBDBjtRQsNtj/Eq2qQQXLRW4JJG6ZZ39+KfgTQAXgIZdiBtWsDdH6MTP8sbZ4KWUDt
         tAIQ==
X-Gm-Message-State: APjAAAUinHvyMY+D3ShloTuEhP8EbAN4SqQRn6VyhKINKEXtnOngO0kY
        1y1+KKHfy/Nfvb8NQXhQ4Zo=
X-Google-Smtp-Source: APXvYqxY+nusl5BudzeuVolAtLOeTIwL1yxEHBp0Aj7r/Pqlu3cfEtKn9AeenWivHSZpDdGtLo41sg==
X-Received: by 2002:a17:90a:c504:: with SMTP id k4mr16757018pjt.104.1560230468304;
        Mon, 10 Jun 2019 22:21:08 -0700 (PDT)
Received: from localhost ([124.206.234.249])
        by smtp.gmail.com with ESMTPSA id y133sm13539013pfb.28.2019.06.10.22.21.05
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 10 Jun 2019 22:21:06 -0700 (PDT)
From:   xiao ruizhu <katrina.xiaorz@gmail.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, alin.nastac@gmail.com,
        netfilter-devel@vger.kernel.org
Cc:     xiao ruizhu <katrina.xiaorz@gmail.com>
Subject: [PATCH v6] netfilter: nf_conntrack_sip: fix expectation clash
Date:   Tue, 11 Jun 2019 13:20:59 +0800
Message-Id: <1560230459-3911-1-git-send-email-katrina.xiaorz@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20190610174543.chflcq4udmpqitnu@salvia>
References: <20190610174543.chflcq4udmpqitnu@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> On Tue, Jun 11, 2019 at 01:45AM, Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:

> Looks good, only one more little change and we go.

>> On Tue, Jun 04, 2019 at 04:34:23PM +0800, xiao ruizhu wrote:
>> [...]
>> @@ -420,8 +421,10 @@ static inline int __nf_ct_expect_check(struct
>> nf_conntrack_expect *expect)
>>       }
>>       h = nf_ct_expect_dst_hash(net, &expect->tuple);
>>       hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
>> -           if (expect_matches(i, expect)) {
>> -                   if (i->class != expect->class)
>> +           if ((flags & NF_CT_EXP_F_CHECK_MASTER ? true : i->master ==
>> +               expect->master) && expect_matches(i, expect)) {
> 
> Could you add a function for this? eg.
> 
> static bool nf_ct_check_master(struct nf_conntrack_expect *a,
>                                struct nf_conntrack_expect *b)
> {
>         if (flags & NF_CT_EXP_F_CHECK_MASTER)
>                 return true;
> 
>         return i->master == expect->master &&
>                expect_matches(i, expect);
> }

> Was that the intention?

> I'm a bit confused with the use of the single statement branch above.

Hi Pablo,

Thanks for your notice.
Sorry, I made a mistake here. I meant to move the checking of master from
expect_matches() to __nf_ct_expect_check(), where we will use the flag
NF_CT_EXP_F_CHECK_MASTER to decide whether masters also need to be checked
or not for matching.
That is, the intention is to change expect_matches() from the original
{
        return a->master == b->master &&
               nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
               nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
               net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
               nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
}
to
{
        return nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
               nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
               net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
               nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
}
And in __nf_ct_expect_check(), if the expect is for SIP helper (i.e. with
NF_CT_EXP_F_CHECK_MASTER set), the master will not be checked, only the
items in new expect_matches() will be used for matching check; otherwise,
masters will also be checked. That's the purpose of (flags &
NF_CT_EXP_F_CHECK_MASTER ? true : i->master == expect->master).

However, the modification of expect_matches() was missed to merge into the
patch submitted for review, and causes the confusion. I'm sorry for that.

The modification of expect_matches() is added to patch v6, and please find
it below. Thanks.


When conntracks change during a dialog, SDP messages may be sent from
different conntracks to establish expects with identical tuples. In this
case expects conflict may be detected for the 2nd SDP message and end up
with a process failure.

The fixing here is to reuse an existing expect who has the same tuple for a
different conntrack if any.

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
Changes in v6:
- add the modification of expect_matches().
Changes in v5:
- take Pablo's proposal to use a flag in order not to change behavior of
  the other existing helpers.
Changes in v4:
- take Pablo's proposal to handle checking in __nf_ct_expect_check().
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
 include/net/netfilter/nf_conntrack_expect.h | 12 +++++++++---
 net/ipv4/netfilter/nf_nat_h323.c            | 12 ++++++------
 net/netfilter/ipvs/ip_vs_nfct.c             |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  2 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_expect.c         | 16 +++++++++-------
 net/netfilter/nf_conntrack_ftp.c            |  2 +-
 net/netfilter/nf_conntrack_h323_main.c      | 18 +++++++++---------
 net/netfilter/nf_conntrack_irc.c            |  2 +-
 net/netfilter/nf_conntrack_netlink.c        |  4 ++--
 net/netfilter/nf_conntrack_pptp.c           |  4 ++--
 net/netfilter/nf_conntrack_sane.c           |  2 +-
 net/netfilter/nf_conntrack_sip.c            | 10 +++++++---
 net/netfilter/nf_conntrack_tftp.c           |  2 +-
 net/netfilter/nf_nat_amanda.c               |  2 +-
 net/netfilter/nf_nat_ftp.c                  |  2 +-
 net/netfilter/nf_nat_irc.c                  |  2 +-
 net/netfilter/nf_nat_sip.c                  |  8 +++++---
 net/netfilter/nf_nat_tftp.c                 |  2 +-
 19 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 93ce6b0..6da901e 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -76,6 +76,11 @@ struct nf_conntrack_expect_policy {
 #define NF_CT_EXPECT_CLASS_DEFAULT	0
 #define NF_CT_EXPECT_MAX_CNT		255
 
+/* Allow to reuse expectations with the same tuples from different master
+ * conntracks.
+ */
+#define NF_CT_EXP_F_CHECK_MASTER	0x1
+
 int nf_conntrack_expect_pernet_init(struct net *net);
 void nf_conntrack_expect_pernet_fini(struct net *net);
 
@@ -122,10 +127,11 @@ void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
-				u32 portid, int report);
-static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+				u32 portid, int report, unsigned int flags);
+static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
+				       unsigned int flags)
 {
-	return nf_ct_expect_related_report(expect, 0, 0);
+	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
 #endif /*_NF_CONNTRACK_EXPECT_H*/
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 7875c98..f06709a 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -222,11 +222,11 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		ret = nf_ct_expect_related(rtp_exp);
+		ret = nf_ct_expect_related(rtp_exp, 0);
 		if (ret == 0) {
 			rtcp_exp->tuple.dst.u.udp.port =
 			    htons(nated_port + 1);
-			ret = nf_ct_expect_related(rtcp_exp);
+			ret = nf_ct_expect_related(rtcp_exp, 0);
 			if (ret == 0)
 				break;
 			else if (ret == -EBUSY) {
@@ -297,7 +297,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -353,7 +353,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -445,7 +445,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -538,7 +538,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index eb8b9c8..45bb5a3 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -247,7 +247,7 @@ void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 
 	IP_VS_DBG_BUF(7, "%s: ct=%p, expect tuple=" FMT_TUPLE "\n",
 		      __func__, ct, ARG_TUPLE(&exp->tuple));
-	nf_ct_expect_related(exp);
+	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 }
 EXPORT_SYMBOL(ip_vs_nfct_expect_related);
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index dbec6fc..5d2f72b 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -163,7 +163,7 @@ static int amanda_help(struct sk_buff *skb,
 		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_amanda(skb, ctinfo, protoff,
 					    off - dataoff, len, exp);
-		else if (nf_ct_expect_related(exp) != 0) {
+		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		}
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 5423b19..1563c86 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -67,7 +67,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	exp->helper               = NULL;
 
-	nf_ct_expect_related(exp);
+	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
 	nf_ct_refresh(ct, skb, timeout * HZ);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 59c1880..adc26d7 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -252,8 +252,7 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 static inline int expect_matches(const struct nf_conntrack_expect *a,
 				 const struct nf_conntrack_expect *b)
 {
-	return a->master == b->master &&
-	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
+	return nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
 	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
 	       net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
 	       nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
@@ -402,7 +401,8 @@ static void evict_oldest_expect(struct nf_conn *master,
 		nf_ct_remove_expect(last);
 }
 
-static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
+static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
+				       unsigned int flags)
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
@@ -420,8 +420,10 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	}
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
-		if (expect_matches(i, expect)) {
-			if (i->class != expect->class)
+		if ((flags & NF_CT_EXP_F_CHECK_MASTER ? true : i->master ==
+		    expect->master) && expect_matches(i, expect)) {
+			if (i->class != expect->class ||
+			    i->master != expect->master)
 				return -EALREADY;
 
 			if (nf_ct_remove_expect(i))
@@ -456,12 +458,12 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 }
 
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
-				u32 portid, int report)
+				u32 portid, int report, unsigned int flags)
 {
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	ret = __nf_ct_expect_check(expect);
+	ret = __nf_ct_expect_check(expect, flags);
 	if (ret < 0)
 		goto out;
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 32aeac1..1578bfa 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -528,7 +528,7 @@ static int help(struct sk_buff *skb,
 				 protoff, matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (nf_ct_expect_related(exp) != 0) {
+		if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		} else
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 12de403..207024c 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -306,8 +306,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_rtp_rtcp(skb, ct, ctinfo, protoff, data, dataoff,
 				   taddr, port, rtp_port, rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(rtp_exp) == 0) {
-			if (nf_ct_expect_related(rtcp_exp) == 0) {
+		if (nf_ct_expect_related(rtp_exp, 0) == 0) {
+			if (nf_ct_expect_related(rtcp_exp, 0) == 0) {
 				pr_debug("nf_ct_h323: expect RTP ");
 				nf_ct_dump_tuple(&rtp_exp->tuple);
 				pr_debug("nf_ct_h323: expect RTCP ");
@@ -365,7 +365,7 @@ static int expect_t120(struct sk_buff *skb,
 		ret = nat_t120(skb, ct, ctinfo, protoff, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_h323: expect T.120 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -702,7 +702,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_h245(skb, ct, ctinfo, protoff, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_q931: expect H.245 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -826,7 +826,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 					 protoff, data, dataoff,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_q931: expect Call Forwarding ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -1285,7 +1285,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_q931(skb, ct, ctinfo, protoff, data,
 			       taddr, i, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_ras: expect Q.931 ");
 			nf_ct_dump_tuple(&exp->tuple);
 
@@ -1350,7 +1350,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 			  IPPROTO_UDP, NULL, &port);
 	exp->helper = nf_conntrack_helper_ras;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
@@ -1562,7 +1562,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
@@ -1616,7 +1616,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 79e5014..92a118f 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -217,7 +217,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 						 addr_beg_p - ib_ptr,
 						 addr_end_p - addr_beg_p,
 						 exp);
-			else if (nf_ct_expect_related(exp) != 0) {
+			else if (nf_ct_expect_related(exp, 0) != 0) {
 				nf_ct_helper_log(skb, ct,
 						 "cannot add expectation");
 				ret = NF_DROP;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7db79c1..56d3ca1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2615,7 +2615,7 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
-	err = nf_ct_expect_related_report(exp, portid, report);
+	err = nf_ct_expect_related_report(exp, portid, report, 0);
 	nf_ct_expect_put(exp);
 	return err;
 }
@@ -3366,7 +3366,7 @@ ctnetlink_create_expect(struct net *net,
 		goto err_rcu;
 	}
 
-	err = nf_ct_expect_related_report(exp, portid, report);
+	err = nf_ct_expect_related_report(exp, portid, report, 0);
 	nf_ct_expect_put(exp);
 err_rcu:
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 976f1dc..0d44a03 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -233,9 +233,9 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
 	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
 		nf_nat_pptp_exp_gre(exp_orig, exp_reply);
-	if (nf_ct_expect_related(exp_orig) != 0)
+	if (nf_ct_expect_related(exp_orig, 0) != 0)
 		goto out_put_both;
-	if (nf_ct_expect_related(exp_reply) != 0)
+	if (nf_ct_expect_related(exp_reply, 0) != 0)
 		goto out_unexpect_orig;
 
 	/* Add GRE keymap entries */
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 8330664..90fade9 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -156,7 +156,7 @@ static int help(struct sk_buff *skb,
 	nf_ct_dump_tuple(&exp->tuple);
 
 	/* Can't expect this?  Best to drop packet now. */
-	if (nf_ct_expect_related(exp) != 0) {
+	if (nf_ct_expect_related(exp, 0) != 0) {
 		nf_ct_helper_log(skb, ct, "cannot add expectation");
 		ret = NF_DROP;
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c30c883..f9e6d1f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -980,11 +980,15 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
+		 * It also works in the case that SDP messages are sent with
+		 * identical expect tuples but for different master conntracks.
 		 */
-		int errp = nf_ct_expect_related(rtp_exp);
+		int errp = nf_ct_expect_related(rtp_exp,
+						NF_CT_EXP_F_CHECK_MASTER);
 
 		if (errp == 0 || errp == -EALREADY) {
-			int errcp = nf_ct_expect_related(rtcp_exp);
+			int errcp = nf_ct_expect_related(rtcp_exp,
+						NF_CT_EXP_F_CHECK_MASTER);
 
 			if (errcp == 0 || errcp == -EALREADY)
 				ret = NF_ACCEPT;
@@ -1299,7 +1303,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		ret = hooks->expect(skb, protoff, dataoff, dptr, datalen,
 				    exp, matchoff, matchlen);
 	else {
-		if (nf_ct_expect_related(exp) != 0) {
+		if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		} else
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 6977cb9..2a5931d 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -80,7 +80,7 @@ static int tftp_help(struct sk_buff *skb,
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_tftp(skb, ctinfo, exp);
-		else if (nf_ct_expect_related(exp) != 0) {
+		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		}
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 4e59416..63a8d0e 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -52,7 +52,7 @@ static unsigned int help(struct sk_buff *skb,
 		int res;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		res = nf_ct_expect_related(exp);
+		res = nf_ct_expect_related(exp, 0);
 		if (res == 0)
 			break;
 		else if (res != -EBUSY) {
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 0ea6b1b..620fad9e4 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -94,7 +94,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index d87cbe5..0d83eed 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -57,7 +57,7 @@ static unsigned int help(struct sk_buff *skb,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 464387b..bce426b 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -417,7 +417,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, NF_CT_EXP_F_CHECK_MASTER);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -610,7 +610,8 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(rtp_exp);
+		ret = nf_ct_expect_related(rtp_exp,
+					   NF_CT_EXP_F_CHECK_MASTER);
 		if (ret == -EBUSY)
 			continue;
 		else if (ret < 0) {
@@ -618,7 +619,8 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 			break;
 		}
 		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
-		ret = nf_ct_expect_related(rtcp_exp);
+		ret = nf_ct_expect_related(rtcp_exp,
+					   NF_CT_EXP_F_CHECK_MASTER);
 		if (ret == 0)
 			break;
 		else if (ret == -EBUSY) {
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index e633b38..2218890 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -33,7 +33,7 @@ static unsigned int help(struct sk_buff *skb,
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
-	if (nf_ct_expect_related(exp) != 0) {
+	if (nf_ct_expect_related(exp, 0) != 0) {
 		nf_ct_helper_log(skb, exp->master, "cannot add expectation");
 		return NF_DROP;
 	}
-- 
2.7.4

