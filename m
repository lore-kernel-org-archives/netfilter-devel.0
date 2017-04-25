From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 0/4] netfilter: ctnetlink: fix some bugs related to ct
 update
Date: Tue, 25 Apr 2017 11:07:20 +0200
Message-ID: <20170425090720.GA2907@salvia>
References: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1176350AbdDYJHl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:07:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B4F886D584
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:07:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6070468
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:07:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DD75FF2C5
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:07:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 17, 2017 at 09:18:54PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> This patch set aims to fix some bugs related to ctnetlink_change_conntrack.
> 
> First, we may invoke request_module with rcu_read_lock held, this is wrong,
> as the request_module invocation may sleep. Fixed by PATCH #1.
> 
> Second, the unnecessary nf_conntrack_expect_lock will cause dead lock, which
> was introduced by commit ca7433df3a67 ("netfilter: conntrack: seperate expect
> locking from nf_conntrack_lock"). This is fixed by PATCH #2.
> 
> Third, Pablo pointed out that packets may be updating a conntrack at the
> same time that we're mangling via ctnetlink, it's better to fix the
> possible race together. So I audited the related source codes as follows:
> 1. CTA_HELP: for the userspace cthelper, no problem; for the inkernel
>              cthelper, there's only one user: nf_ct_ftp_from_nlattr,
>              but it only sets two flags, so no problem too.
> 2. CTA_TIMEOUT: only modify the ct->timeout, so no problem
> 3. CTA_STATUS: possible race will happen, fixed by PATCH #3
> 4. CTA_PROTOINFO: protected by ct->lock, no problem
> 5. CTA_MARK: only modify the ct->mark, no problem
> 6. CTA_SEQ_ADJ_X: should be protectd by ct->lock, fixed by PATCH #4
> 7. CTA_LABELS: use cmpxchg to update labels, so no problem

Series applied, thanks.
