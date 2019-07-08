Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7448CC606C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 14:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 570A721670
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 14:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfGHORg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 10:17:36 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728596AbfGHORf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 10:17:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hkUSQ-0001FR-U2; Mon, 08 Jul 2019 16:17:30 +0200
Date:   Mon, 8 Jul 2019 16:17:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add
 nf_nat_bridge_ops support
Message-ID: <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add nf_nat_bridge_ops to do nat in the bridge family

Whats the use case for this?

The reason I'm asking is that a bridge doesn't know about IP,
Bridge netfilter (the call-iptables thing) has a lot of glue code
to detect dnat rewrites and updates target mac address, including
support for redirect (suddently packet has to be pushed up the stack)
or changes in the oif to non-bridge ports (it even checks forward sysctl
state ..) and so on.

Thats something that I don't want to support in nftables.

For NAT on bridge, it should be possible already to push such packets
up the stack by

bridge input meta iif eth0 ip saddr 192.168.0.0/16 \
       meta pkttype set unicast ether daddr set 00:11:22:33:44:55

then normal ip processing handles this and nat should "just work".
If above doesn't work for you I'd like to understand why.
