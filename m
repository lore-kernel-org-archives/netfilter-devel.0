From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next V2] netfilter: nf_ct_helper: use
 nf_ct_iterate_destroy to unlink helper objs
Date: Mon, 29 May 2017 11:37:00 +0200
Message-ID: <20170529093700.GA10068@salvia>
References: <1495982152-16918-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbdE2JhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:37:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F8041DA084
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 800D01007AC
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 715BA100A4E
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:36:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495982152-16918-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 28, 2017 at 10:35:52PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When we unlink the helper objects, we will iterate the nf_conntrack_hash,
> iterate the unconfirmed list, handle the hash resize situation, etc.
> 
> Actually this logic is same as the nf_ct_iterate_destroy, so we can use
> it to remove these copy & paste codes.

Applied to nf-next, thanks.
