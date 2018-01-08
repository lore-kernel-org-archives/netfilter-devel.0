From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3] netfilter: nf_defrag: Skip defrag if NOTRACK
 is set
Date: Mon, 8 Jan 2018 14:32:06 +0100
Message-ID: <20180108133206.2uvpgoxa5qdywrzp@salvia>
References: <1515039887-25798-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933412AbeAHNgp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 08:36:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBD1BA8208
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:36:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABB8D11A4DD
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:36:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515039887-25798-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

One more concern before this gets upstream.

On Wed, Jan 03, 2018 at 09:24:47PM -0700, Subash Abhinov Kasiviswanathan wrote:
> conntrack defrag is needed only if some module like CONNTRACK or NAT
> explicitly requests it. For plain forwarding scenarios, defrag is
> not needed and can be skipped if NOTRACK is set in a rule.
> 
> Since conntrack defrag is currently higher priority than raw table,
> setting NOTRACK is not sufficient. We need to move raw to a higher
> priority for iptables only.
> 
> This is achieved by introducing a module parameter which allows to
> modify the priority. By default, the priority is NF_IP_PRI_RAW to
> support legacy behavior.
> 
> v1->v2: Instead of modifying NF_IP_PRI_RAW itself, use a module
> parameter to pass in the priority during module load as suggested
> by Pablo. Also update commit text.
> 
> v2->v3: Implement similar functionality for IPv6 as well
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/ipv4/netfilter/iptable_raw.c          | 14 +++++++++++++-
>  net/ipv4/netfilter/nf_defrag_ipv4.c       |  2 +-
>  net/ipv6/netfilter/ip6table_raw.c         | 14 +++++++++++++-
>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  3 +++
>  4 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
> index 2642ecd..607392b 100644
> --- a/net/ipv4/netfilter/iptable_raw.c
> +++ b/net/ipv4/netfilter/iptable_raw.c
> @@ -12,7 +12,11 @@
>  
>  static int __net_init iptable_raw_table_init(struct net *net);
>  
> -static const struct xt_table packet_raw = {
> +static int priority __read_mostly = NF_IP_PRI_RAW;
> +MODULE_PARM_DESC(priority, "Priority of IPv4 raw table (NF_IP_PRI_RAW)");
> +module_param(priority, int, 0000);

Do you think we can turn this into an on/off knob instead?

I mean, I think it's good if you add a new
NF_IP_PRI_RAW_BEFORE_DEFRAG and we place it into uapi.

I'm just worried about follow up patches from people asking to making
this flexible in all other existing tables, I would like this does not
happen :-).

> +
> +static struct xt_table packet_raw = {
>  	.name = "raw",
>  	.valid_hooks =  RAW_VALID_HOOKS,
>  	.me = THIS_MODULE,
> @@ -70,6 +74,14 @@ static int __init iptable_raw_init(void)
>  {
>  	int ret;
>  
> +	if (priority < NF_IP_PRI_CONNTRACK_DEFRAG &&
> +	    priority > NF_IP_PRI_FIRST) {
> +		packet_raw.priority = priority;
> +
> +		pr_info("iptable_raw: Using custom rule priority=%d\n",
                         ^^^^^^^^^^^^

Probably better if you add:

        #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

in this patch while on this.

Thanks for your patience, we're almost there.
