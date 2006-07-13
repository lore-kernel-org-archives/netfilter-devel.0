From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 16:45:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607131638180.15827@x2>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net> <Pine.LNX.4.64.0607130933380.15827@x2>
	<44B65492.3040506@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B65492.3040506@shorewall.net>
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


On Thu, 13 Jul 2006, Tom Eastep wrote:

> Patrick McHardy wrote:
>
>>
>> Thanks. I'm currently travelling, I'll look at this on Sunday when I get
>> back home (haven't received it yet I think). Do you know on which criteria
>> they filter in addition to the bridge port?
>>
>
> Typically, they will also filter on protocol and the destination port (if the
> protocol is TCP or UDP).


And the really differentiate between different bridge ports for this, i.e.
port eth0 may receive packets on port 80, port eth1 may not?

I don't really see why this can't be done purely within ebtables, it too
can filter based on protocol and port numbers. Do you also know of
examples where its really necessary to filter on bridge port and use
iptables' capabilities?
