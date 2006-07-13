From: Philip Craig <philipc@snapgear.com>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 18:12:29 +1000
Message-ID: <44B6006D.9010900@snapgear.com>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>	<44B493BC.5010302@snapgear.com>
	<Pine.LNX.4.64.0607130937580.15827@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.64.0607130937580.15827@x2>
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
> On Wed, 12 Jul 2006, Philip Craig wrote:
>
>> Patrick McHardy wrote:
>> Would it be possible to call the bridging code from the iptables
>> forward/output hooks, store the result somewhere, and then when the
>> packet is passed to the bridge device, just use the stored result?
>> So fix the problem by calling bridging early, instead of deferring
>> iptables?  I'm not sure if this could handle packets that need to
>> be sent out multiple ports.
>
> No, it couldn't. Its questionable behaviour to do this anyway, think
> about something you REJECT without looking at the output port - you
> will reject once for each output port. The entire idea of using
> iptables from the bridge code seems flawed to me. Conntrack might
> also get very confused under certain cicurstances.

These are also problems for purely bridged packets.  br_flood calls
__br_forward for every port, which calls the bridge forward hook, and
that passes the packet on to the ipv4 forward hook.  Should this be
changed so that the ipv4 forward hook is called earlier, and filtering
on output port is never possible?
