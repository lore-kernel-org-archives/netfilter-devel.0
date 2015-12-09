From: =?koi8-r?B?58HX0snMz9cg6cfP0tg=?= <iggorok@yandex.ua>
Subject: nf_conntrack_count is increasing
Date: Wed, 09 Dec 2015 13:25:06 +0200
Message-ID: <3947861449660306@web9g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward8p.cmail.yandex.net ([87.250.241.193]:48012 "EHLO
	forward8p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbbLILc7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 06:32:59 -0500
Received: from web9g.yandex.ru (web9g.yandex.ru [IPv6:2a02:6b8:0:1402::19])
	by forward8p.cmail.yandex.net (Yandex) with ESMTP id 87B2A20FCF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:25:08 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everyone! I need your advice. I'm trying to improve cls_flow, so that it could get information about NATed addresses on ingress interface. I have changed the code from net/sched/act_connmark.c to make it possible:
	if (ct == NULL){						\
		        switch (tc_skb_protocol(skb)) {			\
		        case htons(ETH_P_IP):				\
                		proto = NFPROTO_IPV4; 			\
				break;					\
		        case htons(ETH_P_IPV6):				\
				proto = NFPROTO_IPV6;			\
				break;					\
			default: goto fallback;				\
	        } 							\
									\
	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, &tuple)) \
                goto fallback;						\
        zone.id = NF_CT_DEFAULT_ZONE_ID;				\
        zone.dir = NF_CT_DEFAULT_ZONE_DIR;				\
									\
        thash = nf_conntrack_find_get(dev_net(skb->dev), &zone, &tuple);\
        if (!thash) goto fallback;					\
        ct = nf_ct_tuplehash_to_ctrack(thash);				\
	result = ct->tuplehash[(thash->tuple.dst.dir == IP_CT_DIR_REPLY) ? IP_CT_DIR_ORIGINAL : IP_CT_DIR_REPLY].tuple.src.member;	\
	} else {							\
If nf_ct_get() fails to retrieve information from sk_buff, which is obvious on ingress, I use nf_ct_get_tuplepr() and nf_conntrack_find_get() like in net/sched/act_connmark.c, but I have encountered a problem - after a while traffic stops forwarding with the message "nf_conntrack: table is full" and conntrack -F doesn't help - nf_conntrack_count remains large - about 200k. Can anyone advise me how to fix this issue?
