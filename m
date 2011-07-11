From: Patrick McHardy <kaber@trash.net>
Subject: Re: Implicit loading of module xt_set.
Date: Mon, 11 Jul 2011 11:46:09 +0200
Message-ID: <4E1AC661.7040309@trash.net>
References: <201107051713.55991.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46179 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GKJqN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:46:13 -0400
In-Reply-To: <201107051713.55991.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 05.07.2011 18:13, schrieb Steven Jan Springl:
> Hello
> 
> The following command implicitly loads module xt_set:
> 
> ip6tables -A INPUT -m set --match-set sjs src -j ACCEPT
> 
> However, the following command does not implicitly load module xt_set:
> 
> iptables -A INPUT -m set --match-set sjs src -j ACCEPT
> 
> Instead the following message is issued:
> 
> iptables: No chain/target/match by that name.

No, the proper module aliases are in place, so I'm guessting
something else is missing in your configuration. Please send
your .config file.
