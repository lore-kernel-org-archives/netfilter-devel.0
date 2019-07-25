Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CAAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 496052083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389931AbfGYKUx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:20:53 -0400
Received: from mail.us.es ([193.147.175.20]:49922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387948AbfGYKUw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:20:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DBE52FB6C6
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC2E4DA708
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1CACDA732; Thu, 25 Jul 2019 12:20:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC962115109;
        Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6E6694265A31;
        Thu, 25 Jul 2019 12:20:48 +0200 (CEST)
Date:   Thu, 25 Jul 2019 12:20:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190725102045.xrs327ksgkyzzl5h@salvia>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 05:55:31PM +0800, wenxu@ucloud.cn wrote:
> +struct flow_indr_block_dev {
> +	struct rhash_head ht_node;
> +	struct net_device *dev;
> +	unsigned int refcnt;
> +	struct list_head cb_list;
> +	flow_indr_block_ing_cmd_t *cmd_cb;
> +	void *block;

There's now a flow_block object in order to avoid void * which is
prone to bugs later on since the compiler cannot make type validation
anymore.
