From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] doc: Document add / delete element operations of
 sets and maps
Date: Mon, 20 Mar 2017 11:16:48 +0100
Message-ID: <20170320101648.GC10209@salvia>
References: <20170317150448.GA1318@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbdCTKRq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:17:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 24B6124935
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:16:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15969DA874
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:16:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF363DA804
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:16:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170317150448.GA1318@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 17, 2017 at 12:04:48PM -0300, Elise Lennion wrote:
> The add / delete operations weren't documented yet. They fit better
> in the sets and maps blocks since these operations are used to directly
> modify their content.

Applied, thanks.

A couple requests:

1) Could you check that flow table flush command doesn't flush
   sets/maps too? This should be selective.

2) Could you add shell tests for this?

Thanks.
