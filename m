Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7C2C76191
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 18:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5329B206B8
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 18:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfGOSGo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 14:06:44 -0400
Received: from mail.us.es ([193.147.175.20]:40706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbfGOSGo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 14:06:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BE3BDA738
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 20:06:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AE7B6DA95
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 20:06:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 308754FA31; Mon, 15 Jul 2019 20:06:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31C24D2F98;
        Mon, 15 Jul 2019 20:06:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 20:06:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 100444265A32;
        Mon, 15 Jul 2019 20:06:40 +0200 (CEST)
Date:   Mon, 15 Jul 2019 20:06:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev@fami-braun.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2] Fix dumping vlan rules
Message-ID: <20190715180639.5osmyxjg6b2r7db3@salvia>
References: <20190715165901.14441-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715165901.14441-1-michael-dev@fami-braun.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 15, 2019 at 06:59:01PM +0200, michael-dev@fami-braun.de wrote:
> From: "M. Braun" <michael-dev@fami-braun.de>
> 
> Given the following bridge rules:
> 1. ip protocol icmp accept
> 2. ether type vlan vlan type ip ip protocol icmp accept

No testcase for #2?

> The are currently both dumped by "nft list ruleset" as
> 1. ip protocol icmp accept
> 2. ip protocol icmp accept
> 
> Though, the netlink code actually is different

Good catch.

> bridge filter FORWARD 4
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ immediate reg 0 accept ]
> 
> bridge filter FORWARD 5 4
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000081 ]
>   [ payload load 2b @ link header + 16 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ immediate reg 0 accept ]
>
> Fix this by avoiding the removal of all vlan statements
> in the given example.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
>  src/payload.c                         | 12 ++++++++++++
>  tests/py/bridge/vlan.t                |  2 ++
>  tests/py/bridge/vlan.t.payload        | 10 ++++++++++
>  tests/py/bridge/vlan.t.payload.netdev | 12 ++++++++++++
>  4 files changed, 36 insertions(+)
> 
> diff --git a/src/payload.c b/src/payload.c
> index 3bf1ecc..905422a 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -506,6 +506,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
>  		     dep->left->payload.desc == &proto_ip6) &&
>  		    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
>  			return false;
> +		/* Do not kill
> +		 *  ether type vlan and vlan type ip and ip protocol icmp
> +		 * into
> +		 *  ip protocol icmp

So, what happens here is that:

        #1 vlan type ip kills ether type vlan
        #2 ip protocol icmp kills vlan type ip

right?

> +		 * as this lacks ether type vlan.
> +		 * More generally speaking, do not kill protocol type
> +		 * for stacked protocols if we only have protcol type matches.

s/protcol/protocol

> +		 */
> +		if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
> +		    expr->flags & EXPR_F_PROTOCOL &&
> +		    expr->payload.base == dep->left->payload.base)

If the current expression is a key (EXPR_F_PROTOCOL expressions tells
us what it comes in the upper layer) and base of such expression is
the same as the dependency.

I'd prefer this rule is restricted to vlan, and wait for more similar
usecases before this rule can be generalized.

OK?

Thanks.
