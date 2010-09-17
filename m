From: Simon Horman <horms@verge.net.au>
Subject: Re: [patch] netfilter: Use header-y instead of unifdef-y
Date: Fri, 17 Sep 2010 11:53:03 +0900
Message-ID: <20100917025302.GI30855@verge.net.au>
References: <20100823034226.GA29532@verge.net.au>
 <4C91D59B.40009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:35492 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0IQCw4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:52:56 -0400
Content-Disposition: inline
In-Reply-To: <4C91D59B.40009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 16, 2010 at 10:30:19AM +0200, Patrick McHardy wrote:
> Am 23.08.2010 05:42, schrieb Simon Horman:
> > According to Documentation/kbuild/makefiles.txt
> > the usage of unifdef is deprecated.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> This has already been changed by this commit:

Thanks, I had a feeling my change would be redundant.

