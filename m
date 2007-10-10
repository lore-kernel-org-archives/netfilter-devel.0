From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Add ip6t_ aliases
Date: Thu, 11 Oct 2007 01:39:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710110138190.26305@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr>
 <20071010.163346.54951705.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36413 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbXJJXjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:39:12 -0400
In-Reply-To: <20071010.163346.54951705.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 10 2007 16:33, David Miller wrote:
>> 
>> I think this latecomer patch should go into 2.6.24.
>> 
>> ===
>> 
>> Add missing ip6t_modulename aliases.
>> 
>> The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
>> otherwise you will get
>> 
>> 	ip6tables: No chain/target/match by that name
>> 
>> when xt_<modulename> is not already loaded.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
>Patrick?
>

Oops. But please remove the hunk for xt_conntrack.c before applyign, I
just noticed it does not do AF_INET6.
