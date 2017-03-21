From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3 2/2] netfilter: helper: Fix possible panic caused
 by invoking expectfn unloaded
Date: Tue, 21 Mar 2017 15:13:29 +0100
Message-ID: <20170321141329.GA12171@salvia>
References: <cover.1490060879.git.fgao@ikuai8.com>
 <b30c3340a5b543d5544ced6aae5c7d585d423328.1490060879.git.fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree_wind@126.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757319AbdCUONp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:13:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0029170D33
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:13:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0932FB452
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:13:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5A71FB464
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:13:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <b30c3340a5b543d5544ced6aae5c7d585d423328.1490060879.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 02:06:26PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because the conntrack NAT module could be rmmod anytime, so we should
> really leave things in clean state if such thing happens and make sure
> we don't leave any packet running over code that will be gone after
> the removal.
> 
> We only removed the expectations when unregister conntrack helper before.
> Actually it is necessary too when remove the nat helper.

We still need something like this, right?

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 791fac4fd745..38f1ed5219e4 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -377,6 +377,7 @@ static unsigned int nf_nat_sip_expect(struct
sk_buff *skb, unsigned int protoff,
        exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
        exp->dir = !dir;
        exp->expectfn = nf_nat_sip_expected;
+       exp->nat_module = THIS_MODULE;
 
        for (; port != 0; port++) {
                int ret;

So if the user invokes:

        rmmod nf_nat_sip

we can get rid of this expectation from nf_ct_flush_expect().
