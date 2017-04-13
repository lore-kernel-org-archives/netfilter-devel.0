From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove unnecessary
 nf_conntrack_expect_lock protection
Date: Thu, 13 Apr 2017 23:52:17 +0200
Message-ID: <20170413215217.GB3960@salvia>
References: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdDMVwZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:52:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C761BA6FB
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:52:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9873DA804
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:52:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F58EDA7E9
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:52:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 01, 2017 at 10:14:24PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, ctnetlink_change_helper() is always protected by _expect_lock,
> this is unnecessary, since the operations are unrelated to _expect_lock.
> 
> Also this will cause a deadlock when deleting the helper from a conntrack,
> as _expect_lock will be locked again by nf_ct_remove_expectations():

Applied.
