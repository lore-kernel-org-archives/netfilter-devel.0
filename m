From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 06/11] remove obsolete prototypes
Date: Wed, 23 Jan 2008 12:15:51 +0100
Message-ID: <479721E7.1060609@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.70999.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49172 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773AbYAWLQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:16:16 -0500
In-Reply-To: <20080122141051.30077.70999.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  include/network.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied. Thanks. Probably we can get it back later to put most of
mcast_handler inside of it.

mcast_recv_netmsg(STATE_SYNC(mcast_server), net, sizeof(__net),
do_mcast_handler_step);

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
