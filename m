From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: Fix ifdef checks for
 CONFIG_NF_CONNTRACK_MARK
Date: Thu, 15 Dec 2016 21:55:37 +0100
Message-ID: <20161215205537.GA4830@salvia>
References: <1481751357-22893-1-git-send-email-joseph.j.conley@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Joe Conley <joe.conley@lairdtech.com>
To: joseph.j.conley@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbcLOUzm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2016 15:55:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CD70764F
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 21:55:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C713DA390
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 21:55:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07170DA38E
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 21:55:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481751357-22893-1-git-send-email-joseph.j.conley@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2016 at 04:35:57PM -0500, joseph.j.conley@gmail.com wrote:
> From: Joe Conley <joe.conley@lairdtech.com>
> 
> Two missing ifdef checks for CONFIG_NF_CONNTRACK_MARK were causing
> EOPNOTSUPP to be returned. Every single place that cda[CTA_MARK] or cda[CTA_MARK_MASK]
> was checked was inside a #ifdef for CONFIG_NF_CONNTRACK_MARK except for these
> two places. The reason for this change stems from this commit:
> 866476f323465a8afef10b14b48d5136bf5c51fe (netfilter: conntrack: Flush connections with a given mark)
> 
> This allows conntrack -L to be ran succesfully when CONFIG_NF_CONNTRACK_MARK
> is not enabled.

I would like to understand how you're triggering this problem. If it
is a plain 'conntrack -L' command line invocation that triggers the
problem, then it's probably a userspace problem since we should not
send any mark attribute to the kernel if not set.
