From: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Subject: Re: LibIPQ issue
Date: Tue, 8 Mar 2005 23:08:17 +0000
Message-ID: <e54bc188050308150854d6b128@mail.gmail.com>
References: <e54bc1880503070451419fc57@mail.gmail.com>
	<422C52AB.4030801@trash.net>
	<e54bc1880503071117322999d@mail.gmail.com>
	<Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
Reply-To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
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

After a bit more time working with this i realized something "interesting":
When i send a packet from a machine A to a machine B and capture it in
PRE_ROUTING, if i change the destination address so that it points to
machine C, the packet disappears and i can't track it anywhere. On the
other hand, if i instead change the source address of the packet so
that it points to machine C everything works fine. I can "see" the
packet traversing into machine B, which receives the packet and
promptly replies sending a packet to machine C. Machine A never
receives a reply to the packet it sent and machine C receives a reply
from a packet it never sent. Exactly the behaviour expected when
changing the source address field. Now, if this works in this case,
merely changing it to alter the destination address (my original
intention) should work also, but it doesn't.
My code can't be incorrect in a situation like this, so what exactly
is wrong? And is there a away to solve such situation?
Ideas anyone?


On Mon, 7 Mar 2005 20:30:03 +0100 (CET), Patrick McHardy
<kaber@trash.net> wrote:
> On Mon, 7 Mar 2005, [x-unknown] S=E9rgio Bernardino wrote:
>=20
> > I've always tested it with two or three different machines and the
> > only rerouting that always worked was the one that occurred when i
> > changed packet caught in LOCAL_OUT. Curiously enough the packet that i
> > mangle in PRE_ROUTING seems to disappear. It doesn't "show" on the
> > current machine (machine B, according to my previous example), on the
> > intended machine (machine C) and i can't seem to track it with tcpdump
> > after i committed the changes and ACCEPTed the packet.
> > The example i gave with LOCAL_OUT rerouting a packet to make it seem
> > like it's a localhost packet is just that, an example. In fact, i can
> > reroute packets intended to a machine so that they show up on another
> > one by changing them in LOCAL_OUT. It works fine. But since you say
> > that that ip_queue manually reroutes the packets, the situation is
> > clearly different from what occurs in PRE_ROUTING. I pretty certain
> > that the information is modified correctly. In fact, the code i use to
> > change packets caught in PRE_ROUTING is virtually identical to the
> > code i use to change packets caught in LOCAL_OUT. So, basically, i'm
> > quite unsure of what's exactly wrong. Specially since you've confirmed
> > that it should work.
>=20
> Please send the code you use for testing so I can try myself.
>=20
> Regards
> Patrick
>=20


--=20
S=E9rgio Bernardino

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"The Dragon awakens in the darkness
with a frozen heart he roars.
If you are close, the dragon sleeps
And when the wings appear before him
people's dreams will fill the sky..."
