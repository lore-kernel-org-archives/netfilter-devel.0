Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51023C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 291AD20863
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 16:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfIHQVx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 12:21:53 -0400
Received: from correo.us.es ([193.147.175.20]:52690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfIHQVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 12:21:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE517EBAC3
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:21:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEEFBDA4D0
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:21:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4B23DA7B6; Sun,  8 Sep 2019 18:21:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 773ECDA4D0;
        Sun,  8 Sep 2019 18:21:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 18:21:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 54CE34265A5A;
        Sun,  8 Sep 2019 18:21:47 +0200 (CEST)
Date:   Sun, 8 Sep 2019 18:21:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 4/4] netfilter: nf_offload: clean offload
 things when the device unregister
Message-ID: <20190908162148.eble5o6zuo7k5zx4@salvia>
References: <1567952336-23669-1-git-send-email-wenxu@ucloud.cn>
 <1567952336-23669-5-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567952336-23669-5-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 08, 2019 at 10:18:56PM +0800, wenxu@ucloud.cn wrote:
> +static int nft_offload_netdev_event(struct notifier_block *this,
> +				    unsigned long event, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct net *net = dev_net(dev);
> +	struct nft_chain *chain;
> +
> +	mutex_lock(&net->nft.commit_mutex);
> +	chain = __nft_offload_get_chain(dev);
> +	if (chain)
> +		nft_offload_chain_clean(chain);
> +	mutex_unlock(&net->nft.commit_mutex);
> +
> +	return NOTIFY_DONE;
> +}

Please, could you update nft_indr_block_cb() to use
__nft_offload_get_chain() in this series?

Like this, you fix all the problems already in the tree (missing
mutex, missing check for offload hardware flag...) in one single go?

Thank you.
