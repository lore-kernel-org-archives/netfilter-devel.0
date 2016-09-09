From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: remove unused
 ctl_table_path member in nf_conntrack_l3proto
Date: Fri, 9 Sep 2016 16:05:13 +0200
Message-ID: <20160909140513.GA26116@salvia>
References: <1473172547-8585-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752148AbcIIOFW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 10:05:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68C772273E5
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:05:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A866114D6C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:05:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F319114D6C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:05:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473172547-8585-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2016 at 10:35:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After commit adf0516845bc ("netfilter: remove ip_conntrack* sysctl
> compat code"), ctl_table_path member in struct nf_conntrack_l3proto{}
> is not used anymore, remove it.

Applied, thanks.
