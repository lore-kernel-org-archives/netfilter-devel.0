From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] netlink broadcast return value
Date: Mon, 09 Feb 2009 15:17:39 +0100
Message-ID: <49903B03.2040302@trash.net>
References: <4985A4C5.4050908@netfilter.org> <20090202.140533.121159038.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55780 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZBIORn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:17:43 -0500
In-Reply-To: <20090202.140533.121159038.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Sun, 01 Feb 2009 14:33:57 +0100
> 
>> In short, I think that the change that I'm proposing would also require
>> to fix some netlink_broadcast() clients to skip ENOBUFS errors: they are
>> not meaningful for them since they assume that Netlink is unreliable and
>> so the return value does not provide any useful information.
> 
> I think this analysis is accurate.

We have at least one case where the caller wants to know of
any successful delivery. Keymanager queries done by xfrm_state
want to know whether an acquire was delivered to any keymanager.
So we need to continue to indicate this, maybe using a different
errno code than -ENOBUFS. I don't have a suggestion which one to
use though.
