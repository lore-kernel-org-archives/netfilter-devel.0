From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 2/2] src: Always print range expressions
 numerically
Date: Sun, 5 Feb 2017 21:42:35 +0100
Message-ID: <20170205204235.GB6584@salvia>
References: <20170202123156.GA17914@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43574 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUms (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:42:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69E43131CAB
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CC41DA7E9
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D68ADA7E9
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:42:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170202123156.GA17914@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 02, 2017 at 10:31:56AM -0200, Elise Lennion wrote:
> Because the rules are more legible this way. Also, the parser doesn't
> accept strings on ranges, so, printing ranges numerically better match
> the rules definition.

Also applied, thanks.
