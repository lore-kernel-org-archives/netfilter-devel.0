Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F56C3A59E
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B5622DA9
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfHTLtp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:49:45 -0400
Received: from correo.us.es ([193.147.175.20]:54956 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbfHTLto (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 07:49:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7EA1FB363
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 13:49:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA955D1DBB
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 13:49:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D047ED2B1F; Tue, 20 Aug 2019 13:49:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAD21DA72F;
        Tue, 20 Aug 2019 13:49:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 13:49:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D64EF4265A2F;
        Tue, 20 Aug 2019 13:49:38 +0200 (CEST)
Date:   Tue, 20 Aug 2019 13:49:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2] netfilter: nfnetlink_log:add support for VLAN
 information
Message-ID: <20190820114937.5jk2ekeduqwb6d7i@salvia>
References: <20190820112617.18095-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820112617.18095-1-michael-dev@fami-braun.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 20, 2019 at 01:26:17PM +0200, Michael Braun wrote:
[...]
> diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
> index 20983cb195a0..45c8d3b027e0 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_log.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_log.h
> @@ -33,6 +33,15 @@ struct nfulnl_msg_packet_timestamp {
>  	__aligned_be64	usec;
>  };
>  
> +enum nfulnl_vlan_attr {
> +	NFULA_VLAN_UNSPEC,
> +	NFULA_VLAN_PROTO,		/* __be16 skb vlan_proto */
> +	NFULA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
> +	__NFULA_VLAN_MAX,
> +};
> +
> +#define NFULA_VLAN_MAX (__NFULA_VLAN_MAX + 1)
> +
>  enum nfulnl_attr_type {
>  	NFULA_UNSPEC,
>  	NFULA_PACKET_HDR,
> @@ -54,6 +63,8 @@ enum nfulnl_attr_type {
>  	NFULA_HWLEN,			/* hardware header length */
>  	NFULA_CT,                       /* nf_conntrack_netlink.h */
>  	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
> +	NFULA_VLAN,			/* nested attribute: packet vlan info */
> +	NFULA_L2HDR,			/* full L2 header */
>  
>  	__NFULA_MAX
>  };
> diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
> index ae5628ddbe6d..c127bcc119d8 100644
> --- a/net/netfilter/nf_log_common.c
> +++ b/net/netfilter/nf_log_common.c
> @@ -167,6 +167,8 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
>  	physoutdev = nf_bridge_get_physoutdev(skb);
>  	if (physoutdev && out != physoutdev)
>  		nf_log_buf_add(m, "PHYSOUT=%s ", physoutdev->name);
> +	if (skb_vlan_tag_present(skb))
> +		nf_log_buf_add(m, "VLAN=%d ", skb_vlan_tag_get_id(skb));
>  #endif
>  }
>  EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 6dee4f9a944c..dd5b63205d31 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -385,6 +385,40 @@ nfulnl_timer(struct timer_list *t)
>  	instance_put(inst);
>  }
>  
> +#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)

This could be used from nftables netdev family (ingress type chains),
I think you can remove this #if.

Unlike nfqueue, there's support for nfnetlink_log from nftables netdev
family. You can test it with this:

table netdev x {
        chain y {
                type filter hook ingress device "eth0" priority filter; policy accept;
                log prefix "test: " group 10
        }
}

I think you can safely remove this #if.

> +static int nfulnl_put_bridge(struct nfulnl_instance *inst, struct sk_buff *skb)
> +{
> +	if (!skb_mac_header_was_set(skb))
> +		return 0;
> +
> +	if (skb_vlan_tag_present(skb)) {
> +		struct nlattr *nest;
> +
> +		nest = nla_nest_start(inst->skb, NFULA_VLAN);
> +		if (!nest)
> +			goto nla_put_failure;
> +
> +		if (nla_put_be16(inst->skb, NFULA_VLAN_TCI, htons(skb->vlan_tci)) ||
> +		    nla_put_be16(inst->skb, NFULA_VLAN_PROTO, skb->vlan_proto))
> +			goto nla_put_failure;
> +
> +		nla_nest_end(inst->skb, nest);
> +	}
> +
> +	if (skb->mac_header < skb->network_header) {
> +		int len = (int)(skb->network_header - skb->mac_header);
> +
> +		if (nla_put(inst->skb, NFULA_L2HDR, len, skb_mac_header(skb)))
> +			goto nla_put_failure;
> +	}
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
> +#endif /* IS_ENABLED(CONFIG_BRIDGE_NETFILTER) */
> +
>  /* This is an inline function, we don't really care about a long
>   * list of arguments */
>  static inline int
> @@ -580,6 +614,12 @@ __build_packet_message(struct nfnl_log_net *log,
>  				 NFULA_CT, NFULA_CT_INFO) < 0)
>  		goto nla_put_failure;
>  
> +#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	if (pf == PF_BRIDGE &&

Allow for NFPROTO_NETDEV where too, please.

Thanks.
