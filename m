From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/3] netfilter: nfnetlink: use
 list_for_each_entry_safe to delete all objects
Date: Thu, 25 Aug 2016 12:57:27 +0200
Message-ID: <20160825105727.GB5242@salvia>
References: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757053AbcHYK5c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 06:57:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53F05F946D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58839100A7E
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4966DFB45F
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 12:57:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471874298-20503-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 09:58:16PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> cttimeout and acct objects are deleted from the list while traversing
> it, so use list_for_each_entry is unsafe here.

Also applied, thanks.
