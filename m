From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 net-next 2/2] netfilter: gre: Use consistent GRE and
 PTTP header structure instead of the ones defined by netfilter
Date: Wed, 7 Sep 2016 10:47:53 +0200
Message-ID: <20160907084753.GB3842@salvia>
References: <1472137727-24890-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbcIGIsG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:48:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7691411E5A1
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 677F0100A79
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39308114D68
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472137727-24890-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 25, 2016 at 11:08:47PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are two existing strutures which defines the GRE and PPTP header.
> So use these two structures instead of the ones defined by netfilter to
> keep consitent with other codes.

Applied, thanks.
