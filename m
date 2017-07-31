From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_hook_ops structs can be const
Date: Mon, 31 Jul 2017 19:12:38 +0200
Message-ID: <20170731171238.GB4350@salvia>
References: <20170726094052.23057-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdGaRMq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:12:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B80DC3025A7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:12:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A90BDDA87A
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:12:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEC96DA241
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:12:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170726094052.23057-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 26, 2017 at 11:40:52AM +0200, Florian Westphal wrote:
> We no longer place these on a list so they can be const.

Applied, thanks.
