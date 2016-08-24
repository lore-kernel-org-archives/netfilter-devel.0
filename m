From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: data_reg: Fix DATA_CHAIN comparison
Date: Wed, 24 Aug 2016 17:05:35 +0200
Message-ID: <20160824150535.GA8600@salvia>
References: <20160824122216.29351-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753122AbcHXPGh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 11:06:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90666231666
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 17:05:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 809CF100A7D
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 17:05:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CB65100A68
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 17:05:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160824122216.29351-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 24, 2016 at 02:22:16PM +0200, Carlos Falgueras García wrote:
> Splits DATA_VERDICT and DATA_CHAIN comparison. A verdict can have a NULL
> chain (accept, drop, etc) so segfault will happen when strcmp is call.

Applied, thanks Carlos.
