From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH next 26/84] ipvs: Pass ipvs not net to __ip_vs_get_service_entries
Date: Mon, 21 Sep 2015 13:02:03 -0500
Message-ID: <1442858581-15869-26-git-send-email-ebiederm@xmission.com>
References: <8737y7irc8.fsf_-_@x220.int.ebiederm.org>
Cc: netfilter-devel@vger.kernel.org, <netdev@vger.kernel.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	lvs-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:35439 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbbIUSOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Sep 2015 14:14:19 -0400
In-Reply-To: <8737y7irc8.fsf_-_@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7aba55c875cb..05f7e1d14738 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2477,11 +2477,10 @@ ip_vs_copy_service(struct ip_vs_service_entry *dst, struct ip_vs_service *src)
 }
 
 static inline int
-__ip_vs_get_service_entries(struct net *net,
+__ip_vs_get_service_entries(struct netns_ipvs *ipvs,
 			    const struct ip_vs_get_services *get,
 			    struct ip_vs_get_services __user *uptr)
 {
-	struct netns_ipvs *ipvs = net_ipvs(net);
 	int idx, count=0;
 	struct ip_vs_service *svc;
 	struct ip_vs_service_entry entry;
@@ -2720,7 +2719,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 			ret = -EINVAL;
 			goto out;
 		}
-		ret = __ip_vs_get_service_entries(net, get, user);
+		ret = __ip_vs_get_service_entries(ipvs, get, user);
 	}
 	break;
 
-- 
2.2.1

