Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFBCCDB483
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 12:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbjJQMxX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbjJQMxX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 08:53:23 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F3AEA;
        Tue, 17 Oct 2023 05:53:21 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-581e819cf28so94022eaf.3;
        Tue, 17 Oct 2023 05:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697547201; x=1698152001; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYzfT+Cbud7+CgNWYJCR5X2Y5pUF3XbNRMOsrq4hChk=;
        b=Qwmx9VwWU/l2ZZyyye3ClZydwgQjEKkFhSFyF9QCzaToScF56jI6eh4t5H8gbQ5Tbs
         BXJqxwNBLzJX2jvP1bZhPGu+gv4im0H3CCvD9k7GvI03lJTV7cYx1Y8g3M+4/1S8Fx4X
         B3SnPM30tCbJBH0/qPixL75tsY7rjwsF+IZ93rw9xrlfXKD/fFbJmR3gQZnyz53r2RaU
         RhWiaCUtWA5dhlBrlLEMCs+j3gnN7uJlqTiY/ps7CnkdXAumRa2HPKkW133wWPXeDD8I
         kodKre5iHk0AAEs6iKRZ86nsrdckh86pxam+BxBlRhrE/PapwoyCXIsMXzHU2rTDN/TW
         rSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697547201; x=1698152001;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYzfT+Cbud7+CgNWYJCR5X2Y5pUF3XbNRMOsrq4hChk=;
        b=IyHaPpRsLPiQ6LV3NbgqUFqYdwLNZbm1WUMGuIjqS0nFennDjLKXQ7C3LoBToDRCgS
         kIsgjbaR/npHbFz5RJWQemh1IrkwY1J8JJP+7p7+6Xblf/kswMEtELQyGjAcLVvB9Xt0
         kRFhvIPrfQZb5aNVnbcv5wzep8RWErWyxlrmRvdYuAW282VSUX77JcfooajNZ4jtm6b9
         aKvvSeUmpluan7IKhj6+VP7MIv/VGMtgUXcQhwFbMRcAUNqd5Nw9ZMBqJR8uDP7fSgLP
         N/CFIw29yPGBhNEdKCK6No8g+EtG/wOfadcSc5VUEWNUj9El/ss0G2MHM0FVSNjwpHhE
         0Ocw==
X-Gm-Message-State: AOJu0YziVaSIrOLZxtgX5TyIEy53Ymzv/FXy/oxqM2sjygMkzaUgHfoc
        hwn+hsi17/hhYAlvRqWIzao=
X-Google-Smtp-Source: AGHT+IHLLD6heJyBFPm6Q1r9KsT1+OupWuPYZo1F/wrIx0VN9EL8d2mmtxj0mOExpWLMkd2g8FOz8g==
X-Received: by 2002:a05:6358:880c:b0:13a:cb52:4837 with SMTP id hv12-20020a056358880c00b0013acb524837mr2057319rwb.31.1697547200618;
        Tue, 17 Oct 2023 05:53:20 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id q23-20020aa79617000000b006be2927ca7esm1337615pfg.85.2023.10.17.05.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 05:53:19 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, justinstitt@google.com
Cc:     netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH] netfilter: ipset: fix race condition in ipset swap, destroy and test/add/del
Date:   Tue, 17 Oct 2023 20:52:56 +0800
Message-Id: <20231017125256.23056-1-xiaolinkui@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

There is a race condition which can be demonstrated by the following
script:

ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
ipset add hash_ip1 172.20.0.0/16
ipset add hash_ip1 192.168.0.0/16
iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
while [ 1 ]
do
        ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
        ipset add hash_ip2 172.20.0.0/16
        ipset swap hash_ip1 hash_ip2
        ipset destroy hash_ip2
        sleep 0.05
done

Swap will exchange the values of ref so destroy will see ref = 0 instead of
ref = 1. So after running this script for a period of time, the following
race situations may occur:
        CPU0:                CPU1:
        ipt_do_table
        ->set_match_v4
        ->ip_set_test
                        ipset swap hash_ip1 hash_ip2
                        ipset destroy hash_ip2
        ->hash_net4_kadt

CPU0 found ipset through the index, and at this time, hash_ip2 has been
destroyed by CPU1 through name search. So CPU0 will crash when accessing
set->data in the function hash_net4_kadt.

With this fix in place swap will wait for the ongoing operations to be
finished.

V1->V2 changes:
- replace ref_netlink with rcu synchonize_rcu()

Closes: https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org/
Cc: stable@vger.kernel.org
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>

---
 net/netfilter/ipset/ip_set_core.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 35d2f9c9ada0..62ee4de6ffee 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -712,13 +712,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
 	struct ip_set_net *inst = ip_set_pernet(net);
 
 	rcu_read_lock();
-	/* ip_set_list itself needs to be protected */
+	/* ip_set_list and the set pointer need to be protected */
 	set = rcu_dereference(inst->ip_set_list)[index];
-	rcu_read_unlock();
 
 	return set;
 }
 
+static inline void
+ip_set_rcu_put(struct ip_set *set __always_unused)
+{
+	rcu_read_unlock();
+}
+
 static inline void
 ip_set_lock(struct ip_set *set)
 {
@@ -744,8 +749,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
+		ip_set_rcu_put(set);
 		return 0;
+	}
 
 	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
 
@@ -764,6 +771,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 			ret = -ret;
 	}
 
+	ip_set_rcu_put(set);
 	/* Convert error codes to nomatch */
 	return (ret < 0 ? 0 : ret);
 }
@@ -780,12 +788,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
 
 	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
 
 	return ret;
 }
@@ -802,12 +813,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
+	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
 
 	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
 
 	return ret;
 }
@@ -882,6 +896,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name)
 	read_lock_bh(&ip_set_ref_lock);
 	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
 	read_unlock_bh(&ip_set_ref_lock);
+	ip_set_rcu_put(set);
 }
 EXPORT_SYMBOL_GPL(ip_set_name_byindex);
 
@@ -1348,6 +1363,9 @@ static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
  * protected by the ip_set_ref_lock. The kernel interfaces
  * do not hold the mutex but the pointer settings are atomic
  * so the ip_set_list always contains valid pointers to the sets.
+ * However after swapping, a userspace set destroy command could
+ * remove a set still processed by kernel side add/del/test.
+ * Therefore we need to wait for the ongoing operations to be finished.
  */
 
 static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
@@ -1397,6 +1415,9 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 	ip_set(inst, to_id) = from;
 	write_unlock_bh(&ip_set_ref_lock);
 
+	/* Make sure all readers of the old set pointers are completed. */
+	synchronize_rcu();
+
 	return 0;
 }
 
-- 
2.17.1

