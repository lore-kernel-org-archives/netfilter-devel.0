Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9803BC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 20:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjKMUNa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 15:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjKMUNa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 15:13:30 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A4710A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 12:13:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8514BCC02CE;
        Mon, 13 Nov 2023 21:13:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1699906403; x=1701720804; bh=VosZ10HIpm
        XlMrQHuqBUmgdhMOqWsfvd5wWyAqDyQkw=; b=PohcC+AwAmGNh4n4xYGIpIwTL7
        WfKOiWKvKYv/c1JqPkC0psCp5bpCCFJOx524f8aPQpkvEf51ujkjo8QTzHmqv8Cs
        pf/6w7EkWPevY8W6lUeMTK3J/5dIg+6fnHfFMCydUhRjn5ZRhum7vG0qctKOZOzq
        c8tEJO4KJ5W5wbwls=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 13 Nov 2023 21:13:23 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 544BACC02CB;
        Mon, 13 Nov 2023 21:13:23 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 1553C3431A8; Mon, 13 Nov 2023 21:13:23 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: ipset: fix race condition between swap/destroy and kernel side add/del/test, v3
Date:   Mon, 13 Nov 2023 21:13:23 +0100
Message-Id: <20231113201323.1747378-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113201323.1747378-1-kadlec@netfilter.org>
References: <20231113201323.1747378-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Linkui Xiao reported that there's a race condition when ipset swap and de=
stroy is
called, which can lead to crash in add/del/test element operations. Swap =
then
destroy are usual operations to replace a set with another one in a produ=
ction
system. The issue can in some cases be reproduced with the script:

ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
ipset add hash_ip1 172.20.0.0/16
ipset add hash_ip1 192.168.0.0/16
iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
while [ 1 ]
do
	# ... Ongoing traffic...
        ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem =
1048576
        ipset add hash_ip2 172.20.0.0/16
        ipset swap hash_ip1 hash_ip2
        ipset destroy hash_ip2
        sleep 0.05
done

In the race case the possible order of the operations are

	CPU0			CPU1
	ip_set_test
				ipset swap hash_ip1 hash_ip2
				ipset destroy hash_ip2
	hash_net_kadt

Swap replaces hash_ip1 with hash_ip2 and then destroy removes hash_ip2 wh=
ich
is the original hash_ip1. ip_set_test was called on hash_ip1 and because =
destroy
removed it, hash_net_kadt crashes.

The fix is to force ip_set_swap() to wait for all readers to finish acces=
sing the
old set pointers by calling synchronize_rcu().

The first version of the patch was written by Linkui Xiao <xiaolinkui@kyl=
inos.cn>.

v2: synchronize_rcu() is moved into ip_set_swap() in order not to burden
    ip_set_destroy() unnecessarily when all sets are destroyed.
v3: Florian Westphal pointed out that all netfilter hooks run with rcu_re=
ad_lock() held
    and em_ipset.c wraps the entire ip_set_test() in rcu read lock/unlock=
 pair.
    So there's no need to extend the rcu read locked area in ipset itself=
.

Closes: https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@n=
etfilter.org/
Reported by: Linkui Xiao <xiaolinkui@kylinos.cn>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e564b5174261..43cd64d6dc26 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -61,6 +61,8 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 	ip_set_dereference((inst)->ip_set_list)[id]
 #define ip_set_ref_netlink(inst,id)	\
 	rcu_dereference_raw((inst)->ip_set_list)[id]
+#define ip_set_dereference_nfnl(p)	\
+	rcu_dereference_check(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
=20
 /* The set types are implemented in modules and registered set types
  * can be found in ip_set_type_list. Adding/deleting types is
@@ -700,15 +702,10 @@ __ip_set_put_netlink(struct ip_set *set)
 static struct ip_set *
 ip_set_rcu_get(struct net *net, ip_set_id_t index)
 {
-	struct ip_set *set;
 	struct ip_set_net *inst =3D ip_set_pernet(net);
=20
-	rcu_read_lock();
-	/* ip_set_list itself needs to be protected */
-	set =3D rcu_dereference(inst->ip_set_list)[index];
-	rcu_read_unlock();
-
-	return set;
+	/* ip_set_list and the set pointer need to be protected */
+	return ip_set_dereference_nfnl(inst->ip_set_list)[index];
 }
=20
 static inline void
@@ -1389,6 +1386,9 @@ static int ip_set_swap(struct sk_buff *skb, const s=
truct nfnl_info *info,
 	ip_set(inst, to_id) =3D from;
 	write_unlock_bh(&ip_set_ref_lock);
=20
+	/* Make sure all readers of the old set pointers are completed. */
+	synchronize_rcu();
+
 	return 0;
 }
=20
--=20
2.30.2

