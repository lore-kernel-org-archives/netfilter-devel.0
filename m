From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Logs behind a transparent proxy
Date: Wed, 29 Jan 2003 11:46:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301291146.48346.bdschuym@pandora.be>
References: <1043363627.3e30772b136d4@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?Gr=E9gory?= <gregory.wajs@free.fr>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <1043363627.3e30772b136d4@imp.free.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 24 January 2003 00:13, Gr=E9gory wrote:
> Hi,
> I'd like to make a "really" transparent bridge using a proxy.
> Though when  watching my logs on my server (behind the bridge), I
> always get the proxy IP  (which is normal). I'd like to know if
> there's an existing patch to iptables that could hide the proxy's
> adress by putting back the real source adress when the traffic is
> coming from Internet.

If I understand correctly, the bridge proxy will make new IP packets to t=
alk=20
with the server and therefore the IP packets have the proxy's IP. Because=
=20
these are new packets, it seems hard to get your requested behaviour usin=
g=20
iptables. I think it's much easier to hack the code of the proxy, maybe i=
t's=20
even already an option there.

--=20
cheers,
Bart
