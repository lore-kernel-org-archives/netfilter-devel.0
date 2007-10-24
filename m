From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 11:42:05 +0200
Message-ID: <471F136D.6090907@trash.net>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Volker Sauer <volker@volker-sauer.de>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXJXJnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:43:16 -0400
In-Reply-To: <471F0AD5.2050202@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Philip Craig wrote:
> Patrick McHardy wrote:
>> Philip Craig wrote:
>>> Patrick McHardy wrote:
>>>>> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev --physdev-out $IF_DMZ -p tcp --dport 3389 -j ACCEPT
>>>> Try adding "--physdev-is-bridged" to your rules. Without that the kernel
>>>> is not able to tell whether they apply only to bridged packets or also
>>>> to forwarded or locally generated ones.
>>> That won't work for the above rule, for example, since the packet is
>>> being forwarded between two different bridges, so it is not bridged.
>>
>> I see nothing indicating that it is being forwarded.
> 
> They are different bridges, BR_GUEST and BR_INT, doesn't that mean it must
> be forwarded?


You're right.
