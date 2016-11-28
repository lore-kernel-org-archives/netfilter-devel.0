From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: add chain to pktinfo
 structure
Date: Mon, 28 Nov 2016 09:44:28 +0100
Message-ID: <20161128084428.GA949@salvia>
References: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
 <20161128005649.GA17749@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40252 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932105AbcK1Iod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 03:44:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E439196ECF
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:44:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4D8FA0FCC
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:44:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD8B3A0FCC
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 09:44:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128005649.GA17749@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 01:56:49AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch adds the chain object to the pktinfo structure. This
> > potentially allow us to know what basechain this packet is walking over
> > from the expression evaluation path.
> 
> ... for what?  Why...?

Quota depletion event notification needs to know from what table
delivery is happening, so this one actually belongs to the stateful
object patchset..

> Its not clear to me why these changes are made.  Same for patch #2.

Patch #2 used to be required by the original stateful object
infrastructure, but actually, last version doesn't need this. When
decoupling the stateful object from the expression, the NFT_OBJECT_*
are used. I can keep this back so we can escape this extra complexity.
