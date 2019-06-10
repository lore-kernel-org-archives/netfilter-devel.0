Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0358C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 17:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C62502082E
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 17:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbfFJRll (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 13:41:41 -0400
Received: from mail.us.es ([193.147.175.20]:36882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfFJRll (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 13:41:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 217CFC1A29
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 19:41:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E88ADA717
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 19:41:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F23EFDA711; Mon, 10 Jun 2019 19:41:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC6E3DA702;
        Mon, 10 Jun 2019 19:41:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 19:41:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6EDBF4265A2F;
        Mon, 10 Jun 2019 19:41:36 +0200 (CEST)
Date:   Mon, 10 Jun 2019 19:41:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian Brauner <christian@brauner.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de
Subject: Re: [PATCH net-next v1 1/1] br_netfilter: namespace bridge netfilter
 sysctls
Message-ID: <20190610174136.p3fbcbn33en5bb7f@salvia>
References: <20190609162304.3388-1-christian@brauner.io>
 <20190609162304.3388-2-christian@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609162304.3388-2-christian@brauner.io>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for updating this patch to use struct brnf_net.

A few comments below.

On Sun, Jun 09, 2019 at 06:23:04PM +0200, Christian Brauner wrote:
[...]
> diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
> index 89808ce293c4..302fcd3aade2 100644
> --- a/include/net/netfilter/br_netfilter.h
> +++ b/include/net/netfilter/br_netfilter.h
> @@ -85,17 +82,42 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
>  		return 0;
>  }
>  
> -#define IS_VLAN_IP(skb) \
> -	(vlan_proto(skb) == htons(ETH_P_IP) && \
> -	 brnf_filter_vlan_tagged)
> +static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
> +{

I like this conversion from macro to static inline a lot.

But if you let me ask for one more change, would you split this in two
patches? One to replace #defines by static inline.

Then, second patch introduces the sysctl update you need.

It will make it easier for me to review.

[...]
> +static inline bool is_vlan_ipv6(const struct sk_buff *skb,
> +				const struct net *net)
> +{
> +#ifdef CONFIG_SYSCTL

Probably we can reduce #ifdef pollution a bit if you always add
'filter_vlan_tagged' and other fields to the brnf_net structure. No
matter if CONFIG_SYSCTL is set on or off. I think it's worth consuming
a bit more memory to simplify this code, so both CONFIG_SYSCTL=y and
CONFIG_SYSCTL=n run the same codepath.

Most vendors will just turn on to CONFIG_SYSCTL=y, and I don't think
it's worth the extra code for the CONFIG_SYSCTL=n case.

> +	struct brnf_net *brnet = net_generic(net, brnf_net_id);
> +
> +	return (vlan_proto(skb) == htons(ETH_P_IPV6) &&
> +		brnet->filter_vlan_tagged);
> +#else
> +	return (vlan_proto(skb) == htons(ETH_P_IPV6));

BTW, I think parens are not needed, ie.

	return vlan_proto(skb) == htons(ETH_P_IPV6);

should be fine?

Thanks!
