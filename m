From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Sat, 08 Jul 2006 05:01:35 +0200
Message-ID: <44AF200F.9000204@trash.net>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44AEFE20.3020307@shorewall.net>
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
> 
>>+Why:	The defered output hooks are a bad layering violation causing
>>+	lots of unusual and broken behaviour on bridge devices.
>>+	Examples include broken QoS classifation using the MARK or
>>+	CLASSIFY targets, broken behaviour with the IPsec policy match,
>>+	broken connection tracking with VLAN on a bridge, ...
>>+
>>+	Their only use is to enable bridge output port filtering within
>>+	iptables with the physdev match, which can just as well be done by
>>+	combining iptables and ebtables using netfilter marks.
> 
> 
> Patrick,
> 
> Once again, netfilter marks are the solution of last resort. This is
> becoming very painful for those of us who produce general Netfilter
> configuration tools. The situation is exacerbated by the fact that
> ebtables doesn't support modifying the mark value via logical AND/OR and
> the other fwmark consumers (tc, ip) don't allow a mask when testing the
> fwmark value.

I understand your problems perfectly, one of my netfilter backgrounds
is creating (proprietary) high-level tools as well (aka typical
applicance vendor). I know the problems getting along with netfilter
marks and specifying reasonable limits, but this stuff has created
so much problems that I just don't care. If we need more bits, so be
it, and introducing bitwise operations to ebtables MARK can only be
a good thing anyway (and for that matter, in every other spot using
nfmark).

> Be that as it may, I'm having difficulty trying to apply your proposed
> approach to Shorewall.
> 
> Here's an example of a forwarding rule in Shorewall:
> 
> 	ACCEPT	foo	bar	tcp	25
> 
> 'foo' and 'bar' are "zone" names and in a bridged configuration each may
> be associated with a different port on a bridge. Today, there is a
> single rule that sends all 'foo' -> 'bar' packets to a separate chain
> (this isn't the exact rule is but it illustrates the point):
> 
> 	iptables -A FORWARD -i bridge -o bridge -m physdev \
> 	--physdev-in <foo port> --physdev-out <bar port> -j foo2bar
> 
> Given that the ebtables filter table FORWARD chain is traversed before
> the iptables filter table FORWARD chain, that single iptables command
> can be replaced by:
> 
> 	ebtables -A FORWARD -o <bar port> -j mark \
> 	--set-mark <bar mark> # --or-mark would be real handy here
> 
> 	iptables -A FORWARD -i <bridge> -o <bridge> -m physdev \
> 	--physdev-in <foo port> -m mark --mark <bar mark> -j foo2bar
> 
> The Shorewall rule listed above then creates:
> 
> 	iptables -A foo2bar -p tcp --dport 25 -j ACCEPT
> 
> At the end of the foo2bar chain is an unconditional rule that is
> determined by the effective foo->bar policy specified by the user;
> policy values include DROP, REJECT, ACCEPT and CONTINUE (CONTINUE is
> used for nested zones).
> 
> A similar approach is taken for locally-generated packets. There is a
> single rule to direct all 'fw' to 'bar' traffic to the 'fw2bar' chain
> ("fw" is the default name for the zone comprised of the local system):
> 
> 	iptables -A OUTPUT -o <bridge> -m physdev \
> 	--physdev-out <bar port> -j fw2bar
> 
> As with forwarding, the fw2bar chain ends with a rule that enforces the
> fw->bar policy.
> 
> Predictably, the Shorewall rule:
> 
> 	ACCEPT	fw	bar	tcp	25
> 
> generates:
> 
> 	iptables -A fw2bar -p tcp --dport 25 -j ACCEPT
> 
> I see no sensible way to eliminate the --physdev-out usage in the OUTPUT
> chain using ebtables/iptables and marking. What am I missing?

I'm a lazy reader, so I didn't follow this entirely. But:

"-i <bridge> -o <bridge> "

implies you're using this for purely bridged traffic. The feature
we're going to remove only affects locally generated traffic exiting
on a bridge device, in that case iptables _can't_ know the output
port. But you can do your iptables matching, mark matching packets
and filter on the mark within ebtables. Hmm .. actually that makes
me wonder why purely bridged traffic wouldn't have the same problem,
I can only imagine that it does similar violations. Let me look
into this ..
