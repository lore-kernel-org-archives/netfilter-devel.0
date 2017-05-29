From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next V2] netfilter: cttimeout: use
 nf_ct_iterate_cleanup_net to unlink timeout objs
Date: Mon, 29 May 2017 11:37:23 +0200
Message-ID: <20170529093723.GB10068@salvia>
References: <1495982239-17054-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbdE2Jh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:37:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46B771DA087
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 378F5100A6E
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC80B100793
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:37:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495982239-17054-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 28, 2017 at 10:37:19PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Similar to nf_conntrack_helper, we can use nf_ct_iterare_cleanup_net to
> remove these copy & paste codes.

Also applied, thanks.
