From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] Add support for insertion inside rule list
Date: Fri, 19 Jul 2013 17:50:48 +0200
Message-ID: <20130719155048.GA2286@localhost>
References: <1373124677-6626-1-git-send-email-eric@regit.org>
 <1373124837-6857-1-git-send-email-eric@regit.org>
 <20130719122833.GA30497@localhost>
 <1374244287.17892.30.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760525Ab3GSPu7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:50:59 -0400
Content-Disposition: inline
In-Reply-To: <1374244287.17892.30.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:31:27PM +0200, Eric Leblond wrote:
[...]
> > While fixing it using the 'before' and 'after', I noticed that 'add'
> > and 'insert' already tell us where to put the new rule, so 'after' and
> > 'before' were repeating again what we want to do. I have reworked this
> > patch to change this initial syntax:
> > 
> > nft add rule filter output position 5  ip daddr 1.2.3.1 drop
> > nft insert rule filter output position 5  ip daddr 1.2.3.1 drop
> > 
> > We can support the after and before, but that would imply some extra
> > evaluation after the parsing that would make the patch bigger. So I
> > prefered to go the simpler solution.
> 
> I agree with the following modification. I did not find better than this
> so, it is ok for me :)
> 
> Patch tested. It works well.

I have applied this patch, thanks for testing.
