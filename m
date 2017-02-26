From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft bug: Deleting map elements with intervals
Date: Sun, 26 Feb 2017 21:09:58 +0100
Message-ID: <20170226200958.GA1827@salvia>
References: <20170226163855.v56ljeaelgqypaeq@wendy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Felix Kluge <f.kluge@agdsn.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdBZUKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 15:10:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4EE16ED90F
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:10:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40B1FDA385
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:10:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CE00DA385
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 21:09:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170226163855.v56ljeaelgqypaeq@wendy>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 26, 2017 at 05:38:55PM +0100, Felix Kluge wrote:
> Hello,
> 
> we're currently trying to use a vertict map to jump to other chains. The
> key of the map is a subnet.
> 
> table ip filter {
>   map cgn_map {
>     type ipv4_addr : verdict
>     flags interval
>     elements = {
>       100.64.2.0/24 : goto chain-100-64-2-0}
>   }
> }
> 
> 
> Adding new elements to the map works well:
> 
> nft add element filter cgn_map { 100.64.3.0/24 : goto ratelimit-100-64-3-0}
> 
> 
> However, deleting elements from the map does not work:
> 
> nft delete element filter cgn_map 100.64.2.0/24
> <cmdline>:1:36-45: Error: syntax error, unexpected string, expecting '{' or '$'

Parens are missing, this should be:

        nft delete element filter cgn_map { 100.64.2.0/24 }

Thanks.
