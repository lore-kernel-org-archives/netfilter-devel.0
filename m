From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 18 Jul 2008 04:11:58 +0200
Message-ID: <487FFBEE.90409@trash.net>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Fabian Hugelshofer <hugelshofer2006@gmx.ch>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39836 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYGRCRX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:17:23 -0400
In-Reply-To: <487F18DA.7030208@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Fabian Hugelshofer wrote:
>> Is someone intending to implement multipart messages for ctevents? ;-)
>
> The problem here is that batching should be a per-socket parameter. We
> will not accept a patch that changes the behaviour for all the ctevent
> users. And I don't see an obvious way to do this now

Thats a good point, there's no pretty solution to this. Profiles
would still be nice to have though :)

