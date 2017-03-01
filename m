From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Wed, 1 Mar 2017 17:28:02 +0100
Message-ID: <20170301162802.GA8701@salvia>
References: <20170228045359.GA21582@gmail.com>
 <20170228050041.GC21582@gmail.com>
 <20170228104725.GB1517@salvia>
 <20170228114453.GA22524@gmail.com>
 <20170228114809.GA19880@salvia>
 <20170228222933.GA23726@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752655AbdCAQ2h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 11:28:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DBDD82D15EF
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:28:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9A68DA804
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:28:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81C7BDA80C
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:28:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170228222933.GA23726@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 07:29:33AM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hi, Pablo
>  
> On Tue, Feb 28, 2017 at 12:48:09PM +0100, Pablo Neira Ayuso wrote:
> > So you want to check if the addresses mismatch, so we infer from there
> > if there is NAT or not when status bits are not available.
> > 
> > Are you trying to catch up some case in netlink event specifically?
> 
> It's nothing. My skimping test for lnfct binding for another languate
> which set only ATTR_REPL_IPV4DST then get NFCT_GOPT_IS_NAT was success,
> but it fails now.

I see, we should restore the original behaviour, I think your patch is
correct then.
