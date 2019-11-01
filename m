Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65F3CA9ED1
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAE221734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="LCa/1Fk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfKAQgA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:36:00 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:36211 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbfKAQgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:36:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 6BF0A3C80121;
        Fri,  1 Nov 2019 17:35:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1572626155; x=1574440556; bh=YEH5CsKKus
        tYIfcn/ABFKV0LRjvTjxHD1YMyGfkzoLU=; b=LCa/1Fk5/AHG4iVIXVJ5tCSsrk
        aXW/HDTKhSB+Ng1zj0+dbwBj6WZzttz90eEwU+iPCgL1fk8ibgYr01zN8wLMuf6q
        flPwuEvOsFNE870JigoyYGXo4cTtzkfau1UiNDRV6O7BWPT7cIYwEEhIP2r5PxGg
        2G9aCXt+tHW8gX4Qk=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 3C76D3C800F7;
        Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2563121B3B; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets
Date:   Fri,  1 Nov 2019 17:35:53 +0100
Message-Id: <20191101163554.10561-3-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
References: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

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

  dst=3D$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_hash hash:ip,mac family inet6
  ip netns exec A ipset add test_hash 2001:db8::1,${dst}
  ip netns exec A ip6tables -A INPUT -p icmpv6 --icmpv6-type 135 -j ACCEP=
T
  ip netns exec A ip6tables -A INPUT -m set ! --match-set test_hash src,d=
st -j DROP

ipset now correctly matches a test packet:

  # ping -c1 2001:db8::2 >/dev/null
  # echo $?
  0

Reported-by: Chen, Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("netfilter: ipset: Allow matching on destination MAC=
 address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipse=
t/ip_set_hash_ipmac.c
index 24d8f4df4230..4ce563eb927d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -209,7 +209,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_=
buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
=20
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
--=20
2.20.1

