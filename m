Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A041C54EBD
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 23:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjALXpG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjALXpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 18:45:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DEC13F97;
        Thu, 12 Jan 2023 15:45:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pG7Fn-0007U0-8V; Fri, 13 Jan 2023 00:45:03 +0100
Date:   Fri, 13 Jan 2023 00:45:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <20230112234503.GB19463@breakpoint.cc>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
 <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> Given the packet counts as per my example above, it looks like
> conntrack only saw:
> 
> src=180.173.2.183 dst=78.32.30.218	SYN
> src=78.32.30.218 dst=180.173.2.183	SYN+ACK
> src=180.173.2.183 dst=78.32.30.218	ACK
> 
> and I suspect at that point, the connection went silent - until
> Exim timed out and closed the connection, as does seem to be the
> case:
> 
> 2023-01-11 21:32:04 no host name found for IP address 180.173.2.183
> 2023-01-11 21:33:05 SMTP command timeout on connection from [180.173.2.183]:64332 I=[78.32.30.218]:25
> 
> but if Exim closed the connection, why didn't conntrack pick it up?

Yes, thats the question.  Exim closing the connection should have
conntrack at least pick up a fin packet from the mail server (which
should move the entry to the 2 minute fin timeout).
