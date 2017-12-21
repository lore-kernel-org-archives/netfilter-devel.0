From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: nf_defrag_ipv4: Skip defrag if
 NOTRACK is set
Date: Thu, 21 Dec 2017 09:48:52 +0100
Message-ID: <20171221084852.amdtj7ef4aurua3e@salvia>
References: <1513719739-1095-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751525AbdLUIs4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 03:48:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88CFF8101B
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:48:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B941115406
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:48:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1513719739-1095-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

On Tue, Dec 19, 2017 at 02:42:19PM -0700, Subash Abhinov Kasiviswanathan wrote:
> conntrack defrag is needed only if some module like CONNTRACK or NAT
> explicitly requests it. For plain forwarding scenarios, defrag is
> not needed and can be skipped if NOTRACK is set in a rule.
> 
> Since conntrack defrag is currently higher priority than raw table,
> setting NOTRACK is not sufficient. We need to move raw to a higher
> priority for iptables only.
> 
> This is achieved by introducing a module parameter which allows to
> modify the priority. By default, the priority is NF_IP_PRI_RAW to
> support legacy behavior.
> 
> v1->v2: Instead of modifying NF_IP_PRI_RAW itself, use a module
> parameter to pass in the priority during module load as suggested
> by Pablo. Also update commit text.

Can we get the same thing for IPv6, for symmetry?

Thanks!
