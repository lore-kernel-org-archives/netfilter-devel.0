From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] conntrack: restart gc immediately if GC_MAX_EVICTS
 is reached
Date: Wed, 19 Oct 2016 18:14:12 +0200
Message-ID: <20161019161412.GA6542@salvia>
References: <34d607cc-5556-89c7-673d-be8cb0a4758a@6wind.com>
 <1476794252-12398-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754846AbcJSQOX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 12:14:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C81549B7F4
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:14:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8DBBDA844
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:14:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7837DDA81C
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:14:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476794252-12398-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 18, 2016 at 02:37:32PM +0200, Nicolas Dichtel wrote:
> When the maximum evictions number is reached, do not wait 5 seconds before
> the next run.

Applied, thanks Nicolas.
