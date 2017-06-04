From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for
 cthelper
Date: Sun, 4 Jun 2017 21:45:35 +0200
Message-ID: <20170604194535.GA2195@salvia>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
 <20170604160753.GA843@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbdFDTpp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 15:45:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B155ADFE2A
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Jun 2017 21:45:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1FA9100790
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Jun 2017 21:45:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7ACF8100790
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Jun 2017 21:45:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170604160753.GA843@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 04, 2017 at 06:07:53PM +0200, Florian Westphal wrote:
> Liping Zhang <zlpnobody@163.com> wrote:
> > This patch set aims to add net namespace support for the ct helper,
> > it is a little large, but I try my best to split them to a relative
> > smaller patches, which will help to review. Comments are welcome.
> 
> Why?  Could you explain what kind of functionality is added here, or
> what problem is fixed?
> 
> Why do we need per netns complexity for helpers?

I agree. We don't need this now that we have the new nft helper
frontend in place that Florian implemented.
