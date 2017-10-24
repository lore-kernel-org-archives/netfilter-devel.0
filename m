From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nat: use test_and_clear_bit when
 deleting ct from bysource list
Date: Tue, 24 Oct 2017 17:55:13 +0200
Message-ID: <20171024155513.GA11837@salvia>
References: <20171005144645.26616-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932156AbdJXPzR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:55:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43F38E9762
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:55:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34610DA86B
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:55:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171005144645.26616-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 05, 2017 at 04:46:45PM +0200, Florian Westphal wrote:
> We can use a single statement for this.
> While at it, fixup the comment -- we don't have pernet table/ops
> anymore, the function is only called from module exit path.

Applied to nf-next, thanks.
