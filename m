From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Suppress usage of lastnlh as it was overwritting last
	packet of the message.
Date: Mon, 17 Sep 2007 15:41:57 +0200
Message-ID: <46EE8425.6020607@trash.net>
References: <43447.213.144.15.9.1189673913.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from stinky.trash.net ([213.144.137.162]:40950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbXIQNsJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:48:09 -0400
In-Reply-To: <43447.213.144.15.9.1189673913.squirrel@mail.inl.fr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Eric Leblond wrote:
> Hello,
> 
> The following patch fixes the handling of netlink packets containing
> multiple messages.
> 
> As exposed during netfilter workshop, nfnetlink_log was overwritten the
> message type of the last message (setting it to MSG_DONE) in a multipart
> packet. The consequence was libnfnetlink to ignore the last message in the
> packet.
> 
> The following patch adds a supplementary message (with type MSG_DONE) af
> the end of the netlink skb.


Applied, thanks Eric.

SVN currently doesn't work, I'll look into your ulogd patch after trying
to fix it ...

