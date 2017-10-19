From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables and iptables nat coexistence
Date: Thu, 19 Oct 2017 12:25:37 +0200
Message-ID: <20171019102537.GA2538@salvia>
References: <20171018135650.GA16796@breakpoint.cc>
 <20171019101529.GA2224@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752307AbdJSKZn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 06:25:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDAA8249C9
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:25:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC258DA903
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:25:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019101529.GA2224@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 12:15:29PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 18, 2017 at 03:56:50PM +0200, Florian Westphal wrote:
> > 3. Do not permit more than one nat type per family/hook.
> 
> Yes, this makes sense to me.

You could add a singleton flag for chain, so we check this from the
core, just and idea.

