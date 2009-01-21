From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 12:02:21 +0100
Message-ID: <497700BD.9080707@trash.net>
References: <200901211029.01619.kgy@teledigit.hu> <4976F0EB.8050806@trash.net> <49770013.4020807@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51486 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbZAULCX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:02:23 -0500
In-Reply-To: <49770013.4020807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Thanks for the report. Does this patch fix it?
> 
> Hm, this was introduced when we fixed the problem with race condition in
> the conntrack creation :( It would be worth to pass it to 2.6.29-rc.

Of course :) I'll also send it to stable once it hits upstream.
