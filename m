From: Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: [RFC] ipt_REJECT.c - option to use different ICMP source address
Date: Mon, 4 Nov 2002 23:43:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211042343.19949.bart.de.schuymer@pandora.be>
References: <20021102153451.N8635@sunbeam.de.gnumonks.org> <200211022032.46007.bart.de.schuymer@pandora.be> <20021104092757.C8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	bridge@math.leidenuniv.nl, Pekka Savola <pekkas@netcore.fi>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021104092757.C8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello netfilter team,

Since the bridge-netfilter code is in the 2.5 kernel, Linux networking li=
fe=20
gets some new interesting problems.

When a bridged IP packet is forwarded (inside the bridge code) it is seen=
 by=20
the iptables FORWARD chains.
There the REJECT target can be used. It seems most natural that the ICMP=20
message sent by this target should have the IP destination address of the=
=20
original message, as the IP source address of the ICMP message.
This should be the normal behaviour for a bridging firewall (as pointed o=
ut by=20
Pekka Savola) because first of all the bridge device could have no IP, an=
d=20
secondly, the IP message wasn't destined for the bridging box (on the MAC=
=20
level) so it is not good to have its IP address as source address by defa=
ult.

So, if I were to implement code inside ipt_REJECT.c (for 2.5) that checks=
 if=20
the packet is being bridged and we are on the NF_IP_FORWARD hook. And if =
so,=20
it uses the destination address of the original packet as the source addr=
ess=20
of the ICMP message. Would this then be accepted (if it looks ok)?
Ofcourse, this code would only be compiled if the bridge is enabled.

One can then use SNAT to force the IP address of the bridge instead of th=
is=20
default behaviour, if needed.

--=20
cheers,
Bart
