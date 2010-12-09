From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] xtables: use guarded types
Date: Thu, 09 Dec 2010 11:43:35 +0100
Message-ID: <4D00B2D7.4010401@netfilter.org>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab0LIKnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:43:45 -0500
In-Reply-To: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/12/10 20:13, Jan Engelhardt wrote:
> parent b880c1f077000956b9f475d5f3b6c5e45ff2e342 (v2.6.37-rc1-241-gb880c1f)
> commit 4826151aedbe6e364b7b801f026fbe7383904b6a
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Dec 2 21:01:17 2010 +0100
> 
> netfilter: xtables: use guarded types
> 
> We are supposed to use the kernel's own types in userspace exports.

What's the point to have different headers in the kernel source code
tree and iptables? They are just a copy, I think it's fine to keep them
in sync with the kernel.
