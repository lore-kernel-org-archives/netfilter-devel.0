Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2FDC04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 20:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5080D208C3
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 20:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfFFU43 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 16:56:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53442 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727511AbfFFU43 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 16:56:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYzQx-0003u0-JC; Thu, 06 Jun 2019 22:56:27 +0200
Date:   Thu, 6 Jun 2019 22:56:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vladimir Khailenko <vkhailenko@funio.com>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: How to use concatenation ipv4_addr . inet_proto . inet_service
Message-ID: <20190606205627.uw7i62z5hgaupkyn@breakpoint.cc>
References: <33D76666-7E5E-47A3-BBCB-F4FB29BA2311@funio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33D76666-7E5E-47A3-BBCB-F4FB29BA2311@funio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vladimir Khailenko <vkhailenko@funio.com> wrote:

[ CC netfilter-devel ]

> We can create a set with "ipv4_addr . inet_proto . inet_service":
> set allow_dns_ntp {
>   type ipv4_addr . inet_proto . inet_service
>   elements = { 1.2.3.4 . tcp . domain,
>                1.2.3.4 . udp . domain,
>                5.6.7.8 . udp . ntp }
> }
> 
> But how the we can use them?
> "iifname $nic_wan ip daddr . protocol . dport @allow_dns_ntp ct state new counter accept" - Does not work
> "iifname $nic_wan ip daddr . ip protocol . tcp dport @allow_dns_ntp ct state new counter accept" - this works, but does not have any sense…

Yes, that doesn't work.  This could work, with a small patch:

add rule inet filter input iifname lo  ip daddr . ip protocol . @th,16,16 @allow_dns_ntp ct state new counter accept

diff --git a/src/payload.c b/src/payload.c
--- a/src/payload.c
+++ b/src/payload.c
@@ -175,6 +175,11 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
        expr->payload.offset    = offset;
        expr->len               = len;
        expr->dtype             = &integer_type;
+
+       if (len == 16 && base == PROTO_BASE_TRANSPORT_HDR) {
+               if (offset == 0 || offset == 16)
+                       expr->dtype = &inet_service_type;
+       }
 }
