Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E31C41513
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 08:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjGYIzx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 04:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjGYIzd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 04:55:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9311E1BF9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2023 01:54:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so4548010276.2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2023 01:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690275294; x=1690880094;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/B/cwBITrcp6YMK1dYqIGTxmL0cVgD8ah6GakAHUfE=;
        b=4r+2Vv2lkO5XxAaE7r208KlJTD9Yq3ahzvvFWm4CLqyBhITlnDDZtKbRSyWRoPGp5M
         L0jFRi27SyD8HOvVCVDoeJJRsPElH+2wWGGW5rmHADOVDMo2g7tYWkEjta9e9KCPEAu9
         oQxsaaf9CK/4qIeCpw3Z2/sObRse+403srhicgpB2vB1Cl6YwwDg0FHFbRvWym3LT/mC
         64ZlVe9iIExM3emKABjKJVWEda68s993pgBtafRmN6AZALGp5cPNSWgiNBtxyOehLhg3
         uWlWk0yZ6iDf7bDg8dpR3siULbdE+GbV/3jgza14Acv+iqfq5pZkCsg9gdu6qTTYKd4c
         h8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690275294; x=1690880094;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/B/cwBITrcp6YMK1dYqIGTxmL0cVgD8ah6GakAHUfE=;
        b=eZZlyCsz5crq8gYQXHPVl9rCe6Eic7EBUlbA9z7daynFHEsneePovpNNkYnmfVp2g2
         gDQGLeGHR6oOedFpzp3YqdvEoQihfL3qQkq9guWHas6bMMEuHEyNIzGJhvvyd3gXpt+y
         PArtCpkY0Uk4ouQ9J0Wzl2j4p4fifOB8t6qO+RASK/EOeJLs1h2dgaI3cR451CGwDloa
         EJNnafaRb1mKqmB3aotCcD4YSW6CSBi1Ij240ge9B//q098Bpne4vf9SvGyi/eLdi+M+
         gan8iQy1km8JzrgnHfLnM1MF3Ig+NmcDCftJn+QIVA/TTaifjloQMxB0ftarXdhivHWB
         /5Bg==
X-Gm-Message-State: ABy/qLZ8elJhvyyGC9IZOtOKrUZ7rL54gfJ5yRF7L338b9RS8eiaXdQj
        g54SJOgXutTQ7IOugkP8sjNXUhI5
X-Google-Smtp-Source: APBJJlEKmek+a6BKsm9iBt6wCMVu+64Bu2bNSSZrAcuXfo7sY2IfQJKVXVC0wRNo5F3jIb3uaJE+bqk3
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:b5af:c23f:2354:ac])
 (user=maze job=sendgmr) by 2002:a05:6902:1369:b0:d12:eab5:5130 with SMTP id
 bt9-20020a056902136900b00d12eab55130mr27484ybb.13.1690275294451; Tue, 25 Jul
 2023 01:54:54 -0700 (PDT)
Date:   Tue, 25 Jul 2023 01:54:43 -0700
Message-Id: <20230725085443.2102634-1-maze@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Subject: [PATCH netfilter] netfilter: nfnetlink_log: always add a timestamp
From:   "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To:     "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Compared to all the other work we're already doing to deliver
an skb to userspace this is very cheap - at worse an extra
call to ktime_get_real() - and very useful.

(and indeed it may even be cheaper if we're running from other hooks)

(background: Android occasionally logs packets which
caused wake from sleep/suspend and we'd like to have
timestamps reliably associated with these events)

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/netfilter/nfnetlink_log.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e57eb168ee13..53c9e76473ba 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -470,7 +470,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	sk_buff_data_t old_tail =3D inst->skb->tail;
 	struct sock *sk;
 	const unsigned char *hwhdrp;
-	ktime_t tstamp;
=20
 	nlh =3D nfnl_msg_put(inst->skb, 0, 0,
 			   nfnl_msg_type(NFNL_SUBSYS_ULOG, NFULNL_MSG_PACKET),
@@ -599,10 +598,9 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 	}
=20
-	tstamp =3D skb_tstamp_cond(skb, false);
-	if (hooknum <=3D NF_INET_FORWARD && tstamp) {
+	if (hooknum <=3D NF_INET_FORWARD) {
+		struct timespec64 kts =3D ktime_to_timespec64(skb_tstamp_cond(skb, true)=
);
 		struct nfulnl_msg_packet_timestamp ts;
-		struct timespec64 kts =3D ktime_to_timespec64(tstamp);
 		ts.sec =3D cpu_to_be64(kts.tv_sec);
 		ts.usec =3D cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
=20
--=20
2.41.0.487.g6d72f3e995-goog

