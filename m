From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: nfmark IPV6 routing in OUTPUT, mangle,
 NFQUEUE
Date: Tue, 25 Nov 2008 12:18:41 +0100
Message-ID: <492BDF11.3030800@trash.net>
References: <1227559607-3077-1-git-send-email-eric@inl.fr> <1227559607-3077-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYKYLSv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:18:51 -0500
In-Reply-To: <1227559607-3077-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch let nfmark to be evaluated for routing decision for OUTPUT
> packet, in mangle table, when process paquet in NFQUEUE. This patch is
> an IPv6 port of Laurent Licour IPv4 one.

Also applied with a similar change, thanks Eric.
