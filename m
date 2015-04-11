From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/14] netfilter: nf_tables: concatenation support
Date: Sat, 11 Apr 2015 14:47:45 +0100
Message-ID: <20150411134745.GD15268@acer.localdomain>
References: <1428715659-31358-1-git-send-email-kaber@trash.net>
 <20150411134725.GA9651@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50731 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbbDKNrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 09:47:49 -0400
Content-Disposition: inline
In-Reply-To: <20150411134725.GA9651@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.04, Pablo Neira Ayuso wrote:
> On Sat, Apr 11, 2015 at 02:27:25AM +0100, Patrick McHardy wrote:
> > The following patches add support for concatenations, which allow multi
> > dimensional exact matches in O(1).
> 
> Thanks Patrick. I think it would be good to get userspace in sync with
> what we already have in mainstream. This is going to get way to far
> from what we have in master.

Well, I don't want to add all that stuff to master since I suppose we'll
have a release for 4.0 soon. I'm however right now preparing the patchset
for a 4.1 branch.
