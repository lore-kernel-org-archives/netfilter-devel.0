From: =?ISO-8859-1?Q?J=F8rn_Andre?= <jornandr@stud.ntnu.no>
Subject: Olsr and Netfilter
Date: Mon, 14 Mar 2005 21:57:54 +0100
Message-ID: <4235FAD2.9090009@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi!

I'm a newbie on kernel programming and on NETFILTER and in the middle of
making a netfilter-hook into PREROUTING and INPUT that simply changes=20
the destination
of a packet. From the source-code I've read from Rusty Russel
and Harald Welte guide I can not see any difficulties with doing this,=20
but in case
I'm wrong and before I try to break my kernel open....is it not=20
possibly  to hook
in and change the destination of a packet  and then push it on without=20
further notice?

I'm making a plugin for the Unik Olsrd implementation which is supposed=20
to eliminate
the gateway-problem it has. By changing the destination in INPUT  at the=20
source-host and then
change it back to the original in PREROUTING at the gateway I can=20
preserve the route
and avoid a reset when the protocol changes default gateway because of=20
topology changes.

J=F8rn Andre
