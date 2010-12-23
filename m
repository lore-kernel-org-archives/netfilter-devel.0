From: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 09:55:45 -0800 (PST)
Message-ID: <20101223.095545.183057798.davem@davemloft.net>
References: <4D11F384.3070908@googlemail.com>
	<alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
	<4D138C02.3050905@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, dennisml@conversis.de,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: mr.dash.four@googlemail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42403
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab0LWRzQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:55:16 -0500
In-Reply-To: <4D138C02.3050905@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mr Dash Four <mr.dash.four@googlemail.com>
Date: Thu, 23 Dec 2010 17:50:58 +0000

>> If you need to match the same port both with TCP and UDP, then add it
>> to the set twice, with the proper protocols.
>>   
> I've already dealt with this - I do not see the need to add 2x as many
> elements to a set when, in reality, I am not interested in matching
> the protocol part.

You must, every protocol puts the ports in a different location.

We have the same issue in our flow hashing functions in the kernel.
