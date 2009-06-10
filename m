From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 15:47:49 +0200
Message-ID: <4A2FB985.8030002@netfilter.org>
References: <20090610133716.14805.95308.stgit@Decadence> <20090610134150.14805.4528.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55222 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZFJNrz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:47:55 -0400
In-Reply-To: <20090610134150.14805.4528.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch improves ctnetlink event reliability if one broadcast
> listener has set the NETLINK_BROADCAST_ERROR socket option.

This is missing reliable event delivery for _eventmask_report(). I'm
going to resend this patch. Sorry and rebase my git tree with the new patch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
