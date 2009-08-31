From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: netns fix re reliable conntrack
 event delivery
Date: Mon, 31 Aug 2009 14:23:55 +0200
Message-ID: <4A9BC0DB.7000306@trash.net>
References: <20090826222425.GA7523@x200.localdomain> <4A96501E.5020907@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZHaMX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:23:57 -0400
In-Reply-To: <4A96501E.5020907@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Alexey Dobriyan wrote:
>> Conntracks in netns other than init_net dying list were never killed.
>>
>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 

Applied, thanks.
