From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH] support --physdev-out for routed packets
Date: Fri, 13 Jul 2007 10:58:03 +1000
Message-ID: <4696CE1B.1090600@snapgear.com>
References: <4695CCF8.1010202@snapgear.com> <4696225E.3000606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4696225E.3000606@trash.net>
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

Patrick McHardy wrote:
> Its probably also racy wrt. fdb changes.

Yes.  It could modify the bridging code to only forward to the
physoutdev stored in nf_bridge, or store the fdb result in
nf_bridge and avoid the second fdb lookup.

> The thing I still don't get
> is .. if you combine a bunch of devices in a bridge, why would you
> care which port a packet will leave through? If you already know
> behind which port something is reachable, why use a bridge? And if
> you don't know I suppose you have nothing to filter by.
> 

The devices in the bridge represent different security zones.
Using a bridging firewall gives physical separation of these zones
without requiring additional IP networks or configuration changes
for the machines on those networks.  The security policy has rules
defined primarily in terms of the zones, not the individual machines
in those zones.  Matching on just IP address is not enough, because
it does not enforce the physical separation.

We definitely could configure the firewall to know which address
is behind which port, and enforce this in ebtables.  This is the
solution Shorewall has used (I haven't looked to see if it enforces
the ports).  But that requires more configuration.  Basically it is
just a convenience argument.  I'll definitely be trying to migrate
things to this setup though.
