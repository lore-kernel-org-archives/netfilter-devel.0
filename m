From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 0/5] misc fixes
Date: Thu, 6 Jun 2013 13:43:10 +0200
Message-ID: <20130606114310.GA9849@localhost>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3FFLnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:43:15 -0400
Content-Disposition: inline
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Sun, Jun 02, 2013 at 12:38:27PM +0200, Eric Leblond wrote:
> 
> Hello,
> 
> Here's a small patchset for nftables. It contains miscellaneous fixes
> and improvements. I'm not sure for patch 2 ("expression") because it
> may not be the best way to fix the crash.

I just sent you a patch to address this issue. I cannot find any
problem with yours though, but I think it's better if we don't make
any assumption and explicitly label dynamically allocated datatypes to
differenciate them of static ones.

> Patch 3 can also be discussed because it suppress something that was
> done before in the code.

Can you point to the patch that changed that line of code, I'm lacking
some context.

Regarding Patch 1, 4 and 5. Feel free to push them to the nftables
tree.

Thanks.
