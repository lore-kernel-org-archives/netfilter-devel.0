From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: nf_tables: allow expressions to return
 STOLEN
Date: Fri, 21 Oct 2016 12:51:00 +0200
Message-ID: <20161021105100.GA4965@salvia>
References: <1476804918-4191-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33124 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932313AbcJUKvG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:51:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8477A61E97
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:51:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 738ADDA81B
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:51:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58462DA81A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:51:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476804918-4191-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 18, 2016 at 05:35:18PM +0200, Florian Westphal wrote:
> Currently not supported, we'd oops as skb was (or is) free'd elsewhere.

Applied, thanks Florian.
