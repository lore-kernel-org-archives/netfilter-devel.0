From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Aren't these connections ESTABILISHED? (2nd take)
Date: Sun, 2 Oct 2005 16:44:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510021622210.9126@filer.marasystems.com>
References: <dhmn38$hsk$1@sea.gmane.org> <200510011907.27026.rob0@gmx.co.uk>
	<Pine.LNX.4.61.0510020410200.21519@filer.marasystems.com>
	<dhnoqq$bq8$1@sea.gmane.org>
	<Pine.LNX.4.61.0510021142470.6283@filer.marasystems.com>
	<Pine.LNX.4.58.0510021534200.25897@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Robert Nichols <rnicholsNOSPAM@comcast.net>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0510021534200.25897@blackhole.kfki.hu>
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

On Sun, 2 Oct 2005, Jozsef Kadlecsik wrote:

> If a FIN receives which does not belong to any existing connection in
> the conntrack table, which state should we assign to the "new" connection
> "established" by the FIN? Was it the first FIN (half-closed session) or
> the second FIN from the other direction?

If you assume it's the second then it's a good approximation, and 
sufficient to push the TCP on the receiving host into a state from which 
there is a guaranteed timeout as it's then only waiting on itself to 
finish what it is doing.

If the FIN is dropped then communication may stall indefinitely unless the 
protocol is using an application level timeout or TCP keepalive.

> I dunno how a lone RST could signal to pick up a connection.

It should be the same as a RST in an existing connection, no more, not 
much less. It has some value to the receiving host telling it to shut down 
a matching TCP. But this is considerably less important than the FIN as 
the RST is very unreliable anyway and protocols using initiated RST (not 
in direct response to a received packet) ashould have appropriate 
application level timeouts on their connections.

Regards
Henrik
