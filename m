From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 09:46:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607130937580.15827@x2>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B493BC.5010302@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <44B493BC.5010302@snapgear.com>
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

On Wed, 12 Jul 2006, Philip Craig wrote:

> Patrick McHardy wrote:
>> I'm a lazy reader, so I didn't follow this entirely. But:
>>
>> "-i <bridge> -o <bridge> "
>>
>> implies you're using this for purely bridged traffic. The feature
>> we're going to remove only affects locally generated traffic exiting
>> on a bridge device, in that case iptables _can't_ know the output
>> port.
>
> It also affects forwarded packets that are routed out the bridge device?
> ie anything that is routed out a bridge device, because iptables sees
> the packet before bridging does its stuff.  Purely bridged packets are
> fine though, because they don't actually leave the bridge device, the
> bridging code just calls the netfilter hooks at the appropriate time.

Exactly.

> Would it be possible to call the bridging code from the iptables
> forward/output hooks, store the result somewhere, and then when the
> packet is passed to the bridge device, just use the stored result?
> So fix the problem by calling bridging early, instead of deferring
> iptables?  I'm not sure if this could handle packets that need to
> be sent out multiple ports.

No, it couldn't. Its questionable behaviour to do this anyway, think
about something you REJECT without looking at the output port - you
will reject once for each output port. The entire idea of using
iptables from the bridge code seems flawed to me. Conntrack might
also get very confused under certain cicurstances.

> And possibly related, could this be done for arp lookups too, so
> that output mac matching is possible?

Theoretically yes, but I'm trying to get rid of a problem here,
not introduce new ones :)

>> But you can do your iptables matching, mark matching packets
>> and filter on the mark within ebtables.
>
> I haven't thought about this too much, but for a high-level tool,
> the rules can theoretically be too complicated for this to be feasible.
> The worst case will be to perform all the possible matches that are
> supported by iptables but not ebtables, and encode the result of all
> of these into the mark.  And even if this can be optimized, I can
> imagine the code to do it being quite complex.


Its a bit easier, but I don't see that as a real problem, its a high
level tool after all, its OK if things get a bit complicated.
