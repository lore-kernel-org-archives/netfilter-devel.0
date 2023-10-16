Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B3FCDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjJPNwn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjJPNwm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:52:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B539F0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:52:41 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ca3a54d2c4so14461105ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697464360; x=1698069160; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LKam9BrhxMrxzs36tEVRDQCofa/VFdMQUcffFtBUgFo=;
        b=dgNPD//lhD1bSmvMbYMcu/4px3Vxvu4S5D7l9/hxauipxpC2xmEjsCYMToiF6WLzNG
         UajlxZypqN6NnMOga4C8PqP0iNjDv8Yv7HogwltAJkSFPYj5MJBxbZYa6Whqa2dcjhXL
         6m5OxX50Rk1QqF7OwNsFKuaK3jU0iYqiN3d7/RMujPQcp1140u3tnW5051m+DQufoM37
         c7/z0NETOedw5I5nv7sD9cZoW+xJPR7E9wIFilC4cXsthxwXdOfaEx1lFmnQ0BWxxDsj
         tLxj+w5NcP01wQWiOfidldrIJQLp0pUtWVu7vXbsk/8I0a8BRotHhkx1dxI72qkFuXP8
         JoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464360; x=1698069160;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKam9BrhxMrxzs36tEVRDQCofa/VFdMQUcffFtBUgFo=;
        b=gCSeVfJkdBXOJrzFwF9x+OzA1rgRpEhFc2Y3a9RcAqtYVcnb7BH7H2izd9UUWIrn1y
         aJ75kUw9tDs5nuRUB2CvYIHIbIA0Fmn77Zw/7lp47IGZeHPQvGl0u31yz6BQhL4cJSu/
         7ikLBedldMnjzIyZwPkKUiq68mMlRecuD6xFYRNA0G8T78EhXq/l/aczENKWyOv72ovp
         svMi4LQ/fzactcM0PwD8v51acxicRj4wQ/Qm5gvkx/1hrWXwIHdMNeD7JeS+zXWRdyak
         XPZp6JRxrFrkunCPbVkNndRgf7+5XgN2aNXZhcrnCJV63HLrdTIs3eFhDam6acgQdc/q
         VLQg==
X-Gm-Message-State: AOJu0YwvIQQXBUC72OwaFrWt4AXOSyQCBLeHOrPr8Bf2vTwyBGl/d5O1
        OJZM+sJcD/FLZJtM7gO15tY=
X-Google-Smtp-Source: AGHT+IEkNxgGR9Ikwj5O7aNQeEvxxSRxw1gNFW2CwlYbyJp4d6ROsAfld8VkQKA15kH5+t+P7DsvaQ==
X-Received: by 2002:a17:903:11c8:b0:1c7:2697:ec10 with SMTP id q8-20020a17090311c800b001c72697ec10mr41240368plh.56.1697464360492;
        Mon, 16 Oct 2023 06:52:40 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id h24-20020a170902ac9800b001c3be750900sm8533377plr.163.2023.10.16.06.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 06:52:39 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, justinstitt@google.com, kuniyu@amazon.com
Cc:     netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH 2/2] netfilter: ipset: fix race condition in ipset swap, destroy  and test
Date:   Mon, 16 Oct 2023 21:52:04 +0800
Message-Id: <20231016135204.27443-2-xiaolinkui@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231016135204.27443-1-xiaolinkui@gmail.com>
References: <20231016135204.27443-1-xiaolinkui@gmail.com>
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

With this fix in place swap will not succeed because ip_set_test still has
ref_swapping on the set.

Both destroy and swap will error out if ref_swapping != 0 on the set.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 net/netfilter/ipset/ip_set_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e5d25df5c64c..d6bd37010bfb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -741,11 +741,13 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	int ret = 0;
 
 	BUG_ON(!set);
+
+	__ip_set_get_swapping(set);
 	pr_debug("set %s, index %u\n", set->name, index);
 
 	if (opt->dim < set->type->dimension ||
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
-		return 0;
+		goto out;
 
 	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
 
@@ -764,6 +766,8 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 			ret = -ret;
 	}
 
+out:
+	__ip_set_put_swapping(set);
 	/* Convert error codes to nomatch */
 	return (ret < 0 ? 0 : ret);
 }
-- 
2.17.1

