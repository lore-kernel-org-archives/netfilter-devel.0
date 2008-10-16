From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] netns ebtables: part 1
Date: Thu, 16 Oct 2008 15:18:36 +0200
Message-ID: <48F73F2C.6030906@trash.net>
References: <20081015042014.GE24058@x200.localdomain> <20081015042509.GL24058@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@osdl.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33865 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYJPNSl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:18:41 -0400
In-Reply-To: <20081015042509.GL24058@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Wed, Oct 15, 2008 at 08:20:14AM +0400, Alexey Dobriyan wrote:
>> One needs to add ".netns_ok = 1" to igmp_protocol to test all of this
>> with ebtables() in netns.
> 
> Contains 80-column violations, I forgot about damn script again :^)

Apart from the minor comment about patch 1 (and the 80 column violations
I didn't notice so far :)), these look good to me.

