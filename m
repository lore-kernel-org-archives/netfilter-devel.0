From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 19 Jul 2006 18:36:46 +0200
Message-ID: <44BE5F9E.8020603@trash.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>	<44B493BC.5010302@snapgear.com>
	<Pine.LNX.4.64.0607130937580.15827@x2>	<44B654AF.2080401@ufomechanic.net>
	<Pine.LNX.4.64.0607131646090.15827@x2>
	<44B666C5.8040603@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44B666C5.8040603@ufomechanic.net>
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

Amin Azez wrote:
> Intercepting some traffic types and sending them via alternate gateways,
> (i.e. VPN gateways if the VPN is up) for errr... people who don't want
> to change the network default gateway for the whole network; also, for
> managing certain services for multi-subnet'd segments. I guess its part
> of the fashion to do things in layer2 these days as it involves less
> infrastructure change. For them.
> 
> I think Philip was right and my slight suggestion is wrong; I can't
> "look ahead" as ebtables would need to process the "look ahead" also,
> and influencing the look ahead (as well as counting the look-ahead packets)
> 
> I think cracking open the bridge code to fit the same model as the ip
> routing code, so it works out how to bridge it at just the same point
> the routing code calculates a route and then output device; but saves
> the answer for later when the final hooks have been traversed.

The routing code shouldn't know anything about the bridge FDB.

> I think if ebtables becomes the answer it will just grow to be as big as
> iptables with all the extra matches iptables has, just as iptables has
> extra -p tcp and -p udp matches.

Thats where MARK will be useful, but only if the target is available
in ebtables. SNAT based on bridge port won't be possible anymore.
