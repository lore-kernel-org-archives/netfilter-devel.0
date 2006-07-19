From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Wed, 19 Jul 2006 18:02:21 +0200
Message-ID: <44BE578D.8070606@trash.net>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>	
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>	
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>	
	<44B57A9F.9000403@shorewall.net>	<Pine.LNX.4.64.0607130933380.15827@x2>	
	<44B65492.3040506@shorewall.net>	<Pine.LNX.4.64.0607131638180.15827@x2>	
	<44B6675B.6030000@shorewall.net> <44BE3FF5.4020503@trash.net>
	<1153324259.9763.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <1153324259.9763.29.camel@localhost.localdomain>
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
> On Wed, 2006-07-19 at 16:21 +0200, Patrick McHardy wrote:
> 
>>It there anything preventing your users from you routing outgoing
>>packets to the bridge ports directly? I assume if they use IP/port
>>filters they should already have a pretty good idea of whats located
>>behind a bridge port and don't really need the bridge to route the
>>packets.
>>
> 
> 
> It is possible to define a Shorewall zone as a set of (interface,
> network) pairs (where 'network' may be a single host) rather than a set
> of (bridge, port) pairs. So instead of defining a bridged zone as 'all
> hosts whose traffic goes in/out port P on bridge B', the user can define
> the same zone as (B,net1),(B,net2),... where net1,net2,... defines the
> same set of hosts (extra care must be taken when a default route goes
> through a bridge port)
> 
> While this alternative definition is more cumbersome and error-prone for
> the user to configure and maintain, it removes the need for filtering by
> bridge port entirely. That approach is probably what I will recommend to
> current users when --physdev-out is no longer available.

That should work if the location of the hosts is already known. But in
that case I still wonder why route to the bridge at all .. the ports
should work as well as long as you know where the individual hosts are
located.

Anyway, glad you found a viable alternative for shorewall.
