From: "George" <George@xorgate.com>
Subject: Generalized helper module
Date: Mon, 27 Dec 2004 16:19:31 -0600
Message-ID: <GJECKKGCEGFDAGCADOGBIEBJCAAA.George@Xorgate.COM>
Reply-To: Perler@xorgate.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I occasionally I delve into netfilter problems and often find a desire for a
general purpose helper module.
This time I stumbled across ROPE.  Ref: http://www.lowth.com/rope/
However, it would be nice if the inspection and parameter syntax was
abbreviated such that it could be easily used in the iptables command line
and along the lines of the Ethereal display filter syntax.  It would need
the ability to signify RELATED packets. I should be easy to write a
dedicated helper module from the generalized syntax, in order to improve on
a generalized crutch.

... Which brings me back around to my current needs.

I'm trying to get netfilter to pass Doom3 server traffic.  The server is on
the private side of a two interface Linux netfilter router.  So far it
appears (I may have missed some the packet details) that the local server
registers itself with a Internet master-server using UDP dst port 27666.
Internet clients then attempt to connect to the local server by directly
sending UDP port 27666.  I want the initial outgoing master-server packets
from the internal Doom3 server to tag any incoming UDP dst 27666 packets as
RELATED, such that netfilter DNATS them back to the local Doom3 server.
Currently, I do not think that the payload has any data that is required to
make this work (but I may be wrong).

Comments please.

I do not subscribe to the netfilter-dev mailing list, so I you could
directly CC me, I would appreciate it.
