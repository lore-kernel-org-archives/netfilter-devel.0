From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH] NAT for unreplied connections
Date: Wed, 05 Jun 2002 11:23:03 +1000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFD67F7.5000801@snapgear.com>
References: <3CFC7DCA.9030801@snapgear.com> <200206041501.06434.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> The MASQUERADE target comes to mind here.. it is approaching the same problem 
> from a different angle, and in my opinion a better one.. MASQUERADE kills all 
> relevant conntrack entries when the interface changes, to deal cleanly with 
> the situation of dynamic IP assignment where the IP may change while the 
> netfilter kernel is running and actively tracking packets..

Yes, the MASQUERADE target helps a lot, but it doesn't quite do everything
I need.  One of the places the problem is occuring is for dial on demand PPP.
This uses a slip interface to trigger the dial.  When the ppp interface comes
up, any packets for connections that initially went through the slip interface
will be transmitted unNATed (including the packets from the slip interface
that diald buffered).

A solution might be to add a MASQUERADE rule for the slip interface, and bring
the slip down once I know the ppp is up.  So in general I need to ensure that
there is always MASQUERADE rule for the current route that an outgoing packet
will take, and to bring the old interface down if there is a route change.
This is still kind of a workaround for the problem, but if it works then I
think that's good enough.


> The main problem with your approach is retransmitted packets. As you tear down 
> the conntrack entry on each retransmission until the connection has been 
> reassured, the retransmitted packets may well have a different NAT tuple 
> selected than the original one. If then the first packet reaches the origin 
> server then you will be in trouble. This may well happen even without any 
> rule change in NAT, simply as an effect of traffic pattern or a complex 
> ruleset intentionally varying the NAT selection. Not very good. You need to 
> have some other criteria to determine when it is safe to forget the NAT 
> state.

I'd thought at first that this wouldn't be too much of a problem for
TCP... it would just look to the server like two separate connections were
being initiated, and the first one would never be established.  I agree
that it's not very good behaviour though.

Regards,
Phil
