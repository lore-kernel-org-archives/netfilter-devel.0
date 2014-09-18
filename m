From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v3 nft 0/7] tests: Automated regression testing
Date: Thu, 18 Sep 2014 13:02:09 +0200
Message-ID: <20140918110209.GA12058@salvia>
References: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59546 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbaIRLBO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:01:14 -0400
Content-Disposition: inline
In-Reply-To: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 18, 2014 at 12:39:14PM +0200, Ana Rey wrote:
> This is a new version of the automated regression testing of nftables.
> 
> There is no infrastructure to allow us to check all options/features in
> nft. So, if anyone sends a patch, we cannot check if it breaks something.
> 
> I send in this patchset the nftables automated regression tests. It
> contains a python script (nft-add.py) and a set of test files.
> 
> This allow us to check the input of rules of nft-tool from the
> command-line and the output from nft-tool of this rule. Then, it
> compares if the rule input matches the rule output automatically.
> 
> We also have plans to add automated regression testing in the packet
> path in the future, which should come in a follow up step.
> 
> Comments welcome, thanks

Finally :-). Series applied, thanks Ana.
