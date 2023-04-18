Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3BDC77B71
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 08:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjDRIRj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 04:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDRIRi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 04:17:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7A1C1FF0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 01:17:36 -0700 (PDT)
Date:   Tue, 18 Apr 2023 10:17:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZD5SHAuK23E+DD2C@calendula>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
 <ZDfFmMfS406teiUj@calendula>
 <ZDjN4gyv0x1aewgm@google.com>
 <ZDkK3ktVcBaykTVT@calendula>
 <ZDy/9WEIQRyIPSNo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDy/9WEIQRyIPSNo@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Apr 17, 2023 at 11:41:41AM +0800, Tzung-Bi Shih wrote:
> On Fri, Apr 14, 2023 at 10:12:14AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Apr 14, 2023 at 11:52:02AM +0800, Tzung-Bi Shih wrote:
> > > On Thu, Apr 13, 2023 at 11:04:24AM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, Apr 13, 2023 at 11:23:11AM +0800, Tzung-Bi Shih wrote:
> > > > > nf_ct_expires() got called by userspace program.  And the return
> > > > > value (which means the remaining timeout) will be the parameter for
> > > > > the next ctnetlink_change_timeout().
> > > > 
> > > > Unconfirmed conntrack is owned by the packet that refers to it, it is
> > > > not yet in the hashes. I don't see how concurrent access to the
> > > > timeout might occur.
> > > > 
> > > > Or are you referring to a different scenario that triggers the partial
> > > > state?
> > > 
> > > I think it isn't a concurrent access.  We observed that userspace program
> > > reads the remaining timeout and sets it back for unconfirmed conntrack.
> > > 
> > > Conceptually, it looks like:
> > > timeout = nf_ct_expires(...);  (1)
> > > ctnetlink_change_timeout(...timeout);
> > 
> > How could this possibly happen?
> > 
> > nf_ct_expires() is called from:
> > 
> > - ctnetlink_dump_timeout(), this is netlink dump path, since:
> > 
> > commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Mon Apr 11 13:01:18 2022 +0200
> > 
> >     netfilter: conntrack: remove the percpu dying list
> > 
> > it is not possible to do any listing of unconfirmed, and that is fine.
> > 
> > As I said, nfnetlink_queue operates with an unconfirmed conntrack with
> > owns exclusively, which is not in the hashes.
> 
> I applied the following patches on top of v6.3-rc5[5].
> 
> As you suggested:
> 
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index 71d1269fe4d4..3384859a8921 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -89,7 +89,11 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
>  {
>         if (timeout > INT_MAX)
>                 timeout = INT_MAX;
> -       WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
> +
> +       if (nf_ct_is_confirmed(ct))
> +               WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
> +       else
> +               ct->timeout = (u32)timeout;
>  }
>  
> And this patch for dumping the debug information:
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index bfc3aaa2c872..b4c016ff07e9 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -178,6 +178,11 @@ static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
>  {
>         long timeout = nf_ct_expires(ct) / HZ;
>  
> +       if (!nf_ct_is_confirmed(ct)) {
> +               dump_stack();
> +               printk(KERN_ERR "===ct->timeout=%u===timeout=%ld\n", ct->timeout, timeout);
> +       }
> +
>         if (skip_zero && timeout == 0)
>                 return 0;
> 
> And here is the trimmed dmesg:
> 
> ===ct->timeout=30000===timeout=0
> [...] 6.3.0-rc5-00675-ged0c7cbf5b2c [...]
> Call Trace:
>  <TASK>
>  dump_stack_lvl
>  ctnetlink_dump_timeout
>  __ctnetlink_glue_build
>  ctnetlink_glue_build
>  __nfqnl_enqueue_packet
>  nf_queue
>  nf_hook_slow
>  ip_mc_output
>  ? __pfx_ip_finish_output
>  ip_send_skb
>  ? __pfx_dst_output
>  udp_send_skb
>  udp_sendmsg
>  ? __pfx_ip_generic_getfrag
>  sock_sendmsg
> 
> As the dmesg showed, the unconfirmed conntrack did call into
> ctnetlink_dump_timeout().  As a result, the value returned from
> nf_ct_expires() is always 0 in the case (because the `ct->timeout` got
> subtracted by current timestamp `nfct_time_stamp`[4]).

Oh, interesting.

Thanks for digging deeper into this issue.

Then, on top of what I suggest, my recommendation is to skip the
ctnetlink_dump_timeout() call for !nf_ct_confirmed(ct).

Or, you add some special handling for ctnetlink_dump_timeout() for the
!nf_ct_confirmed(ct) case.

Let me know, thanks.

> [4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296
> [5]: https://chromium.googlesource.com/chromiumos/third_party/kernel/+/refs/heads/merge/continuous/chromeos-kernelupstream-6.3-rc5
