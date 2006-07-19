From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 19 Jul 2006 16:21:41 +0200
Message-ID: <44BE3FF5.4020503@trash.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>	<44B40B4E.6080206@shorewall.net>
	<44B4183E.7010905@trash.net>	<44B57A9F.9000403@shorewall.net>	<Pine.LNX.4.64.0607130933380.15827@x2>	<44B65492.3040506@shorewall.net>	<Pine.LNX.4.64.0607131638180.15827@x2>
	<44B6675B.6030000@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B6675B.6030000@shorewall.net>
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

Tom Eastep wrote:
> Patrick McHardy wrote:
> 
>>I don't really see why this can't be done purely within ebtables, it too
>>can filter based on protocol and port numbers. Do you also know of
>>examples where its really necessary to filter on bridge port and use
>>iptables' capabilities?
>>
> 
> 
> In Shorewall, filtering on bridge port is usually done *first* to select the
> appropriate rule chain. In that rule chain, the user has access to more or less
> the full box of iptables tools (at least those that are supported by kernels
> from kernel.org). To what extent those tools are actually used, I don't know.

It there anything preventing your users from you routing outgoing
packets to the bridge ports directly? I assume if they use IP/port
filters they should already have a pretty good idea of whats located
behind a bridge port and don't really need the bridge to route the
packets.
