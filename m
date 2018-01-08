From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: avoid arp/bridge WARN_ON if
 arp/ebtables not supported
Date: Mon, 8 Jan 2018 14:07:54 +0100
Message-ID: <20180108130754.ziqxziyogerm352r@salvia>
References: <20180108123152.11499-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755384AbeAHNH6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 08:07:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72C0732F81
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55E336750
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 14:07:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180108123152.11499-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 08, 2018 at 01:31:52PM +0100, Florian Westphal wrote:
> We need to retain the 'case' statement, otherwise, if e.g. arp tables
> isn't supported first NF_HOOK(NFPROTO_ARP, ... will produce a bogus
> WARN_ON().

Applied, thanks Florian.
