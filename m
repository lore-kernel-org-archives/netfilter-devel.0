From: Ben La Monica <ben.lamonica@gmail.com>
Subject: Multiple Targets
Date: Sat, 19 Feb 2005 01:05:07 -0700
Message-ID: <7174b1e405021900052b4545c4@mail.gmail.com>
Reply-To: Ben La Monica <ben.lamonica@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hello,

I'm writing a firewall application for ISPs, and I'm realizing that my
tables could potentially get very long because there is no way to
perform multiple targets on a matched rule. I wanted to get the list's
feedback before I put too much effort into doing something like this.

Basically I have a long list of rules which I am matching mac
addresses against. If the mac is in the list, it is MARKed with a
group number. Based on this mark, the packets go through different
sets of rules and then on to the traffic shaper. Because I am limited
to one target per match, I have to either let the packet continue to
traverse through the entire chain, or put another, identical rule
following the first rule to have it RETURN to the previous chain to
continue processing. This is only an issue on non-terminating targets
(such as MARK, ULOG, LOG, etc)

Example (where n is the number of authorized macs):
iptables -N auth
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j MARK
--set-mark 1
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j RETURN
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j MARK
--set-mark 2
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j RETURN
... n ...
iptables -A auth -i int+ -m mac --mac-source FF:FF:FF:FF:FF:FF -j MARK
--set-mark n

I had the idea of allowing multiple targets, as long as the targets
before the last were non-terminating. Following on my example above,
it would look something like this:

iptables -N auth
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j
MARK,RETURN --set-mark 1
iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j
MARK,RETURN --set-mark 2
... n ...
iptables -A auth -i int+ -m mac --mac-source FF:FF:FF:FF:FF:FF -j
MARK,RETURN --set-mark n

This way, you could chain several targets together, and it would
execute them all until it hit a target that would decide the fate of
the packet. You could mark, log, and accept a packet with a single
match if you wanted to. I know you can do this to a certain extent by
creating a user-defined chain and then matching once and sending
packets to that user-defined chain.

If this is too ambitious or will break too many things, perhaps I
could just modify the RETURN target to do what I want it to do
(perform two returns instead of just one).

Please respond, even if it is to say, "That's stupid. Do it another way." :)

Thanks for your time.

-Ben La Monica
