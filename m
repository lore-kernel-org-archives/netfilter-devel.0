Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593CDC04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 07:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 143A6206BF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 07:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7NdoPR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfEOHpu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 03:45:50 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35696 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfEOHpu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 03:45:50 -0400
Received: by mail-pl1-f181.google.com with SMTP id g5so930347plt.2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 00:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htiyIwNhRod9pNoUma8lNKsbznDmx0tWIRwQGVJsipI=;
        b=D7NdoPR19mNl9wH3U+edd92adlpupZ8AwJbn4zPpngHAbFxkZcWVSF+HJ18jdcAREn
         TrY1tYAkMDTBMTFWgl8xm7FJFo5UZ7ty4akSu2LrXUPytNDLkraQl/0b74wCzoBotAW/
         2OZW8pzg8Z3N/AOszxvrY9RS9C5/wiqdgTpK4v1x9aCLea50GetoMJ2tavIOuvVLWCKl
         ADAcvKnhhGtnkTn1++aacAgULplY8C2ftscPBKXAEqKbJOXq9wkV0T8vvPKJF9LWgdhd
         LZFT/0uciHW+AV8BYaG2QjnHkLd5WMxqYq0qKLYrcdCBquNXP+pFJSW3DJXIdhY+SA6q
         NSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htiyIwNhRod9pNoUma8lNKsbznDmx0tWIRwQGVJsipI=;
        b=biCE6dMw0jIypMFkWzUl9k2NF+lZN9AoErzu9+ffmmLLIuEloXMSKdze/eDI5V3xbV
         nZ4xQmXx2DS08ateicJSXjuBCxdNZrs/fQZpZxzTxx4wjWVYb26cNliOsS7cSAPM9yBQ
         GT3okvVgR+GGGktMJKHQxS+k3DJ8WMit4/zJ6/m7rbWL0KRg94WyMClRte6kYfQS3pCi
         OcXoJXQ8ZhcMVq5+Y3dJMfyrHoiDfWSccvCzn70YeGRGi+WUuhQOtYJIE8ywuLkXkBLq
         BJCe8sOotbjG/94cfPgXw+9sDz0UfDeNjLnq5GDG3RMRH2Lp1Hk6+wChtEc0lakEH3Gm
         5V7A==
X-Gm-Message-State: APjAAAXTTRq3F/x1CpAhW4AVMXOX2jZ1pRGgtc3PDVaQ8D1Daqhq9EAt
        1dtI/1QJMbCqae3Af76UtKY=
X-Google-Smtp-Source: APXvYqzZ3Uy4HZIn0R/GpvXCWyJdCXRxaOi++hhaNBUxDp5qabVeXUGLRll29aX9h9yRr58kOt1GMw==
X-Received: by 2002:a17:902:284a:: with SMTP id e68mr17641733plb.258.1557906349463;
        Wed, 15 May 2019 00:45:49 -0700 (PDT)
Received: from localhost ([124.206.234.166])
        by smtp.gmail.com with ESMTPSA id i15sm1669159pfr.8.2019.05.15.00.45.47
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 15 May 2019 00:45:48 -0700 (PDT)
From:   xiao ruizhu <katrina.xiaorz@gmail.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, alin.nastac@gmail.com,
        netfilter-devel@vger.kernel.org
Cc:     xiao ruizhu <katrina.xiaorz@gmail.com>
Subject: [PATCH v4] netfilter: nf_conntrack_sip: fix expectation clash
Date:   Wed, 15 May 2019 15:45:44 +0800
Message-Id: <1557906344-5505-1-git-send-email-katrina.xiaorz@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20190514101801.xregz4uqppy3lg7j@salvia>
References: <20190514101801.xregz4uqppy3lg7j@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please find my comments below.

> On Thu, May 14, 2019 at 06:18PM, Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:
> Hi Xiao,
> 
> On Tue, May 14, 2019 at 03:45:13PM +0800, 肖瑞珠 wrote:
> > Hi Pablo,
> > 
> > Thanks very much for your reply.
> > 
> > >On Thu, May 13, 2019 at 07:26PM, Pablo Neira Ayuso
> > ><pablo@netfilter.org> wrote:
> > >
> > >I wonder if we can handle this from __nf_ct_expect_check() itself.
> > >
> > >We could just check if master mismatches, then return -EALREADY from
> > >there?
> > >
> > >Similar to 876c27314ce51, but catch the master mismatches case.
> > 
> > Thanks for your proposal. It is a neater solution.

> OK, thanks for exploring this path and confirming this works!
> 
> Still one more question before we go: I wonder if we should enable
> this through flag, eg. extend nf_ct_expect_related() to take a flag
> that NFCT_EXP_F_MASTER_MISMATCH.
> 
> This would change the behaviour for the other existing helpers, which
> would prevent them from creating expectations with the same tuple from
> different master conntracks.
> 
> So I would just turn on this for SIP unless there is some reasoning
> here that turning it for all existing helpers is fine.

Yes, please feel free to add the flag NFCT_EXP_F_MASTER_MISMATCH. It will
minimize the impact on other helpers. Thanks.

> 
> One more comment below.
> 
> > Please find the patch updated accordingly below.
> 
> For some reason this patch is not showing in patchwork:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/list/
> 
> Would you resubmit via git send-mail?
> 
> Thanks.

Sorry, the network for using 'git send-mail' broke and the mail was sent
via gui web.
This time it is submitted via git send-mail. Please don't hesitate to let
me know if still any problem.

Please find the patch v4 below.


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
 net/netfilter/nf_conntrack_expect.c | 6 +++---
 net/netfilter/nf_conntrack_sip.c    | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 334d6e5..bfc7936 100644
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
@@ -421,7 +420,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
-			if (i->class != expect->class)
+			if (i->class != expect->class ||
+			    i->master != expect->master)
 				return -EALREADY;
 
 			if (nf_ct_remove_expect(i))
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b..3262fd9 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -983,6 +983,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
+		 * It also works in the case that SDP messages are sent with
+		 * identical expect tuples but for different master conntracks.
 		 */
 		int errp = nf_ct_expect_related(rtp_exp);
 
-- 
1.9.1

