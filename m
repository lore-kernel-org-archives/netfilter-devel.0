From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 09:31:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607130930190.15827@x2>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B493BC.5010302@snapgear.com> <44B591C5.8080604@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B591C5.8080604@shorewall.net>
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

On Wed, 12 Jul 2006, Tom Eastep wrote:

> Philip Craig wrote:
>> Patrick McHardy wrote:
>
>>
>>> But you can do your iptables matching, mark matching packets
>>> and filter on the mark within ebtables.
>>
>> I haven't thought about this too much, but for a high-level tool,
>> the rules can theoretically be too complicated for this to be feasible.
>> The worst case will be to perform all the possible matches that are
>> supported by iptables but not ebtables, and encode the result of all
>> of these into the mark.  And even if this can be optimized, I can
>> imagine the code to do it being quite complex.


>From what I can see, you would need one mark value for each combination
of bridge port and target.

> The proposed solution requires high-level tools to have two completely
> different paradigms for filtering traffic; one for when the output
> device is a bridge and the packet is locally-generated (and possibly
> when the input device is not the same bridge -- I'm still not clear on
> that point) and the other is applied everywhere else. In one case,
> filtering rules are contained in the filter table and use standard
> filter targets -- in the other case, they must be placed in the mangle
> table and use the MARK target. That, in and of itself, is a ugly change
> for Shorewall which has a nice uniform structure for generating
> filtering rules.


True, that isn't very nice. But its only required for filtering
based on bridge ports, not for the bridge device itself. I'm
not sure if this is possible, but since you're filtering based
on the bridge port, I assume you allow only certain IP addresses
or something like that. Couldn't you just route them directly
to the bridge port instead?

> I think that the mark values can be optimized down to two fwmark bits
> per Shorewall zone. If the first bit is set, traffic is allowed to the
> zone; if the other bit is set, the traffic is not allowed (our users
> lose the ability to use the REJECT target since ebtables can only ACCEPT
> or DROP). Two separate bits are required so that Shorewall can detect
> packets that don't match any rules and hence are subject to the
> applicable user-specified policy (MARK isn't terminating).
>
> In Shorewall, there needs to be a few more fwmark bits reserved to
> indicate if and at what level the packet should be logged if it is
> dropped and a similar number of bits to indicate if and at what level
> the packet should be logged if it is accepted. And finally, a few more
> fwmark bits will need to be allocated to indicate the contents of the
> log-prefix. From what I gather, ebtables doesn't support ULOG so that
> form of logging won't be available.
>
> Shorewall supports 'actions' which are essentially user-defined filter
> chains; actions can be invoked in other filtering rules (a --jump to the
> action chain results). With --physdev-out limited as proposed, actions
> must generate either a filter table chain or a mangle table chain or
> both (the mangle table chains must be tailored for each destination zone
> in the rules where the action is invoked since the mark values are
> dependent on the destination zone in the invoking rule). Shorewall today
> needs to tailor the chain based on the invoking context and that part of
> the code is complex and error prone.
>
> The original support for bridge-port based filtering was added to
> Shorewall in a weekend, including the documentation (I can only work on
> Shorewall off hours). To maintain even reduced support for this feature
> will require considerably more effort and will result, I fear, in a less
> maintainable product.
>
> In summary, I think that the complexity is probably manageable but this
> is really ugly ...


Its getting harder, no doubt about that. But if you check bugzilla and
the lists we had tons of reports of other things this breaks, and I
lean towards having consistent behaviour instead of a rarely used
feature. The simple fact is that the output bridge port is outside of
the scope of what iptables can know for routed traffic and this feature
should have never been introduced in the first place (in which case
I guess nobody would be complaining). I'm open to suggestions how to
make it easier for users getting rid of this, but we still need to
get rid of it.
