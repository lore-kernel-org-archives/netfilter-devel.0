From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_numgen: start round robin from
 zero
Date: Fri, 21 Oct 2016 12:47:28 +0200
Message-ID: <20161021104728.GA3411@salvia>
References: <1476890993-3518-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58578 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754619AbcJUKrd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:47:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1682A26E10
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07D32DA81A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D621DA84B
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476890993-3518-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 19, 2016 at 11:29:53PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Currently we start round robin from 1, but it's better to start round
> robin from 0. This is to keep consistent with xt_statistic in iptables.

Applied, thanks.
