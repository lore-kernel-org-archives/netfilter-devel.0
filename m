From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3 1/1] netfilter: helper: Add the rcu lock when call
 __nf_conntrack_helper_find
Date: Sat, 8 Apr 2017 23:08:16 +0200
Message-ID: <20170408210816.GA5045@salvia>
References: <1490785887-17732-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752050AbdDHVIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:08:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 950CE24937
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:08:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 389D8DA80B
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:08:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97AF0DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:08:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490785887-17732-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 07:11:27PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When invoke __nf_conntrack_helper_find, it needs the rcu lock to
> protect the helper module which would not be unloaded.
> 
> Now there are two caller nf_conntrack_helper_try_module_get and
> ctnetlink_create_expect which don't hold rcu lock. And the other
> callers left like ctnetlink_change_helper, ctnetlink_create_conntrack,
> and ctnetlink_glue_attach_expect, they already hold the rcu lock
> or spin_lock_bh.
> 
> Remove the rcu lock in functions nf_ct_helper_expectfn_find_by_name
> and nf_ct_helper_expectfn_find_by_symbol. Because they return one pointer
> which needs rcu lock, so their caller should hold the rcu lock, not in
> these two functions.

Applied.
