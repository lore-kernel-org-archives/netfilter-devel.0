From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 0/3] expr: complete log flags support
Date: Tue, 4 Oct 2016 08:50:32 +0200
Message-ID: <20161004065032.GA8970@salvia>
References: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752248AbcJDGuq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2016 02:50:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 014BE1E11D2
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:50:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7A41BAC29
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:50:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4E3EBAC2B
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 08:50:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 25, 2016 at 04:54:32PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After NF_LOG_XXX is exposed to the userspace, it's easy to complete log
> flags support in libnftnl. Instead of print hex value of flags, it's
> better to print human readable string format. This is done by patch #3.

Series applied, thanks Liping.
