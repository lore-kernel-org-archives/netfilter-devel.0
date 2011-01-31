From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] CT: add "none" as parameter for --ctevents
Date: Mon, 31 Jan 2011 23:58:32 +0100
Message-ID: <4D473E98.8080505@netfilter.org>
References: <20110131224856.4390.31272.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab1AaW6g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:58:36 -0500
In-Reply-To: <20110131224856.4390.31272.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/01/11 23:48, Pablo Neira Ayuso wrote:
> This allows not to deliver any event. This can be useful if you want
> no events for some protocols, for example:
> 
> iptables -I PREROUTING -t raw -p udp -j CT --ctevents none
> 
> Thus, no events for UDP traffic are delivered to user-space.

This patch is broken, I'll fix it and resend, sorry.
