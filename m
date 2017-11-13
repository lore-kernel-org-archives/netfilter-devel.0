From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/3] netfilter: conntrack: make l4 tracker
 structs const
Date: Mon, 13 Nov 2017 13:45:50 +0100
Message-ID: <20171113124550.GA7806@salvia>
References: <20171107062009.2519-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdKMMpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:45:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7E925392E03
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:45:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E2F8BAC29
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:45:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171107062009.2519-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 07, 2017 at 07:20:06AM +0100, Florian Westphal wrote:
> This patch set removes the last runtime write accesses to the l4
> protocol tracker structs, then marks them as 'const'.
> 
> Resending, seems only first patchi (not resent) made it to
> list/patchwork.

Series applied, now patchwork caught this series, thanks for resending.
