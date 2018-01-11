From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v4] netfilter: nf_defrag: Skip defrag if NOTRACK
 is set
Date: Thu, 11 Jan 2018 13:14:16 +0100
Message-ID: <20180111121416.myi46sgoknr6qcte@salvia>
References: <1515642717-5994-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753826AbeAKMOV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 07:14:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E850443820
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:14:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF920DA856
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2018 13:14:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515642717-5994-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 08:51:57PM -0700, Subash Abhinov Kasiviswanathan wrote:
> conntrack defrag is needed only if some module like CONNTRACK or NAT
> explicitly requests it. For plain forwarding scenarios, defrag is
> not needed and can be skipped if NOTRACK is set in a rule.
> 
> Since conntrack defrag is currently higher priority than raw table,
> setting NOTRACK is not sufficient. We need to move raw to a higher
> priority for iptables only.
> 
> This is achieved by introducing a module parameter "raw_before_defrag"
> which allows to change the priority of raw table to place it before
> defrag. By default, the parameter is disabled and the priority of raw
> table is NF_IP_PRI_RAW to support legacy behavior. If the module
> parameter is enabled, then the priority of the raw table is set to
> NF_IP_PRI_RAW_BEFORE_DEFRAG.

Applied, thanks a lot Subash!
