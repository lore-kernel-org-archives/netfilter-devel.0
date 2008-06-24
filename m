From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 24 Jun 2008 18:11:15 +0200
Message-ID: <48611CA3.1050305@trash.net>
References: <4857A939.6050701@netfilter.org> <486118A9.5030808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbYFXQLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:11:20 -0400
In-Reply-To: <486118A9.5030808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> A few minor nits:
> 
>> ...

One more thing: the patch still doesn't follow the correct
netlink semantic for notifations on changes triggered by
userspace I described in the review of the first version
of this patch.

Please always mention which changes requested during a
review were made and which weren't (any why) when sending
updated versions.
