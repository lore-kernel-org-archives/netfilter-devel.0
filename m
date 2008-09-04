From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/38] netns ct: per-netns expectations
Date: Thu, 04 Sep 2008 18:43:50 +0200
Message-ID: <48C01046.2070704@trash.net>
References: <20080821220040.GJ31136@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@lists.linux-foundation.org
To: adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33387 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYIDQnw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:43:52 -0400
In-Reply-To: <20080821220040.GJ31136@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

adobriyan@gmail.com wrote:
> Make per-netns expectation hash and expectation count.
> 
> Expectation always belongs to netns to which it's master conntrack belongs.
> This is natural and allows to not bloat expectations.
> 
> Proc files and leaf users in protocol modules are stubbed to init_net,
> this is temporary.

This one again introduces overly long lines, please fix up
the remaining patches yourself and resend.

I'll upload my current tree to kernel.org so you can use it
as a base (will take a couple of minutes):

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

