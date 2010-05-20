From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_core.c: fix for dead connection after flushing
 conntrack cache
Date: Thu, 20 May 2010 15:56:51 +0200
Message-ID: <4BF53FA3.2020600@trash.net>
References: <4BE3D31F.6000607@secunet.com> <4BE73DE3.6080304@netfilter.org> <4BE824EA.6000303@trash.net> <4BE83D93.8080909@secunet.com> <4BED2E93.1030004@trash.net> <4BF102D4.9050304@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Mail List - Netfilter <netfilter@vger.kernel.org>
To: Joerg Marx <joerg.marx@secunet.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BF102D4.9050304@secunet.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Appologies for the delay, I once again had a mail outage :|

Joerg Marx wrote:
> Subject: [PATCH] Fix a race in __nf_conntrack_confirm against nf_ct_get_next_corpse()
> 
> This race was triggered by a 'conntrack -F' command running in parallel
> to the insertion of a hash for a new connection.
> Losing this race led to a dead conntrack entry effectively blocking
> traffic for a particular connection until timeout or flushing the conntrack
> hashes again.
> Now the check for an already dying connection is done inside the lock.

Applied, thanks.
