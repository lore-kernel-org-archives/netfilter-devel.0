Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A1FC77B61
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Apr 2023 03:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDQDls (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Apr 2023 23:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDQDlr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Apr 2023 23:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A69B0
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37A1061CDB
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Apr 2023 03:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503F1C433EF;
        Mon, 17 Apr 2023 03:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681702904;
        bh=sfLnjzF59Ra7XqoASPU7HFUjKoZJzydJloeFrd23+kA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=so+EsRBJVrpji7Sp0XuhuhCLw5z0FjiWrJpWmX6WQvSQI7Pyk2WFAIiCXJuJyAmXu
         1F/HKdG5ISKKw9dnOPCM/oerFPKnqvxy0Boj6LzwRuUQdIDC8bn6bWXcVZzg2N4g5S
         LMGTfwiGmShX+pzmKf6tu6AEBbc2akTtCBUyxemAFpb9j5o/XQjeu+QPFUSUfYoHPh
         x+JpmJ/AJA+MBDgKv8RLJNOTKuqpWbyJX26vEBB7ZNKqvX/euTiyUGAfzFWEn3JKEQ
         46QYU5RWsgN+tt4tahWtNONiDdi8zR7ilX2hbW456MG/CK3jNxg5iLHBQKPwxMs0dq
         dHpW9DfuYUhOw==
Date:   Mon, 17 Apr 2023 11:41:41 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDy/9WEIQRyIPSNo@google.com>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
 <ZDfFmMfS406teiUj@calendula>
 <ZDjN4gyv0x1aewgm@google.com>
 <ZDkK3ktVcBaykTVT@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDkK3ktVcBaykTVT@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 14, 2023 at 10:12:14AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 14, 2023 at 11:52:02AM +0800, Tzung-Bi Shih wrote:
> > On Thu, Apr 13, 2023 at 11:04:24AM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 13, 2023 at 11:23:11AM +0800, Tzung-Bi Shih wrote:
> > > > nf_ct_expires() got called by userspace program.  And the return
> > > > value (which means the remaining timeout) will be the parameter for
> > > > the next ctnetlink_change_timeout().
> > > 
> > > Unconfirmed conntrack is owned by the packet that refers to it, it is
> > > not yet in the hashes. I don't see how concurrent access to the
> > > timeout might occur.
> > > 
> > > Or are you referring to a different scenario that triggers the partial
> > > state?
> > 
> > I think it isn't a concurrent access.  We observed that userspace program
> > reads the remaining timeout and sets it back for unconfirmed conntrack.
> > 
> > Conceptually, it looks like:
> > timeout = nf_ct_expires(...);  (1)
> > ctnetlink_change_timeout(...timeout);
> 
> How could this possibly happen?
> 
> nf_ct_expires() is called from:
> 
> - ctnetlink_dump_timeout(), this is netlink dump path, since:
> 
> commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Apr 11 13:01:18 2022 +0200
> 
>     netfilter: conntrack: remove the percpu dying list
> 
> it is not possible to do any listing of unconfirmed, and that is fine.
> 
> As I said, nfnetlink_queue operates with an unconfirmed conntrack with
> owns exclusively, which is not in the hashes.

I applied the following patches on top of v6.3-rc5[5].

As you suggested:

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71d1269fe4d4..3384859a8921 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -89,7 +89,11 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
        if (timeout > INT_MAX)
                timeout = INT_MAX;
-       WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+
+       if (nf_ct_is_confirmed(ct))
+               WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+       else
+               ct->timeout = (u32)timeout;
 }
 
And this patch for dumping the debug information:

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bfc3aaa2c872..b4c016ff07e9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -178,6 +178,11 @@ static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
 {
        long timeout = nf_ct_expires(ct) / HZ;
 
+       if (!nf_ct_is_confirmed(ct)) {
+               dump_stack();
+               printk(KERN_ERR "===ct->timeout=%u===timeout=%ld\n", ct->timeout, timeout);
+       }
+
        if (skip_zero && timeout == 0)
                return 0;

And here is the trimmed dmesg:

===ct->timeout=30000===timeout=0
[...] 6.3.0-rc5-00675-ged0c7cbf5b2c [...]
Call Trace:
 <TASK>
 dump_stack_lvl
 ctnetlink_dump_timeout
 __ctnetlink_glue_build
 ctnetlink_glue_build
 __nfqnl_enqueue_packet
 nf_queue
 nf_hook_slow
 ip_mc_output
 ? __pfx_ip_finish_output
 ip_send_skb
 ? __pfx_dst_output
 udp_send_skb
 udp_sendmsg
 ? __pfx_ip_generic_getfrag
 sock_sendmsg

As the dmesg showed, the unconfirmed conntrack did call into
ctnetlink_dump_timeout().  As a result, the value returned from
nf_ct_expires() is always 0 in the case (because the `ct->timeout` got
subtracted by current timestamp `nfct_time_stamp`[4]).

[4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296
[5]: https://chromium.googlesource.com/chromiumos/third_party/kernel/+/refs/heads/merge/continuous/chromeos-kernelupstream-6.3-rc5
