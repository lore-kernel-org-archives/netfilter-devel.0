Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F222C4360C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 17:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4009520659
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 17:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfJJRTL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfJJRTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 13:19:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E9DC30A922D;
        Thu, 10 Oct 2019 17:19:10 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-41.ams2.redhat.com [10.36.112.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEC210027C0;
        Thu, 10 Oct 2019 17:19:07 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Chen Yi <yiche@redhat.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH] ipset: Copy the right MAC address in hash:ip,mac IPv6 sets
Date:   Thu, 10 Oct 2019 19:18:14 +0200
Message-Id: <48b62bbfab1983504cde5521c35e5a6e712997ae.1570727741.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 10 Oct 2019 17:19:10 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as commit 1b4a75108d5b ("netfilter: ipset: Copy the right MAC
address in bitmap:ip,mac and hash:ip,mac sets"), another copy and paste
went wrong in commit 8cc4ccf58379 ("netfilter: ipset: Allow matching on
destination MAC address for mac and ipmac sets").

When I fixed this for IPv4 in 1b4a75108d5b, I didn't realise that
hash:ip,mac sets also support IPv6 as family, and this is covered by a
separate function, hash_ipmac6_kadt().

In hash:ip,mac sets, the first dimension is the IP address, and the
second dimension is the MAC address: check the IPSET_DIM_TWO_SRC flag
in flags while deciding which MAC address to copy, destination or
source.

This way, mixing source and destination matches for the two dimensions
of ip,mac hash type works as expected, also for IPv6. With this setup:

  ip netns add A
  ip link add veth1 type veth peer name veth2 netns A
  ip addr add 2001:db8::1/64 dev veth1
  ip -net A addr add 2001:db8::2/64 dev veth2
  ip link set veth1 up
  ip -net A link set veth2 up

  dst=$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_hash hash:ip,mac family inet6
  ip netns exec A ipset add test_hash 2001:db8::1,${dst}
  ip netns exec A ip6tables -A INPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
  ip netns exec A ip6tables -A INPUT -m set ! --match-set test_hash src,dst -j DROP

ipset now correctly matches a test packet:

  # ping -c1 2001:db8::2 >/dev/null
  # echo $?
  0

Reported-by: Chen, Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("netfilter: ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 24d8f4df4230..4ce563eb927d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -209,7 +209,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
-- 
2.20.1

