From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3] sets: Fix for missing space after last element
Date: Wed, 22 Mar 2017 12:52:30 +0100
Message-ID: <20170322115230.GC14374@salvia>
References: <20170321131902.GA30047@salvia>
 <20170322002636.14081-1-phil@nwl.cc>
 <20170322002636.14081-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdCVMa2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 08:30:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3BAF6114818
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:52:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22DC1DA804
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:52:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9C22DA870
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:52:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322002636.14081-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 01:26:36AM +0100, Phil Sutter wrote:
> Not having a space between the last element in a set and the closing
> curly brace looks ugly, so add it here.
> 
> This also adjusts all shell testcases as they match whitespace in nft
> output and therefore fail otherwise.

It's just one extra byte in the output. I don't mind, so applied this.
