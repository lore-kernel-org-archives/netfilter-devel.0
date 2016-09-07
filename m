From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 net-next 1/2] netfilter: gre: Use consistent GRE_*
 macros instead of ones defined by netfilter.
Date: Wed, 7 Sep 2016 10:47:39 +0200
Message-ID: <20160907084739.GA3842@salvia>
References: <1472137691-24822-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbcIGIrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:47:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 098E211E58F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE682100A79
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:47:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08585114D61
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:47:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472137691-24822-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 25, 2016 at 11:08:11PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are already some GRE_* macros in kernel, so it is unnecessary
> to define these macros. And remove some useless macros

Applied, thanks.
