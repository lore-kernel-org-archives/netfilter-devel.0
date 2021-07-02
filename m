Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A62C11F67
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8176A613F7
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhGBA46 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 20:56:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41936 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhGBA45 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 20:56:57 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7EAF760705;
        Fri,  2 Jul 2021 02:54:18 +0200 (CEST)
Date:   Fri, 2 Jul 2021 02:54:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Taehee Yoo <ap420073@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NETFILTER v2] netfilter: nfnetlink: suspicious RCU usage
 in ctnetlink_dump_helpinfo
Message-ID: <20210702005422.GA29227@salvia>
References: <3b140111-8af0-176f-d3d0-567e8051eaf4@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3b140111-8af0-176f-d3d0-567e8051eaf4@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 01, 2021 at 08:02:49AM +0300, Vasily Averin wrote:
> Two patches listed below removed ctnetlink_dump_helpinfo call from under
> rcu_read_lock. Now its rcu_dereference generates following warning:
> =============================
> WARNING: suspicious RCU usage
> 5.13.0+ #5 Not tainted
> -----------------------------
> net/netfilter/nf_conntrack_netlink.c:221 suspicious rcu_dereference_check() usage!

Applied.
