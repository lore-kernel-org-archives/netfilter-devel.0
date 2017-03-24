From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: Make flush command selective of the set
 structure type
Date: Fri, 24 Mar 2017 19:29:37 +0100
Message-ID: <20170324182937.GA1611@salvia>
References: <20170324153041.GA6413@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49010 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754597AbdCXS3t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 14:29:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 416671EC2CC
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:29:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34620EDB87
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:29:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42278FC5E6
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:29:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170324153041.GA6413@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 12:30:41PM -0300, Elise Lennion wrote:
> The internal set infrastructure is used for sets, maps and flow tables.
> The flush command requires the set type but currently it works for all
> of them. E.g. if there is a set named 's' in a table 't' the following
> command shouldn't be valid but still executes:
> 
> $ nft flush flow table t s
> 
> This patch makes the flush command selective so 'flush flow table' only
> works in flow tables and so on.

Applied, thanks Elise.
