From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] ebtables: remove nf_hook_register usage
Date: Mon, 24 Apr 2017 10:38:02 +0200
Message-ID: <20170424083802.GA3408@salvia>
References: <20170419224548.3605-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166759AbdDXIiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 04:38:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6717523C7
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ADBBFF2C8
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53436FF14D
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170419224548.3605-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 12:45:48AM +0200, Florian Westphal wrote:
> Similar to ip_register_table, pass nf_hook_ops to ebt_register_table().
> This allows to handle hook registration also via pernet_ops and allows
> us to avoid use of legacy register_hook api.

Also applied, thanks.
