From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Aren't these connections ESTABILISHED? (2nd take)
Date: Sun, 2 Oct 2005 22:23:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0510022155370.26361@blackhole.kfki.hu>
References: <dhmn38$hsk$1@sea.gmane.org> <200510011907.27026.rob0@gmx.co.uk>
	<Pine.LNX.4.61.0510020410200.21519@filer.marasystems.com>
	<dhnoqq$bq8$1@sea.gmane.org>
	<Pine.LNX.4.61.0510021142470.6283@filer.marasystems.com>
	<Pine.LNX.4.58.0510021534200.25897@blackhole.kfki.hu>
	<Pine.LNX.4.61.0510021622210.9126@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Robert Nichols <rnicholsNOSPAM@comcast.net>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510021622210.9126@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2 Oct 2005, Henrik Nordstrom wrote:

> On Sun, 2 Oct 2005, Jozsef Kadlecsik wrote:
>
> > If a FIN receives which does not belong to any existing connection in
> > the conntrack table, which state should we assign to the "new" connection
> > "established" by the FIN? Was it the first FIN (half-closed session) or
> > the second FIN from the other direction?
>
> If you assume it's the second then it's a good approximation, and
> sufficient to push the TCP on the receiving host into a state from which
> there is a guaranteed timeout as it's then only waiting on itself to
> finish what it is doing.

But that relies on the assumption that the receiver side wants to close
the session as well. If it enters the CLOSE_WAIT state instead, the
connection will hang anyway in spite of letting through the FIN and
assuming the LAST_ACK state.

However how would conntrack loose an (established) connection? Or are we
speaking of loading in conntrack "on the fly" when there are already
established connections flowing through the firewall? That's doable
but hairy and unreliable anyway due to the lost window scaling parameters.

> If the FIN is dropped then communication may stall indefinitely unless the
> protocol is using an application level timeout or TCP keepalive.
>
> > I dunno how a lone RST could signal to pick up a connection.
>
> It should be the same as a RST in an existing connection, no more, not
> much less. It has some value to the receiving host telling it to shut down
> a matching TCP. But this is considerably less important than the FIN as
> the RST is very unreliable anyway and protocols using initiated RST (not
> in direct response to a received packet) ashould have appropriate
> application level timeouts on their connections.

Somehow I have got bad feelings on passing random RST segments.

It is assumed (I think) that the hung connection is in the established
state. That does not hurt the host, does not pose as a possible DoS
situation or bottleneck. It also does not prevent establishing a new
connection over the hung one, we make special efforts for enabling that.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
