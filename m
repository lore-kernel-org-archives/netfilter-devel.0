Return-Path: <SRS0=o+8a=XX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53DAC4360C
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Sep 2019 08:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E36B20815
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Sep 2019 08:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfI1IYB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Sep 2019 04:24:01 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52398 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbfI1IYA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Sep 2019 04:24:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iE81G-0000Hq-Ub; Sat, 28 Sep 2019 10:23:58 +0200
Date:   Sat, 28 Sep 2019 10:23:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Please add Bridge NAT in nftables
Message-ID: <20190928082358.GJ9938@breakpoint.cc>
References: <NLT8x0veXvaS6Jvm2H2CHRbzeh2NPv1MBDGtt0t6C47TmsNN6vIjIw42_v6fGXIw552q8AUllbB4Lb09HXVihl_s5cgY9rZVC6qTMIQWaSc=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NLT8x0veXvaS6Jvm2H2CHRbzeh2NPv1MBDGtt0t6C47TmsNN6vIjIw42_v6fGXIw552q8AUllbB4Lb09HXVihl_s5cgY9rZVC6qTMIQWaSc=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ttttabcd <ttttabcd@protonmail.com> wrote:
> The NAT function is included in ebtables (although it is very simple, but it is better than nothing), but I did not find the corresponding function in nftables.

You can do stateless mac nat like this:
add rule ... ether saddr set 00:0f:54:0c:11:4

or, with anon map:
add rule ... ether saddr set ip saddr map { 192.168.1.50 :
	00:0f:54:0c:11:4, 192.168.1.100 : 0f:54:0c:11:42 }

or with named map:

add table bridge mynat
add map bridge mynat mymacnatmap "{ type ipv4_addr : ether_addr; flags timeout; }
add rule ... ether saddr set ip saddr map @mynatmap
