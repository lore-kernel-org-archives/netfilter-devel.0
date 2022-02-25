Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E753C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 12:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbiBYMbF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 07:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiBYMbE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 07:31:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5762177C0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Feb 2022 04:30:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nNZjy-0002Xh-TN; Fri, 25 Feb 2022 13:30:30 +0100
Date:   Fri, 25 Feb 2022 13:30:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, hmmsjan@kpnplanet.nl
Subject: TCP connection fails in a asymmetric routing situation
Message-ID: <20220225123030.GK28705@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=2051413

Gist is:
as of 878aed8db324bec64f3c3f956e64d5ae7375a5de
(" netfilter: nat: force port remap to prevent shadowing well-known
 port"), tcp connections won't get established with asymmetric routing
setups.

Workaround: Block conntrack for  LAN-LAN2 traffic by
iptables  -t raw -A PREROUTING -j CT --notrack
Or: echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose

I'd guess that is because conntrack picks up the flow on syn-ack rather
than syn, snat check then thinks that source port is < 16384 and dest
port is large, so we do port rewrite but we do it on syn-ack and
connection cannot complete because client and server have different
views of the source ports involved.

Question is on how this can be prevented. I see a few solutions:

1. Change ct->local_origin to "ct->no_srcremap" (or a new status bit)
that indicates that this should not have src remap done, just like we
do for locally generated connections.

2. Add a new "mid-stream" status bit, then bypass the entire -t nat
logic if its set. nf_nat_core would create a null binding for the
flow, this also bypasses the "src remap" code.

3. Simpler version: from tcp conntrack, set the nat-done status bits
if its a mid-stream pickup.

Downside: nat engine (as-is) won't create a null binding, so connection
will not be known to nat engine for masquerade source port clash
detection.

I would go for 2) unless you have a better suggestion/idea.

Thanks!
