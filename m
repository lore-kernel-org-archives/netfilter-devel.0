From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 0/8] iptables-translate: fix some bugs and add
 more translations to nft
Date: Fri, 14 Oct 2016 19:02:45 +0200
Message-ID: <20161014170245.GA8227@salvia>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932618AbcJNRDI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 13:03:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59F4C62D07
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 19:03:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47267DA7F6
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 19:03:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4978DA818
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 19:03:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 07, 2016 at 07:08:48PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> This patch set fixes some bugs related to translation:
>   * libipt_realm: add a missing space
>   * libxt_iprange: ip6tables translation's format is not correct
>   * libxt_iprange & libxt_devgroup: handle the invert flag properly
>   * libxt_ipcomp: add range support
> 
> Also add libxt_quota, libxt_DSCP, libxt_statistic translation to nft.
> Note: we only support statistic's nth mode translation, because random
> mode is not completely supported in nft.

Series applied, thanks Liping.
