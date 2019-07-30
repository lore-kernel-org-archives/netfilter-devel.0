Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECCFC433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3869206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNRi4Rrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbfG3MZj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:25:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36026 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfG3MZj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:25:39 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so23964147iom.3;
        Tue, 30 Jul 2019 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s5yWI2xfBi7yZUvh5vbuUYKfiAIOr2+n9/J+pTBAvvA=;
        b=oNRi4RrqZcCHcv3ihpvxRh05FVUCJujtgcfihPqzEIhibrVSyvLxH6ou+KPX3QcJW1
         8odyqmb9Xy6OZW3Akl4mhb8QXyeta1TByczNxiawqeZqlsAEQgeNH4zWnRQNZjNaanng
         0uyuZIy+8zTVFFxa0Ya/KrP2BWiVnBI9uP6oyFln1SImZYqFXKVsPFuT21tgQZ7JxlFX
         Fs+CbA/+uEvCQ0ZUgz9IPY356ERlad9t/WiFeJ2j53Gucbi1JlQ9yIBQgH0c0Te24k7b
         EffDwc1jhPKoAalhRJA+XcovRIjMe2TsRZptfp0V8HA2/1B5SE8WZ8hszhzXBdu/7690
         DokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s5yWI2xfBi7yZUvh5vbuUYKfiAIOr2+n9/J+pTBAvvA=;
        b=TMGbfHz7XYUaf0EEpYhojlH2AUFA8fqyYprqvHQp0O+q0TjwUdFbpgltjDLL9ujHyn
         yeZ00voKnicZ84UCrXg6I8nSL+xZ6tvdaiYd7Bmn8Qryw+8NhG9WlsgxcuJZIvcuZB+J
         JtHrkSSxBc4X5FV6x4qQWAoqzunbiYNj5mljYW6JnzNVi0/P5CXxlI9/t1MFRI8ANQdZ
         wpMIEapsrfEYW7cXrkcrPqEjBI/YuhlWqPKb0mN3LTXLmLSrReCPiC5fBoQ8cYxHhb3D
         cD5/6dvCJz7NfXVcBa7CtjQdMoxreac96H5y8a7dwievlDsY09rEbbmMquO8YCFjhHpG
         oQIg==
X-Gm-Message-State: APjAAAUbOB4VI52yGSCxBg4E9Ux5lxqkkngGvDEH5YFAJF1wOlefoLnN
        wj4Dl2K7JSpkv3oJyPTAiA==
X-Google-Smtp-Source: APXvYqyQH9tqYauuovKG4HR22AWdKr93hT9a4O67gZNyhFbLW2ujv+hKs4GCYjdavvE1y4Ujue7gVA==
X-Received: by 2002:a6b:cd86:: with SMTP id d128mr106118586iog.234.1564489538291;
        Tue, 30 Jul 2019 05:25:38 -0700 (PDT)
Received: from ip-172-31-35-247.us-east-2.compute.internal (ec2-52-15-165-154.us-east-2.compute.amazonaws.com. [52.15.165.154])
        by smtp.gmail.com with ESMTPSA id j23sm52454755ioo.6.2019.07.30.05.25.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:25:37 -0700 (PDT)
From:   Rundong Ge <rdong.ge@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@cumulusnetworks.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        linux-kernel@vger.kernel.org, rdong.ge@gmail.com
Subject: [PATCH] bridge:fragmented packets dropped by bridge
Date:   Tue, 30 Jul 2019 12:25:34 +0000
Message-Id: <20190730122534.30687-1-rdong.ge@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Given following setup:
-modprobe br_netfilter
-echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
-brctl addbr br0
-brctl addif br0 enp2s0
-brctl addif br0 enp3s0
-brctl addif br0 enp6s0
-ifconfig enp2s0 mtu 1300
-ifconfig enp3s0 mtu 1500
-ifconfig enp6s0 mtu 1500
-ifconfig br0 up

                 multi-port
mtu1500 - mtu1500|bridge|1500 - mtu1500
  A                  |            B
                   mtu1300

With netfilter defragmentation/conntrack enabled, fragmented
packets from A will be defragmented in prerouting, and refragmented
at postrouting.
But in this scenario the bridge found the frag_max_size(1500) is
larger than the dst mtu stored in the fake_rtable whitch is
always equal to the bridge's mtu 1300, then packets will be dopped.

This modifies ip_skb_dst_mtu to use the out dev's mtu instead
of bridge's mtu in bridge refragment.

Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
---
 include/net/ip.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index 29d89de..0512de3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -450,6 +450,8 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 					  const struct sk_buff *skb)
 {
+	if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
+		return min(skb->dev->mtu, IP_MAX_MTU);
 	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
 		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
 
-- 
1.8.3.1

