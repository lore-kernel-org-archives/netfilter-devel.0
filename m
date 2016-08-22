From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4 V6 nft] test: shell: Add tests for deleting rule by
 description
Date: Mon, 22 Aug 2016 18:13:38 +0200
Message-ID: <20160822161338.GC5023@salvia>
References: <20160821212210.26161-1-carlosfg@riseup.net>
 <20160821212210.26161-3-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755289AbcHVQNm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:13:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27CD61F18E0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BD7D9D6A4
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17A0FFB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160821212210.26161-3-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 11:22:09PM +0200, Carlos Falgueras García wrote:
> They checks if commands like "nft delete rule <table> <chain> <rule desc>"
> works as is expected.
> 
> First one checks if command deletes only one of the matched rules.
> Second one checks if command fails when rule did not found.

Also applied, thanks.
