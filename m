From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_hash: fix nft_hash_deactivate
Date: Mon, 6 Nov 2017 16:50:29 +0100
Message-ID: <20171106155029.GA20464@salvia>
References: <20171102180447.28064-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753877AbdKFPuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:50:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0FC81C436A
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:50:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D231CDA804
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:50:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171102180447.28064-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied to nf-next, thanks for fixing up this.
