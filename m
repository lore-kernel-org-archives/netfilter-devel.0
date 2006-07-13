From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 16:50:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607131646090.15827@x2>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B493BC.5010302@snapgear.com> <Pine.LNX.4.64.0607130937580.15827@x2>
	<44B654AF.2080401@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44B654AF.2080401@ufomechanic.net>
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

On Thu, 13 Jul 2006, Amin Azez wrote:

> * Patrick McHardy wrote, On 13/07/06 08:46:
>
>>> And possibly related, could this be done for arp lookups too, so
>>> that output mac matching is possible?
>>
>> Theoretically yes, but I'm trying to get rid of a problem here,
>> not introduce new ones :)
>
> The difficulty I am now trying to solve is that of SNAT-ing bridged
> traffic depending on the output port.
>
> Bridging is really layer2 routing and so it makes a lot of sense to
> handle it like this.

And what will the usage scenario of this be?
