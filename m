Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E0FC25B4E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Jan 2023 11:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjATL6E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Jan 2023 06:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjATL6E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2023 06:58:04 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A076AD11;
        Fri, 20 Jan 2023 03:58:02 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:57:59 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v3 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Message-ID: <Y8qBx6gOJJH2Y7FE@salvia>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-3-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230119195104.3371966-3-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 19, 2023 at 08:50:59PM +0100, Vlad Buslov wrote:
> Currently flow_offload_fixup_ct() function assumes that only replied UDP
> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value. To
> enable UDP NEW connection offload in following patches extract the actual
> connections state from ct->status and set the timeout according to it.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 81c26a96c30b..04bd0ed4d2ae 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -193,8 +193,11 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
>  		timeout -= tn->offload_timeout;
>  	} else if (l4num == IPPROTO_UDP) {
>  		struct nf_udp_net *tn = nf_udp_pernet(net);
> +		enum udp_conntrack state =
> +			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> +			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
>  
> -		timeout = tn->timeouts[UDP_CT_REPLIED];
> +		timeout = tn->timeouts[state];
>  		timeout -= tn->offload_timeout;

For netfilter's flowtable (not talking about act_ct), this is a
"problem" because the flowtable path update with ct->status flags.
In other words, for netfilter's flowtable UDP_CT_UNREPLIED timeout
will be always used for UDP traffic if it is offloaded and no traffic
from the classic path was seen.

If packets go via hardware offload, the host does not see packets in
the reply direction (unless hardware counters are used to set on
IPS_SEEN_REPLY_BIT?).

Then, there is also IPS_ASSURED: Netfilter's flowtable assumes that
TCP flows are only offloaded to hardware if IPS_ASSURED.
