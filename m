From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: ctnetlink: fix echo if not subscribed
 to any	multicast group
Date: Mon, 09 Feb 2009 14:27:22 +0100
Message-ID: <49902F3A.1020008@trash.net>
References: <20090127211457.10412.29085.stgit@Decadence> <20090127211519.10412.96490.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZBIN1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:27:24 -0500
In-Reply-To: <20090127211519.10412.96490.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch fixes echoing if the socket that has sent the request to
> create/update/delete an entry is not subscribed to any multicast
> group. With the current code, ctnetlink would not send the echo
> message via unicast as nfnetlink_send() would be skip.

Also applied, thanks.

