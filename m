From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re : [PATCH nft 1/7] Interpret OP_NEQ against a set as OP_LOOKUP
Date: Tue, 29 Nov 2016 22:40:30 +0100
Message-ID: <20161129214030.GA8286@salvia>
References: <20161128113905.GC1691@salvia>
 <O4VLTpqw8hbx9gT5jGdR46@ZLJRbUrx7b2BDfxD/Ctug>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754385AbcK2Vkj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:40:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C8180174D1E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:40:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B82CBA7E23
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:40:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7FB9A7E1E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:40:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <O4VLTpqw8hbx9gT5jGdR46@ZLJRbUrx7b2BDfxD/Ctug>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 05:49:58PM +0100, Anatole Denis wrote:
> Le 28/11/2016 12:39:05, Pablo Neira Ayuso a écrit :
[...]
> I believe this error is not the best way to handle this issue. I
> sent a patch to the list with a proposed change to catch it earlier,
> removing the need to check for it here. In case that other patch is
> refused, I will send v2 with this check added.

I see, you're refering to the patchset you sent later on.

[...]
> The case for a lookup/inverse lookup into a nonexistent set is
> tested in ip/sets.t and ip6/sets. (somewhere in patches 3 and 4).
> I'll send a v2 of these tests with a test for datatype mismatch
> added.

Send me a follow up patch for this if you think this can help us
increase test coverage, that will be appreciated.

> Considering the previous remarks (and the other patches), do
> you think I still should change the error handling code ?

I think this is fine so I applied your patchses. The check for
datatype == NULL was not going to the core of the problem indeed.

Thanks.
