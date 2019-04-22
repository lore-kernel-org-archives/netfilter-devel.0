Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A26C282E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E62220656
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfDVIeE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 04:34:04 -0400
Received: from mail.us.es ([193.147.175.20]:40324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbfDVIeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 04:34:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38C9D27F8CF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:34:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A4ECDA709
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:34:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19E37DA714; Mon, 22 Apr 2019 10:34:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7CB7DA705;
        Mon, 22 Apr 2019 10:33:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 10:33:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AD7F44265A31;
        Mon, 22 Apr 2019 10:33:59 +0200 (CEST)
Date:   Mon, 22 Apr 2019 10:33:59 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Rundong Ge <rdong.ge@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix dangling pointer access of fake_rtable
Message-ID: <20190422083339.ptkxqb66pombgy5g@salvia>
References: <20190409065612.32652-1-rdong.ge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409065612.32652-1-rdong.ge@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 06:56:12AM +0000, Rundong Ge wrote:
[...]
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 0dcc359..57eb02d 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -905,13 +905,25 @@ static void free_entry(struct nf_queue_entry *entry)
>  dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
>  {
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> -	int physinif, physoutif;
> +	struct net_device *physindev, *physoutdev;
> +	struct net_bridge_port *port;
>  
> -	physinif = nf_bridge_get_physinif(entry->skb);
> -	physoutif = nf_bridge_get_physoutif(entry->skb);
> -
> -	if (physinif == ifindex || physoutif == ifindex)
> -		return 1;
> +	physindev = nf_bridge_get_physindev(entry->skb);
> +	physoutdev = nf_bridge_get_physoutdev(entry->skb);
> +	if (physindev) {
> +		if (physindev->ifindex == ifindex)
> +			return 1;
> +		port = br_port_get_rcu(physindev);
> +		if (port && port->br->dev->ifindex == ifindex)
> +			return 1;
> +	}
> +	if (physoutdev) {
> +		if (physoutdev->ifindex == ifindex)
> +			return 1;
> +		port = br_port_get_rcu(physoutdev);
> +		if (port && port->br->dev->ifindex == ifindex)
> +			return 1;
> +	}

Either entry->state.in and entry->state.out point to the bridge
device, after this #endif.

>  #endif
>  	if (entry->state.in)
>  		if (entry->state.in->ifindex == ifindex)
> -- 
> 1.8.3.1
> 
