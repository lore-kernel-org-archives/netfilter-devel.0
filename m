From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [GIT PULL v2 0/1] IPVS Fixes for v4.11
Date: Fri, 28 Apr 2017 16:24:45 +0200
Message-ID: <20170428142445.GA9408@salvia>
References: <20170428101154.9750-1-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41248 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969497AbdD1OYy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 10:24:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DC8F20992C
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:24:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 200961B31CF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:24:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B28B01AF439
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:24:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170428101154.9750-1-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 28, 2017 at 12:11:53PM +0200, Simon Horman wrote:
> Hi Pablo,
> 
> please consider this fix to IPVS for v4.11.
> Or if it is too late for v4.11 please consider it for v4.12.
> I would also like it considered for stable.
> 
> * Explicitly forbid ipv6 service/dest creation if ipv6 mod is disabled
>   to avoid oops caused by IPVS accesing IPv6 routing code in such
>   circumstances.
> 
> Change since v1 of pull request:
> * Rebase on nf
> * Correct URL; it should be ipvs not ipvs-next
> 
> 
> The following changes since commit 9dd2ab609eef736d5639e0de1bcc2e71e714b28e:
> 
>   netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED in reverse SNATv6 path (2017-04-25 11:10:38 +0200)
> 
> are available in the git repository at:
> 
>   http://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git ipvs-fixes-for-v4.11

Pulled into nf, thanks Simon.
