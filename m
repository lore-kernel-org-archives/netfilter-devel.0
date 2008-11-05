From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netns ct: walk netns list under RTNL
Date: Wed, 05 Nov 2008 11:14:26 +0100
Message-ID: <49117202.8060307@trash.net>
References: <20081101143215.GB23760@x200.localdomain> <491050DC.1020405@trash.net> <20081104184916.GA3391@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33870 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYKEKOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:14:34 -0500
In-Reply-To: <20081104184916.GA3391@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> netns list (just list) is under RTNL. But helper and proto unregistration
> happen during rmmod when RTNL is not held, and that's how it was tested:
> modprobe/rmmod vs clone(CLONE_NEWNET)/exit.

Applied, thanks.
