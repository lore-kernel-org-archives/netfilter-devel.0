From: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Subject: Re: LibIPQ issue
Date: Mon, 7 Mar 2005 19:17:15 +0000
Message-ID: <e54bc1880503071117322999d@mail.gmail.com>
References: <e54bc1880503070451419fc57@mail.gmail.com>
	<422C52AB.4030801@trash.net>
Reply-To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <422C52AB.4030801@trash.net>
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

On Mon, 07 Mar 2005 14:10:03 +0100, Patrick McHardy <kaber@trash.net> wrote=
:
> S=E9rgio Bernardino wrote:
> >
> > iptables -t filter -A OUTPUT -p ip -j QUEUE
> >
> > I can alter the destination address of the outgoing packet (for
> > example, a packet that goes from A to B becomes a packet that goes
> > from A to A, a localhost packet), and it all works fine.
> > I seems like i'm doing something wrong but i can't quite figure out
> > what. Any ideas?
>=20
> Packets in LOCAL_OUT are manually rerouted by ip_queue. Packets
> mangled in PRE_ROUTING should be routed correctly according to
> the data contained in the new packet. Could it be that you are
> testing on loopback ?
>=20
> Regards
> Patrick
>=20

I've always tested it with two or three different machines and the
only rerouting that always worked was the one that occurred when i
changed packet caught in LOCAL_OUT. Curiously enough the packet that i
mangle in PRE_ROUTING seems to disappear. It doesn't "show" on the
current machine (machine B, according to my previous example), on the
intended machine (machine C) and i can't seem to track it with tcpdump
after i committed the changes and ACCEPTed the packet.
The example i gave with LOCAL_OUT rerouting a packet to make it seem
like it's a localhost packet is just that, an example. In fact, i can
reroute packets intended to a machine so that they show up on another
one by changing them in LOCAL_OUT. It works fine. But since you say
that that ip_queue manually reroutes the packets, the situation is
clearly different from what occurs in PRE_ROUTING. I pretty certain
that the information is modified correctly. In fact, the code i use to
change packets caught in PRE_ROUTING is virtually identical to the
code i use to change packets caught in LOCAL_OUT. So, basically, i'm
quite unsure of what's exactly wrong. Specially since you've confirmed
that it should work.
Thank you for your time.

--=20
S=E9rgio Bernardino

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"The Dragon awakens in the darkness
with a frozen heart he roars.
If you are close, the dragon sleeps
And when the wings appear before him
people's dreams will fill the sky..."
