Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E4DC4167D
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 10:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjKDKEE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 06:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjKDKED (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 06:04:03 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C14187
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2023 03:03:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 798C9CC0120;
        Sat,  4 Nov 2023 11:03:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1699092230; x=1700906631; bh=CuIFB+fOku
        LkS450ANORlbe2dWhWXupmuCJ6UZ9I1pQ=; b=HNIFBPjM5s6DtcPkF+x7YTNMAg
        kEC0tuPjFNtZR96zYvVfjfIk6hd/G73ial8VaJVmYrbddLIZMHyzM0r34YeKEXHm
        UL9HT7DUDeWDheUvEBszK+JOJeaE11NNuonjNI1U8BOQMgP4E1LiWqydzLd6LNii
        eTTOxTBwUtqwS5TGs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat,  4 Nov 2023 11:03:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 27317CC0111;
        Sat,  4 Nov 2023 11:03:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 7492E3431A8; Sat,  4 Nov 2023 11:03:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH 1/1] netfilter: ipset: fix race condition between swap/destroy and kernel side add/del/test, v2
Date:   Sat,  4 Nov 2023 11:03:49 +0100
Message-Id: <20231104100349.4184215-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231104100349.4184215-1-kadlec@netfilter.org>
References: <20231104100349.4184215-1-kadlec@netfilter.org>
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

The fix is to protect both the list of the sets and the set pointers in a=
n extended RCU
region and before exiting ip_set_swap(), wait to finish all started rcu_r=
ead_lock().

The first version of the patch was written by Linkui Xiao <xiaolinkui@kyl=
inos.cn>.

v2: synchronize_rcu() is moved into ip_set_swap() in order not to burden
ip_set_destroy() unnecessarily when all sets are destroyed.

Closes: https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@n=
etfilter.org/
Reported by: Linkui Xiao <xiaolinkui@kylinos.cn>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e564b5174261..a50ded1ee66d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -704,13 +704,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
 	struct ip_set_net *inst =3D ip_set_pernet(net);
=20
 	rcu_read_lock();
-	/* ip_set_list itself needs to be protected */
+	/* ip_set_list and the set pointer need to be protected */
 	set =3D rcu_dereference(inst->ip_set_list)[index];
-	rcu_read_unlock();
=20
 	return set;
 }
=20
+static inline void
+ip_set_rcu_put(struct ip_set *set __always_unused)
+{
+	rcu_read_unlock();
+}
+
 static inline void
 ip_set_lock(struct ip_set *set)
 {
@@ -736,8 +741,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return 0;
+	}
=20
 	ret =3D set->variant->kadt(set, skb, par, IPSET_TEST, opt);
=20
@@ -756,6 +763,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *=
skb,
 			ret =3D -ret;
 	}
=20
+	ip_set_rcu_put(set);
 	/* Convert error codes to nomatch */
 	return (ret < 0 ? 0 : ret);
 }
@@ -772,12 +780,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
=20
 	ip_set_lock(set);
 	ret =3D set->variant->kadt(set, skb, par, IPSET_ADD, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
=20
 	return ret;
 }
@@ -794,12 +805,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
=20
 	ip_set_lock(set);
 	ret =3D set->variant->kadt(set, skb, par, IPSET_DEL, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
=20
 	return ret;
 }
@@ -874,6 +888,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t inde=
x, char *name)
 	read_lock_bh(&ip_set_ref_lock);
 	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
 	read_unlock_bh(&ip_set_ref_lock);
+	ip_set_rcu_put(set);
 }
 EXPORT_SYMBOL_GPL(ip_set_name_byindex);
=20
@@ -1389,6 +1404,9 @@ static int ip_set_swap(struct sk_buff *skb, const s=
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

