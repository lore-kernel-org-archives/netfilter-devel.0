From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: OpenBSD Firewall Failover with pfsync and CARP, Netfilter
	solutions?
Date: Sun, 04 Apr 2004 12:25:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081074350.1649.68.camel@anduril.intranet.cartel-securite.net>
References: <20040330153008.GH1237@eychenne.org>
	 <20040404101851.GA19532@edu.joroinen.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
In-Reply-To: <20040404101851.GA19532@edu.joroinen.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le dim 04/04/2004 =E0 12:18, Pasi K=E4rkk=E4inen a =E9crit :
> I noticed this one too.. I'm wondering, if there is same functionality
> available for Linux ?

Not yet.

> ucarp runs on Linux too, as does vrrp, but the pfsync-part seems to be
> missing.. ?

It's pf specific. pf runs on BSD, not on Linux, the same way Netfilter
is specific to Linux.

> Is there any way to synchronize the state tables of two Linux/Netfilter
> boxes?

Harald seems to be working hard on this (libnfnetlink/libctnetlink). See
CVS.

--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
