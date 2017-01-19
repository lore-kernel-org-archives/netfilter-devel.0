From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: refine gc worker heuristics,
 redux
Date: Thu, 19 Jan 2017 14:29:44 +0100
Message-ID: <20170119132944.GA3427@salvia>
References: <1484701282-14758-1-git-send-email-fw@strlen.de>
 <87f65fc03fdfa4c2fc185551c7989c48@nuclearcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38200 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752837AbdASNh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 08:37:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1EF9FB441
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:29:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2BC1A7BE9
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:29:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C51DAA7E9A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 14:29:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <87f65fc03fdfa4c2fc185551c7989c48@nuclearcat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 19, 2017 at 03:36:52AM +0200, Denys Fedoryshchenko wrote:
> I confirm, patch completely fix issue.

Applied to my nf tree. Thanks for testing.
