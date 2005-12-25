From: Patrick Schaaf <bof@bof.de>
Subject: Re: iptables -m mac, --mac-dst support.
Date: Sun, 25 Dec 2005 07:41:45 +0100
Message-ID: <20051225064145.GB11503@oknodo.bof.de>
References: <1314478676.20051225023749@vkt.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jarek <hugle@vkt.lt>
Content-Disposition: inline
In-Reply-To: <1314478676.20051225023749@vkt.lt>
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

> I was wondering if there is somewhere around a patch to support MAC
> based not on source but on destination. ? Cause I'd like to check if
> dst ID and dst MAC are x.x.x.x and zx:as:qw:zx:as:qw
> 
> If yes maybe you could share it, and if no.. any ideas if it's going to
> show up or maybe not at all?

Standard answer: for outgoing packets, matching on destination MAC,
means waiting for an ARP request to resolve, first. But iptables is
already done with the packet before it will even be queued to the
output device, and before ARP processing is done.

Thus, at the moment when iptables filter rules (and also all other
tables) run, you simply cannot rely on a destination MAC being known.
Most of the time (after the initial ARP), it will, but what does it
help you to have an unreliable match criterion?

Also note that it is trivial for an end system to manipulate
its MAC addresses. Thus, MAC filtering on a router, without
the help of per-port-at-L2 MAC fixing on all neighbouring
(managed) ethernet switches, does not give you real security
at all.

best regards
  Patrick
