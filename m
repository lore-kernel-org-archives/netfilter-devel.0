From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: Display pre-defined inet_service values in
 decimal base
Date: Sun, 11 Dec 2016 20:36:26 +0100
Message-ID: <20161211193626.GA32234@salvia>
References: <20161210235936.GA4967@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753572AbcLKTgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 14:36:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4B2B7FC46
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:36:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4F7DDA860
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:36:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE164DA851
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 20:36:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161210235936.GA4967@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 10, 2016 at 09:59:36PM -0200, Elise Lennion wrote:
> because the convention is to represent ports in base 10.
> 
> gcc-workaround is no longer needed and was removed.

Applied, thanks Elise.

It would be good if you can send a follow up patch to modified this
message that nft describe prints:

        pre-defined symbolic constants:

to:

        pre-defined symbolic constants (in hexadecimal):
                                       ^^^^^^^^^^^^^^^^

So the user knows how we express it.

Please, also review all existing symbol tables and add the base to
them, I guess a bit of googling should lead you to the right
convention dependending on the datatype, in case of doubt, make a
summary and ask for feedback on the mailing list.

Thanks.
