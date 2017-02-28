From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Wed, 1 Mar 2017 07:29:33 +0900
Message-ID: <20170228222933.GA23726@gmail.com>
References: <20170228045359.GA21582@gmail.com>
 <20170228050041.GC21582@gmail.com>
 <20170228104725.GB1517@salvia>
 <20170228114453.GA22524@gmail.com>
 <20170228114809.GA19880@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33173 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdB1XDS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 18:03:18 -0500
Received: by mail-pg0-f54.google.com with SMTP id 25so11752703pgy.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 15:01:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170228114809.GA19880@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi, Pablo
 
On Tue, Feb 28, 2017 at 12:48:09PM +0100, Pablo Neira Ayuso wrote:
> So you want to check if the addresses mismatch, so we infer from there
> if there is NAT or not when status bits are not available.
> 
> Are you trying to catch up some case in netlink event specifically?

It's nothing. My skimping test for lnfct binding for another languate
which set only ATTR_REPL_IPV4DST then get NFCT_GOPT_IS_NAT was success,
but it fails now.

Thanks,
