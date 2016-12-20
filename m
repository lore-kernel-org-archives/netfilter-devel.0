From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] expression: Show the base which pre-defined
 constants are displayed
Date: Tue, 20 Dec 2016 20:24:49 +0100
Message-ID: <20161220192449.GA2236@salvia>
References: <20161219221104.GA32044@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965195AbcLTTZA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 14:25:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8151C117427
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 20:24:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7110E8E663
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 20:24:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56ED78E663
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 20:24:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161219221104.GA32044@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 19, 2016 at 07:11:04PM -0300, Elise Lennion wrote:
> so the user know how we express it.
> 
> The base was added to all symbol tables, which are associated with
> datatype->sym_tbl, so they are displayed in the right base.

Applied, thanks Elise.
