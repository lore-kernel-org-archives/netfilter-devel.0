From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: RE: LAND check: 2.4.20
Date: Tue, 15 Mar 2005 17:52:36 +0100
Message-ID: <1110905556.5602.84.camel@anduril.intranet.cartel-securite.net>
References: <BB6D74C75CC76A419B6D6FA7C38317B26A263D@sinett-sbs.SiNett.LAN>
	<19921.213.236.112.75.1110904976.squirrel@213.236.112.75>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Vishwas Manral <Vishwas@sinett.com>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <19921.213.236.112.75.1110904976.squirrel@213.236.112.75>
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

Le mardi 15 mars 2005 =E0 17:42 +0100, Martijn Lievaart a =E9crit :
> They should be in your ruleset or you can use the Linux built in routing
> checks.

There are 2 major cases :

	. Packet is seen by a filtering box, then rp_filter should
	  destroy the packet as source is not routed through receiving
	  interface.
	. Packet is received by destination, then routing code will
	  destroy it as a packet with local IP as source must be
	  received on loopback.

I don't think there's a real security issue that implies hardcoding.


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
