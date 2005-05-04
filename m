From: Patrick McHardy <kaber@trash.net>
Subject: Re: contrack and packets with error
Date: Wed, 4 May 2005 04:31:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0505040428270.16164@kaber.coreworks.de>
References: <1115172419.4363.8.camel@ceci.ws.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Diego Woitasen <diegows@linux.org.ar>
In-Reply-To: <1115172419.4363.8.camel@ceci.ws.ar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 3 May 2005, Diego Woitasen wrote:

> Reading the conntrack code, i see that conntrack return NF_ACCEPT when a
> packet is erroneous (proto->error() returns -1), so the packet is
> ignored by conntrack but continues traversing the protocol stack.
>
> The question is, why netfilter does not discard the packet?

conntrack does tracking not filtering, packets are only dropped
when it is necessary for accurate tracking. Otherwise the user can
decide to drop the packet in his ruleset based on the information
provided by conntrack.

Regards
Patrick
