From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: ARP filtering
Date: 07 Jun 2003 10:06:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054973179.740.0.camel@elendil.intranet.cartel-securite.net>
References: <3EE12C93.6090503@binary-one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jon Webb <jon_webb@binary-one.com>
In-Reply-To: <3EE12C93.6090503@binary-one.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le sam 07/06/2003 =E0 02:06, Jon Webb a =E9crit :
> Hi guys. I feel like this is a silly question. I can't find=20
> documentation on how to use the arp_tables and arp_filter netfilter=20
> modules. I have setup a fake multi-hop wireless network by filtering ma=
c=20
> addresses at each host, but after a while ARP breaks the network by=20
> getting through the mac filters. Any help is appreciated.

In the mean time, you can use ebtables :

	http://ebtables.sourceforge.net/

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
IT systems and networks security - Cartel S=E9curit=E9
Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
