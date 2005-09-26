From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: vlan target for iptables
Date: Mon, 26 Sep 2005 09:20:54 -0500
Message-ID: <1127744454.5004.27.camel@anduril.intranet.cartel-securite.net>
References: <dd80kc$n5o$1@sea.gmane.org>  <4337FC96.4080207@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <4337FC96.4080207@ufomechanic.net>
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

Le lundi 26 septembre 2005 =E0 14:50 +0100, Amin Azez a =E9crit :
> Am I supposed to do anything particular to get this included with iptable=
s?

Netfiflter/iptables is a layer 3+ filter. VLAN is a layer 2 concept that
Netfilter is not aware of.

BTW, you can use ebtables, wich is a layer 2 filter, to match VLANs.

	http://ebtables.sourceforge.net/


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
