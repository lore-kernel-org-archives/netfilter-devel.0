From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunois@info.ucl.ac.be>
Subject: Advice needed: changing the incoming network interface for a
	packet ?
Date: 12 Dec 2002 16:03:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039705404.3349.147.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Recently someone asked the list for some technique to change a packet's
arriving interface. For example : when a pkt comes from eth0, we'd like
to make it come from eth1. But, nobody could give him a technique for
that.
I can easily add this feature in the ROUTE target, but I've got some
questions which need your advice :

1) Is it already possible to do that with the current netfilter and
   iproute2 code ? (seems not)

2) Is this feature really useful ? Seems yes, see the Jason Liao's mail
   on 06 Dec 2002.

3) Is this feature desirable ? One could think this feature could be
   dangerous, because it could introduce loops in routing.

Any opinion ?

C=E9dric de Launois

PS: the ROUTE target is used to do unusual routing with packets. It
can force selected packets to go out through a specified interface or
to be sent to a special gateway. The ROUTE target never modifies the
packets.
