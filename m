From: JC <bikkit@gmail.com>
Subject: Approach on issue of multihoming
Date: Sat, 20 Aug 2005 04:29:22 -0700
Message-ID: <a60102c3050820042944b0ecb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I was hoping someone could possibly shed some light into this or at
least point me to the right direction... I hope you can forgive the
naivety of my questions.

I am trying to develop a kernel module level solution for dynamic host
multihoming. What that means is packets from an application, upon one
of the interfaces going down or another prerequisite met, are NATed to
another pre-defined interface (at least two present on a box). This
requires that I mangle packets from specific applications running on
the system -defined by their source port used- right in the stack and
basically changing the interface the packets are sent from.

Leaving aside the fact that this is going to break all connections
from applications that are not "clever" to adjust to that change and
have them all reset (the project includes the development of an API
that that applications can use to adjust), I understand that I have 2
options for doing this:

a) write a module that registers my mangling function with one of
the 5 netfilter hooks (the ROUTING one?), grab the interesting packets
identified by the application source port and change the source IP,
also making sure to do the opposite for the "relevant" incoming
packets the other way.

b) write a NAT helper module that handles the connection from the
start, and then having it NAT the packets of the application, changing
to the new source IP. This solution shows more promise, as it is more
readily capable of manipulating data in the connection, and it also
blends nicer with the iptables. My problem is, where does this NAT
helper module come? How do I insert into the system a helper module I
might implement? And how do I set it up for use?

I hope I can get some help over this issue, as it is more than
confussing me and at the moment I'm simply stuck as to how to move
forward.

regards,
JC
