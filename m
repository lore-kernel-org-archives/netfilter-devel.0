From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 15:48:42 +0200
Message-ID: <4A2FB9BA.5050106@trash.net>
References: <20090610133716.14805.95308.stgit@Decadence> <20090610134150.14805.4528.stgit@Decadence> <4A2FB985.8030002@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58990 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZFJNsv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:48:51 -0400
In-Reply-To: <4A2FB985.8030002@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> This patch improves ctnetlink event reliability if one broadcast
>> listener has set the NETLINK_BROADCAST_ERROR socket option.
> 
> This is missing reliable event delivery for _eventmask_report(). I'm
> going to resend this patch. Sorry and rebase my git tree with the new patch.

OK thanks. I'll back them out again from my tree :)


