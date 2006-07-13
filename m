From: Amin Azez <azez@ufomechanic.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 10:56:39 +0100
Message-ID: <44B618D7.3070806@ufomechanic.net>
References: <44AA3446.6050609@trash.net>	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>	<44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net>	<44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B57A9F.9000403@shorewall.net>
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
> I copied you privately on the survey that I sent out to Shorewall users -- so
> far, two out of four responders filter traffic from the firewall to the bridge
> based on egress port and three out of four filter outbound bridge traffic routed
> from an unbridged interface based on egress port.


I've been thinking how similar the problems of apache rewrite rules are
to the problems of iptables we discuss here.

Apache folk ended up doing a fake "look-ahead" to show how a request
would be handled and so how some of the request fields that are not set
WOULD be set. In apache such look-ahead could cause recursion but
request "notes" (like iptables marks) or other mechanisms are used so
that rewrite matches can tell that when they are operating under
look-ahead and stop being clever in those cases.

It seems like some iptables rules want to say: If the packet WOULD have
been handled thus, then handle it like this instead. Of course, when
there is more than one type of rule doing his, finding out how a packet
"WOULD" have been routed can be "interesting".

Maybe we can fix up bridging behaviour to follow routing rules.
What if bridged packets could be routed to the target ip and mac and
bridge, as if it were an existing route in the route table? This perhaps
would involve mild freakery in the routing code. From an external view
it would still look like bridging? (I want a conntrack to be able to
cache a route anyway so that a route won't change on established
connections even if the routing results would be different);

The odds of Patrick slapping is head with exasperation at my imperfect
understanding are quite high, I admit. (Perhaps I'm side stepping too
much other important bridging features)

Sam
