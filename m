Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA62C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 13:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F1920820
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 13:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfFXNUW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 09:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20029 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbfFXNUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 09:20:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 881D0307D986;
        Mon, 24 Jun 2019 13:20:21 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A657608BA;
        Mon, 24 Jun 2019 13:20:20 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Chen Yi <yiche@redhat.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH 2/2] ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets
Date:   Mon, 24 Jun 2019 15:20:12 +0200
Message-Id: <9cd60b3a0308fc0c33b605c7552b95cff5e0737f.1561381646.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561381646.git.sbrivio@redhat.com>
References: <cover.1561381646.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 24 Jun 2019 13:20:21 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I added to the
KADT functions for sets matching on MAC addreses the copy of source or
destination MAC address depending on the configured match.

This was done correctly for hash:mac, but for hash:ip,mac and
bitmap:ip,mac, copying and pasting the same code block presents an
obvious problem: in these two set types, the MAC address is the second
dimension, not the first one, and we are actually selecting the MAC
address depending on whether the first dimension (IP address) specifies
source or destination.

Fix this by checking for the IPSET_DIM_TWO_SRC flag in option flags.

This way, mixing source and destination matches for the two dimensions
of ip,mac set types works as expected. With this setup:

  ip netns add A
  ip link add veth1 type veth peer name veth2 netns A
  ip addr add 192.0.2.1/24 dev veth1
  ip -net A addr add 192.0.2.2/24 dev veth2
  ip link set veth1 up
  ip -net A link set veth2 up

  dst=$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_bitmap bitmap:ip,mac range 192.0.0.0/16
  ip netns exec A ipset add test_bitmap 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_bitmap src,dst -j DROP

  ip netns exec A ipset create test_hash hash:ip,mac
  ip netns exec A ipset add test_hash 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_hash src,dst -j DROP

ipset correctly matches a test packet:

  # ping -c1 192.0.2.2 >/dev/null
  # echo $?
  0

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipmac.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 9317b8fbc805..bf8da83a06e8 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -232,7 +232,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = ip_to_id(map, ip);
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipmac.c b/kernel/net/netfilter/ipset/ip_set_hash_ipmac.c
index 5b926bf80986..25560ea742d6 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -96,7 +96,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
-- 
2.20.1

