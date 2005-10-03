From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Aren't these connections ESTABILISHED? (2nd take)
Date: Mon, 3 Oct 2005 10:24:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510031019460.22605@filer.marasystems.com>
References: <dhmn38$hsk$1@sea.gmane.org> <200510011907.27026.rob0@gmx.co.uk>
	<Pine.LNX.4.61.0510020410200.21519@filer.marasystems.com>
	<dhnoqq$bq8$1@sea.gmane.org>
	<Pine.LNX.4.61.0510021142470.6283@filer.marasystems.com>
	<Pine.LNX.4.58.0510021534200.25897@blackhole.kfki.hu>
	<Pine.LNX.4.61.0510021622210.9126@filer.marasystems.com>
	<Pine.LNX.4.58.0510022155370.26361@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Robert Nichols <rnicholsNOSPAM@comcast.net>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0510022155370.26361@blackhole.kfki.hu>
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

On Sun, 2 Oct 2005, Jozsef Kadlecsik wrote:

> But that relies on the assumption that the receiver side wants to close
> the session as well. If it enters the CLOSE_WAIT state instead, the
> connection will hang anyway in spite of letting through the FIN and
> assuming the LAST_ACK state.

Yes, but at that stage it is not a network problem, only a badly designed 
application who do not shut down when the other end closes the connection.

CLOSE_WAIT is waiting for the local application to close the local end of 
the connection.

> However how would conntrack loose an (established) connection? Or are we
> speaking of loading in conntrack "on the fly" when there are already
> established connections flowing through the firewall? That's doable
> but hairy and unreliable anyway due to the lost window scaling parameters.

Yes. Or more realisticly reboot of the firewall/router or failover between 
two firewalls/routers not using ctsync.

> Somehow I have got bad feelings on passing random RST segments.

And as I said it is of very little value.

Regards
Henrik
