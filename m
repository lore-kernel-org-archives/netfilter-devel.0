Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9A3C432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 12:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E01420714
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 12:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKVMcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 07:32:35 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34044 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfKVMcf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 07:32:35 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iY86z-0005dP-G1; Fri, 22 Nov 2019 13:32:33 +0100
Date:   Fri, 22 Nov 2019 13:32:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Mysql has problem with synproxy
Message-ID: <20191122123233.GE2284@breakpoint.cc>
References: <CAK6Qs9k0Z9US9u3OWhO4_DTjU1+zY5wXpARu6=cwgVOPx8jP2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9k0Z9US9u3OWhO4_DTjU1+zY5wXpARu6=cwgVOPx8jP2Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

İbrahim Ercan <ibrahim.metu@gmail.com> wrote:
> iptables -t raw -A PREROUTING -i enp12s0f0 -p tcp --syn -j CT --notrack
> iptables -t filter -A FORWARD  -i enp12s0f0 -p tcp -m state --state
> INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --mss 1460
> --wscale 6
> iptables -t filter -A FORWARD -i enp12s0f0 -p tcp -m state --state
> INVALID -j DROP

Does it work when you omit --timestamp?

> Between firewall and server
> 14:28:12.343459 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [S], seq 1356993242, win 229, options [mss 1460,sackOK,TS val 1731042 ecr 1423321111,nop,wscale 7], length 0

Oh, this is a bug, but I don't know if that is the reason for the
failure.  ecr should be 0 reset to 0.

I susepct this patch would fix it:

diff --git a/net/netfilter/nf_synproxy_core.c
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -174,6 +174,7 @@ synproxy_check_timestamp_cookie(struct synproxy_options *opts)
        opts->options |= opts->tsecr & (1 << 4) ?
	NF_SYNPROXY_OPT_SACK_PERM : 0;
 
        opts->options |= opts->tsecr & (1 << 5) ?
	NF_SYNPROXY_OPT_ECN : 0;
+       opts->tsecr = 0;
 }
 
> 14:28:12.343583 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [S.], seq 1666149016, ack 1356993243, win 65535, options [mss 1460,nop,wscale 6,sackOK,TS val 109930553 ecr 1731042], length 0
> 14:28:12.343602 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [.], ack 1, win 229, options [nop,nop,TS val 1731042 ecr 3091507291], length 0

I assume the 'ack 1' is tcpdump being too helpful? (-S to disable).
I can't see anything wrong here, sorry.

