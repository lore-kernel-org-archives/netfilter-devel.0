From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: udplite: Remove duplicated
 udplite4/6 declaration
Date: Sun, 9 Apr 2017 00:15:19 +0200
Message-ID: <20170408221519.GA8914@salvia>
References: <1491357424-72486-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdDHWPf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 18:15:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8259324937
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:15:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 731E2DA7F7
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:15:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8971DA729
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2017 00:15:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491357424-72486-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 05, 2017 at 09:57:04AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are two nf_conntrack_l4proto_udp4 declarations in the head file
> nf_conntrack_ipv4/6.h. Now remove one which is not enbraced by the macro
> CONFIG_NF_CT_PROTO_UDPLITE.

Applied.
