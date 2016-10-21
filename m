From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_meta: permit pkttype mangling in
 ip/ip6 prerouting
Date: Fri, 21 Oct 2016 12:47:43 +0200
Message-ID: <20161021104743.GB3411@salvia>
References: <1476891089-3744-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754274AbcJUKrt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:47:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 537D826E10
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41FD3DA849
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5376DA916
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:47:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476891089-3744-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 19, 2016 at 11:31:29PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After supporting this, we can combine it with hash expression to emulate
> the 'cluster match'.

Also applied, thanks Liping.
