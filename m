From: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Subject: LibIPQ issue
Date: Mon, 7 Mar 2005 12:51:40 +0000
Message-ID: <e54bc1880503070451419fc57@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

Greetings to all.
I have a small problem in regards to libipq and the effects of
altering packets in userspace. I was wondering if anyone could help me
clear the issue. Here's the situation:
Consider three machines: A, B and C. They are located in a LAN. Now, i
sent a packet from A to B. On the machine B i have the following
iptables rule:

iptables -t mangle -A PREROUTING -p ip -j QUEUE

Inside the program i created to deal with the packets i queue into
userspace i change the destination address on the IP header to point
to the machine C and ACCEPT the packet with all the changes. Now, as
far as i can tell and for what i've gathered from reading this,

http://iptables-tutorial.frozentux.net/chunkyhtml/traversingoftables.html=
=20

I'm changing the packet before the routing decision, hence, it should
continue to traverse the network and reach machine C instead of
"staying" on machine B. The thing is, nothing happens. I'm sure the
packet is valid, and that i recalculate the checksum correctly and
such since i've tested it several times. In fact, in the case where i
have the following iptables rule:

iptables -t filter -A OUTPUT -p ip -j QUEUE

I can alter the destination address of the outgoing packet (for
example, a packet that goes from A to B becomes a packet that goes
from A to A, a localhost packet), and it all works fine.
I seems like i'm doing something wrong but i can't quite figure out
what. Any ideas?
Thank you.
--=20
S=E9rgio Bernardino

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"The Dragon awakens in the darkness
with a frozen heart he roars.
If you are close, the dragon sleeps
And when the wings appear before him
people's dreams will fill the sky..."
