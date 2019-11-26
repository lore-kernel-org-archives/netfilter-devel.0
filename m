Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA55C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 14:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BFB92071A
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 14:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKZOxC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 09:53:02 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46852 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfKZOxC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 09:53:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iZcD4-0003x5-Jp; Tue, 26 Nov 2019 15:52:58 +0100
Date:   Tue, 26 Nov 2019 15:52:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191126145258.GE795@breakpoint.cc>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> Hello Florian,
> 
> Thank you very much for your reply. Once I changed to Input chain type, the rule worked. It seems iptables DO allow the same rule configuration see below:
> 
> -A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
> -A KUBE-SERVICES -d 57.131.151.19/32 -p tcp -m comment --comment "default/portal:portal has no endpoints" -m tcp --dport 8989 -j REJECT --reject-with icmp-port-unreachable

No idea how this could work:

iptables -t nat -A PREROUTING -j REJECT
iptables: Invalid argument. Run `dmesg' for more information.
dmesg | tail -1
x_tables: ip_tables: REJECT target: only valid in filter

That check has been there since beginning of git history.
