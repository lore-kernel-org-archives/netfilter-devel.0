From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 0/6] tests: Automated regression testing
Date: Thu, 18 Sep 2014 00:10:33 +0200
Message-ID: <20140917221033.GA29146@acer.localdomain>
References: <1410785230-8498-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59117 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaIQWKh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:10:37 -0400
Content-Disposition: inline
In-Reply-To: <1410785230-8498-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 15, 2014 at 02:47:04PM +0200, Ana Rey wrote:
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

I think it's great to have this and would suggest pulling it into the
tree now and continue the work there.

So if you don't have any objections, I'll apply the series.
