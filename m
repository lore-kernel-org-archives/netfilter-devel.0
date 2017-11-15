From: Jay Elliott <jelliott@arista.com>
Subject: Re: [PATCH v3] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Wed, 15 Nov 2017 10:59:35 -0800
Message-ID: <CA+c2rSgrP9OC4u4rcXbeeGZsKLxjoLiwRJZ0Q1pwi6LM31=qLA@mail.gmail.com>
References: <1510745490-26272-1-git-send-email-jelliott@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jay Elliott <jelliott@arista.com>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:53863 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758602AbdKOS74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2017 13:59:56 -0500
Received: by mail-qt0-f195.google.com with SMTP id n61so36742776qte.10
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2017 10:59:56 -0800 (PST)
In-Reply-To: <1510745490-26272-1-git-send-email-jelliott@arista.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, I just realized I made a mistake in this patch by forgetting to
cast the timeout to 64-bit before multiplying by HZ.  I'll fix it and
send out another version in a little bit.

Sorry about the unnecessary e-mail traffic.

Thanks,
Jay Elliott

On Wed, Nov 15, 2017 at 3:31 AM, Jay Elliott <jelliott@arista.com> wrote:
> When the conntracking code multiplies a timeout by HZ, it can overflow
> from positive to negative; this causes it to instantly expire.  To
> protect against this the multiplication is done in 64-bit so we can
> prevent it from exceeding INT_MAX.
>
> Signed-off-by: Jay Elliott <jelliott@arista.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index de4053d..3a336bb 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1560,9 +1560,11 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
>  static int ctnetlink_change_timeout(struct nf_conn *ct,
>                                     const struct nlattr * const cda[])
>  {
> -       u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
> +       u64 timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
>
> -       ct->timeout = nfct_time_stamp + timeout * HZ;
> +       if (timeout > INT_MAX)
> +               timeout = INT_MAX;
> +       ct->timeout = nfct_time_stamp + (u32)timeout;
>
>         if (test_bit(IPS_DYING_BIT, &ct->status))
>                 return -ETIME;
> @@ -1762,6 +1764,7 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>         int err = -EINVAL;
>         struct nf_conntrack_helper *helper;
>         struct nf_conn_tstamp *tstamp;
> +       u64 timeout;
>
>         ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
>         if (IS_ERR(ct))
> @@ -1770,7 +1773,10 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>         if (!cda[CTA_TIMEOUT])
>                 goto err1;
>
> -       ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
> +       timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
> +       if (timeout > INT_MAX)
> +               timeout = INT_MAX;
> +       ct->timeout = (u32)timeout + nfct_time_stamp;
>
>         rcu_read_lock();
>         if (cda[CTA_HELP]) {
> --
> 1.8.1.4
>
