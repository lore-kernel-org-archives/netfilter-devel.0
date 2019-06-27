Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ADBC48BE4
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 18:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B9D420645
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 18:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF0S5t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:57:49 -0400
Received: from mail.us.es ([193.147.175.20]:48660 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfF0S5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 14:57:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D473EA46E
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 20:57:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B11FDA3F4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 20:57:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 00A35DA732; Thu, 27 Jun 2019 20:57:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4D40DA732;
        Thu, 27 Jun 2019 20:57:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 20:57:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 94EBA4265A32;
        Thu, 27 Jun 2019 20:57:44 +0200 (CEST)
Date:   Thu, 27 Jun 2019 20:57:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        ibrahim.metu@gmail.com
Subject: Re: [PATCH v2] netfilter: synproxy: erroneous TCP mss option fixed.
Message-ID: <20190627185744.ynxyes7an6gd7hlg@salvia>
References: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
 <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 25, 2019 at 08:42:04AM +0300, Ibrahim Ercan wrote:
> Syn proxy isn't setting mss value correctly on client syn-ack packet.
> It was sending same mss value with client send instead of the value user set in iptables rule. This patch fix that wrong behavior by passing client mss information to synproxy_send_client_synack correctly.
> 
> Signed-off-by: Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>
> ---
>  net/ipv4/netfilter/ipt_SYNPROXY.c  | 9 ++++++---
>  net/ipv6/netfilter/ip6t_SYNPROXY.c | 9 ++++++---
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
> index 64d9563..e0bd504 100644
> --- a/net/ipv4/netfilter/ipt_SYNPROXY.c
> +++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
> @@ -69,13 +69,13 @@ synproxy_send_tcp(struct net *net,
>  static void
>  synproxy_send_client_synack(struct net *net,
>  			    const struct sk_buff *skb, const struct tcphdr *th,
> -			    const struct synproxy_options *opts)
> +			    const struct synproxy_options *opts, const u16 client_mssinfo)
>  {
>  	struct sk_buff *nskb;
>  	struct iphdr *iph, *niph;
>  	struct tcphdr *nth;
>  	unsigned int tcp_hdr_size;
> -	u16 mss = opts->mss;
> +	u16 mss = client_mssinfo;
>  
>  	iph = ip_hdr(skb);
>  
> @@ -264,6 +264,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>  	struct synproxy_net *snet = synproxy_pernet(net);
>  	struct synproxy_options opts = {};
>  	struct tcphdr *th, _th;
> +	u16 client_mssinfo;
>  
>  	if (nf_ip_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
>  		return NF_DROP;
> @@ -283,6 +284,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>  			opts.options |= XT_SYNPROXY_OPT_ECN;
>  
>  		opts.options &= info->options;
> +		client_mssinfo = opts.mss;
> +		opts.mss = info->mss;

No need for this new client_mssinfo variable, right? I mean, you can
just set:

        opts.mss = info->mss;

and use it from synproxy_send_client_synack().

This patch will be smaller.

>  		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
>  			synproxy_init_timestamp_cookie(info, &opts);
>  		else
> @@ -290,7 +293,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>  					  XT_SYNPROXY_OPT_SACK_PERM |
>  					  XT_SYNPROXY_OPT_ECN);
>  
> -		synproxy_send_client_synack(net, skb, th, &opts);
> +		synproxy_send_client_synack(net, skb, th, &opts, client_mssinfo);
>  		consume_skb(skb);
>  		return NF_STOLEN;
>  	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
