From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] netns ebtables: part 1
Date: Tue, 04 Nov 2008 14:23:28 +0100
Message-ID: <49104CD0.5050006@trash.net>
References: <20081029134556.GA8396@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, containers@osdl.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41191 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYKDNXf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:23:35 -0500
In-Reply-To: <20081029134556.GA8396@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> * propagate netns from userspace, register table in passed netns
> * remporarily register every ebt_table in init_net
> 
> P. S.: one needs to add ".netns_ok = 1" to igmp_protocol to test with
> ebtables(8) in netns.

Applied, thanks.


