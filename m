From: Patrick McHardy <kaber@trash.net>
Subject: Re: new target or new option
Date: Fri, 28 Sep 2007 19:46:26 +0200
Message-ID: <46FD3DF2.10709@trash.net>
References: <20070928170244.M71172@varna.net> <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Kaloyan Kovachev <kkovachev@varna.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57356 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXI1Rqa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:46:30 -0400
In-Reply-To: <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Sep 28 2007 20:06, Kaloyan Kovachev wrote:
> 
>>Hello,
>>i need to mark the connection with the realm number, but it seems there is no
>>'easy way' and there should be separate rule for each realm.
>>
>>Are there any plans to add this functionality and which is the preferable way
>>to go:
>>  1) create new REALMCONNMARK target with and/or mask
> 
> 
> Yeah, since there is already an xt_realm, a xt_REALM would be
> the logical counterpart.


The realm belongs to the route, it can not be changed.

I'm currently working on the netlink based iptables successor,
perhaps we should split matches into a "collector" part that
gathers the data and some generic range/mask/... matching.
That would allow to tell a target like CONNMARK to gather
the data from somewhere else.
