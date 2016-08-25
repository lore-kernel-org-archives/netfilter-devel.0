From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/3] netfilter: cttimeout: put back l4proto when
 replacing timeout policy
Date: Thu, 25 Aug 2016 12:57:38 +0200
Message-ID: <20160825105738.GC5242@salvia>
References: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
 <1471874298-20503-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757783AbcHYK5n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 06:57:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25A34F946D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28E01FF2FD
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8144100A79
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471874298-20503-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 09:58:17PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We forget to call nf_ct_l4proto_put when replacing the existing
> timeout policy. Acctually, there's no need to get ct l4proto
> before doing replace, so we can move it to a later position.

Applied, thanks Liping.
