From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 09/15] netfilter: ipset: Take into account cidr value for the from address when creating the set
Date: Tue,  7 Jun 2011 18:56:14 +0200
Message-ID: <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58847 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab1FGQ4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:22 -0400
In-Reply-To: <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When creating a set from a range expressed as a network like
10.1.1.172/29, the from address was taken as the IP address part and
not masked with the netmask from the cidr.
---
 net/netfilter/ipset/ip_set_bitmap_ip.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 3b5920b..4932311 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -478,6 +478,7 @@ bitmap_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 		if (cidr >= 32)
 			return -IPSET_ERR_INVALID_CIDR;
+		first_ip &= ip_set_hostmask(cidr);
 		last_ip = first_ip | ~ip_set_hostmask(cidr);
 	} else
 		return -IPSET_ERR_PROTOCOL;
-- 
1.7.0.4

