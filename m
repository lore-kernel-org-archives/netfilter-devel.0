From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_flow_offload: fix use-after-free and a
 resource leak
Date: Wed, 7 Feb 2018 11:57:37 +0100
Message-ID: <20180207105737.2qq4ybincaw2vg5c@salvia>
References: <20180207084902.99290-1-nbd@nbd.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Fietkau <nbd@nbd.name>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbeBGK5k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 05:57:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13D8F1A098A
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 11:57:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 033EFDA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 11:57:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207084902.99290-1-nbd@nbd.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 09:49:02AM +0100, Felix Fietkau wrote:
> flow_offload_del frees the flow, so all associated resource must be
> freed before.
> 
> Since the ct entry in struct flow_offload_entry was allocated by
> flow_offload_alloc, it should be freed by flow_offload_free to take care
> of the error handling path when flow_offload_add fails.
> 
> While at it, make flow_offload_del static, since it should never be
> called directly, only from the gc step

Applied, thanks Felix!
