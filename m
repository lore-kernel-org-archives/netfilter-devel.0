Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D56C31E5E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58F9720873
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfFRQkM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 12:40:12 -0400
Received: from mail.us.es ([193.147.175.20]:51428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfFRQkL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 12:40:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE70D443825
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:40:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF79EDA70F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:40:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4D74DA70C; Tue, 18 Jun 2019 18:40:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A645CDA705;
        Tue, 18 Jun 2019 18:40:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 18:40:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 85ED14265A2F;
        Tue, 18 Jun 2019 18:40:07 +0200 (CEST)
Date:   Tue, 18 Jun 2019 18:40:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: bridge: add nft_bridge_pvid to tag
 the default pvid for non-tagged packet
Message-ID: <20190618164007.suuaa5zx2b242ey7@salvia>
References: <1560600861-8848-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560600861-8848-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 15, 2019 at 08:14:21PM +0800, wenxu@ucloud.cn wrote:
[...]
> +static void nft_bridge_pvid_eval(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt)
> +{
> +	struct sk_buff *skb = pkt->skb;
> +	struct net_bridge_port *p;
> +
> +	p = br_port_get_rtnl_rcu(skb->dev);
> +
> +	if (p && br_opt_get(p->br, BROPT_VLAN_ENABLED) &&
> +	    !skb_vlan_tag_present(skb)) {
> +		u16 pvid = br_get_pvid(nbp_vlan_group_rcu(p));
> +
> +		if (pvid)
> +			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, pvid);

I see two things here:

#1 Extend new NFT_META_BRIDGE_PVID nft_meta to fetch of 'pvid',
   probably add net/bridge/netfilter/nft_meta_bridge.c for this.

#2 Extend nft_meta to allow to set the vlan tag via
   __vlan_hwaccel_put_tag().

If these two changes are in place, then it should be possible to set
skbuff vlan id based on the pvid, if this is what you need.

This would allow for:

        vlan id set bridge pvid
